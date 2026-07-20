# CI/CD Setup Guide

This repository ships a complete GitHub Actions pipeline for the Flutter + Melos
monorepo (the buildable app lives in [`apps/`](apps/), Android project in
[`apps/android/`](apps/android/)).

- [Pipeline overview](#pipeline-overview)
- [The reusable engine (`_ci.yml`)](#the-reusable-engine-_ciyml)
- [The composite action (`setup-flutter`)](#the-composite-action-setup-flutter)
- [Trigger workflows](#trigger-workflows)
- [Required GitHub Secrets](#required-github-secrets)
- [Firebase App Distribution setup](#firebase-app-distribution-setup)
- [Signing configuration](#signing-configuration)
- [How to trigger each workflow](#how-to-trigger-each-workflow)
- [Build variants](#build-variants)
- [Versioning](#versioning)
- [Branch protection (required checks)](#branch-protection-required-checks)
- [Dependency updates](#dependency-updates)
- [Troubleshooting](#troubleshooting)

---

## Pipeline overview

| Workflow | File | Trigger | What it does |
|----------|------|---------|--------------|
| **PR** | [`pr.yml`](.github/workflows/pr.yml) | PR → `main` | Validate + build a `dev` **debug** APK (no secrets → fork-safe). |
| **CD** | [`cd.yml`](.github/workflows/cd.yml) | Push → `main` | Validate + build signed `prod` **release** APK → Firebase. |
| **Nightly** | [`nightly.yml`](.github/workflows/nightly.yml) | Cron 02:00 UTC | Signed `dev` release → Firebase "nightly" group. |
| **Release** | [`release.yml`](.github/workflows/release.yml) | Tag `v*.*.*` | Signed `prod` release → Firebase + GitHub Release + changelog. |
| **Security** | [`security.yml`](.github/workflows/security.yml) | Push/PR/weekly | CodeQL (Kotlin/Java) + OSV dependency scan. |
| _reusable engine_ | [`_ci.yml`](.github/workflows/_ci.yml) | `workflow_call` | validate → build → distribute. |
| _shared setup_ | [`actions/setup-flutter`](.github/actions/setup-flutter/action.yml) | composite | JDK + Flutter + caches + Melos bootstrap + **codegen**. |

The architecture is deliberately **one engine, many triggers**: all real logic
lives once in `_ci.yml`, and the five trigger workflows are thin callers that
pass different inputs. Change build behaviour there and every pipeline follows.
`security.yml` is the one exception — it is fully independent, because scanning
needs neither the Flutter toolchain nor a build.

```
pr.yml ──┐
cd.yml ──┤
nightly ─┼──> _ci.yml ──> validate ──> build ──> distribute
release ─┘                    │           │          │
                              └───────────┴──────────┴──> setup-flutter
security.yml ──> codeql + osv-scan   (independent, no build)
```

> **Why codegen runs in CI:** `*.g.dart` / `*.freezed.dart` are git-ignored, so a
> fresh checkout has no generated code. The setup action runs `melos run gen:env`,
> `build_runner`, `build_runner_feature` and `locale_gen` before any
> analyze/test/build. Without it those steps fail.

---

## The reusable engine (`_ci.yml`)

Called via `uses: ./.github/workflows/_ci.yml`. It is never triggered directly.

### Inputs

| Input | Type | Default | Purpose |
|-------|------|---------|---------|
| `flavor` | string | _required_ | Product flavor to build (`dev` \| `prod`). |
| `build-mode` | string | `release` | `release` or `debug`. |
| `entry-target` | string | _required_ | Dart entry point (e.g. `lib/main_dev.dart`). |
| `distribute` | boolean | `false` | Upload the APK to Firebase App Distribution. |
| `tester-groups` | string | `qa` | Comma-separated Firebase tester groups. |
| `run-tests` | boolean | `true` | Run unit tests during validation. |
| `artifact-retention-days` | number | `14` | How long uploaded artifacts are kept. |

Runs are deduplicated by a `concurrency` group keyed on workflow + ref + flavor,
so pushing twice to a branch cancels the superseded run and saves minutes.

### Jobs

**1. `validate`** — the fail-fast quality gate. Blocks everything downstream.

| Step | Purpose |
|------|---------|
| Checkout (`fetch-depth: 0`) | Full history for changelog/blame-based tooling. |
| Setup Flutter workspace | The composite action below. |
| Validate Gradle wrapper | Verifies the checked-in wrapper JAR isn't tampered with (supply-chain guard). |
| Check code formatting | `dart format --set-exit-if-changed` over **version-controlled** Dart files only, so git-ignored generated code can't cause false failures. |
| Static analysis | `melos exec -- flutter analyze`, which also runs the `dart_code_linter` plugin from `core/code_analyzer`. Output tee'd to `reports/`. |
| Run unit tests | `melos exec --dir-exists=test` — only packages that actually have a `test/` dir, avoiding "no tests found" false negatives. Collects coverage. |
| Upload reports | `always()`, so reports survive a failure. |

**2. `build`** — `needs: validate`. Produces the APK.

| Step | Purpose |
|------|---------|
| Configure release signing | Materializes the keystore + `keystore.properties` from secrets. **If `KEYSTORE_BASE64` is absent it exits cleanly** and Gradle falls back to debug signing — this is what makes fork PRs work. |
| Compute version metadata | `versionCode` = `github.run_number` (unique, monotonic); `versionName` from `apps/pubspec.yaml`. |
| Build APK | `flutter build apk` with flavor, mode, target, `--build-number`, `--build-name`. |
| Locate APK | Finds the artifact by glob, since the root `build.gradle.kts` relocates the build dir. Hard-fails if not found. |
| Upload APK | `if-no-files-found: error` — a missing APK is a real failure. |
| Upload R8 mapping | `if-no-files-found: ignore` — only exists when minify is on. |

**3. `distribute`** — `needs: build`, gated on `if: inputs.distribute`. Downloads
the APK artifact, generates human-readable release notes (flavor, build number,
branch, commit, recent commit subjects) and uploads to Firebase App Distribution.

---

## The composite action (`setup-flutter`)

[`.github/actions/setup-flutter/action.yml`](.github/actions/setup-flutter/action.yml)
is the single source of truth for preparing any job. Every job that touches Dart
uses it, so toolchain versions and caching stay consistent by construction.

| Input | Default | Purpose |
|-------|---------|---------|
| `java-version` | `17` | JDK for the Android/Gradle toolchain. |
| `flutter-version` | `3.44.4` | Pinned Flutter SDK — keep in sync with the team's stable channel. |
| `run-codegen` | `true` | Run envied / build_runner / l10n generation. |

Steps, in order:

1. **JDK** — `actions/setup-java` (Temurin).
2. **Gradle** — `gradle/actions/setup-gradle`, caching `~/.gradle` and the
   configuration cache. Cache is **read-only off `main`** so branch builds can't
   poison the shared cache.
3. **Flutter SDK** — `subosito/flutter-action` with its own SDK cache.
4. **Pub cache** — `actions/cache` on `~/.pub-cache`, keyed on
   `hashFiles('**/pubspec.lock')`, so a dependency change busts it.
5. **Melos** — `dart pub global activate melos 8.0.0`, then `melos bootstrap`.
6. **Codegen** — `gen:env` → `build_runner` (domain, data) → `build_runner_feature`
   → `locale_gen`. **Order matters**; later generators consume earlier output.

---

## Trigger workflows

Each is a thin caller. All pass `secrets: inherit` so the engine can reach the
signing and Firebase secrets.

- **`pr.yml`** — `dev` + `debug`, `distribute: false`, 7-day artifacts. Skips
  draft PRs (`if: !github.event.pull_request.draft`) to save minutes. Needs no
  secrets, so it works for fork PRs.
- **`cd.yml`** — `prod` + `release`, distributes to `qa`, 30-day artifacts.
  `paths-ignore` skips doc-only pushes. `workflow_dispatch` allows overriding
  tester groups for a manual run.
- **`nightly.yml`** — `dev` + `release`, distributes to the `nightly` group,
  14-day artifacts. Cron `0 2 * * *` (UTC, best-effort) plus manual dispatch.
- **`release.yml`** — `prod` + `release` on a `v*.*.*` tag, 90-day artifacts.
  Adds a second `github-release` job (`contents: write`) that builds a changelog
  from commits since the previous tag, renames the APK to `unsaid-<tag>.apk` and
  publishes a GitHub Release. Tags containing `-` are marked prerelease.
- **`security.yml`** — two independent jobs. `codeql` analyses Kotlin/Java with
  `build-mode: none` (source-only, no Gradle build needed). `osv-scan` checks
  every committed lockfile against the OSV database and uploads SARIF. The scan
  step is `continue-on-error` so a newly disclosed CVE reports without blocking.

All workflows declare least-privilege `permissions: contents: read` at the top
and escalate only per-job where required.

---

## Required GitHub Secrets

Add these under **Settings ▸ Secrets and variables ▸ Actions ▸ New repository
secret**. Signing/Firebase secrets are only needed for the CD, nightly and
release workflows — PRs run fine without them.

| Secret | Required for | Description |
|--------|--------------|-------------|
| `KEYSTORE_BASE64` | signing | Base64 of your upload keystore (`.jks`). |
| `KEYSTORE_PASSWORD` | signing | Keystore (store) password. |
| `KEY_ALIAS` | signing | Key alias inside the keystore. |
| `KEY_PASSWORD` | signing | Key password for that alias. |
| `FIREBASE_APP_ID` | distribution | Firebase **App ID** (e.g. `1:123:android:abc`). |
| `FIREBASE_SERVICE_ACCOUNT` | distribution | **Full JSON** of a service account with App Distribution access. |

> Nothing sensitive is ever committed. `.gitignore` blocks `*.jks`,
> `keystore.properties`, `key.properties` and `firebase-service-account.json`.

### Generating `KEYSTORE_BASE64`

```bash
# From an existing keystore:
base64 -i upload-keystore.jks | pbcopy      # macOS (paste into the secret)
base64 -w0 upload-keystore.jks              # Linux
```

To create a fresh upload keystore first:

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

---

## Firebase App Distribution setup

1. In the [Firebase console](https://console.firebase.google.com/), open the
   Android app for the flavor you distribute. The app IDs already exist in the
   committed `google-services.json` files:
   - prod: `apps/android/app/src/prod/google-services.json`
   - dev: `apps/android/app/src/dev/google-services.json`
2. Copy the **App ID** (`mobilesdk_app_id`) into the `FIREBASE_APP_ID` secret.
   > The `applicationId` for the `dev` flavor is `com.user.unsaid.dev` — make
   > sure the Firebase app you target matches the flavor built by each workflow.
3. Create a **service account** (Google Cloud ▸ IAM ▸ Service Accounts) with the
   **Firebase App Distribution Admin** role, create a JSON key, and paste the
   whole file contents into `FIREBASE_SERVICE_ACCOUNT`.
4. In Firebase ▸ App Distribution ▸ **Testers & Groups**, create the groups the
   workflows reference: `qa` (CD/release) and `nightly` (nightly). Adjust the
   `tester-groups` inputs in the workflows if you use different names.

---

## Signing configuration

[`apps/android/app/build.gradle.kts`](apps/android/app/build.gradle.kts) reads
signing credentials from `apps/android/keystore.properties`:

```properties
KEYSTORE_FILE=upload-keystore.jks
KEYSTORE_PASSWORD=********
KEY_ALIAS=upload
KEY_PASSWORD=********
```

- **In CI** this file (and the `.jks`) are generated from the secrets above by the
  _Configure release signing_ step, then deleted with the runner.
- **Locally**, create both files by hand (they are git-ignored) to build a
  signed release; otherwise the release build **automatically falls back to
  debug signing** so it still produces an installable APK.

### R8 / code shrinking

R8 is **enabled** for both release variants (`devRelease`, `prodRelease`) —
`isMinifyEnabled` and `isShrinkResources` are both `true`. Keep rules live in
[`proguard-rules.pro`](apps/android/app/proguard-rules.pro), grouped by the
library that needs them (Flutter embedding, Gson, Firebase, Play Core, WebView,
Clarity, secure storage).

R8 only processes the **JVM half** of the app. All Dart code is AOT-compiled
into `libapp.so` and is never shrunk or obfuscated, so Dio and Dart-side JSON
serialization need no rules. The risk surface is reflection from plugins.

`mapping.txt` is produced on every release build, and the pipeline already
uploads it as an artifact — required to de-obfuscate Crashlytics stack traces.
The rules keep `SourceFile,LineNumberTable` so line numbers survive.

---

## How to trigger each workflow

- **PR checks** — open a PR against `main` (draft PRs are skipped until "ready").
- **Deliver to QA** — merge/push to `main`, or run **CD (main)** from the Actions
  tab (`workflow_dispatch`, lets you override tester groups).
- **Nightly** — automatic at 02:00 UTC; or run **Nightly** manually.
- **Public release** — push a semver tag:
  ```bash
  git tag v1.2.0 && git push origin v1.2.0
  ```
  Produces a GitHub Release with an auto changelog + attached APK.
- **Security scans** — automatic on push/PR and weekly.

---

## Build variants

Two independent axes produce the four variants:

```
  flavor    (dev | prod)      → base URL, app identity, Firebase project
  buildType (debug | release) → logging, debug tooling, R8
```

| Variant | Backend | Logging | R8 | applicationId | Label |
|---------|---------|---------|----|---------------|-------|
| `devDebug` | development | ✅ all on | ❌ | `com.user.unsaid.dev` | Unsaid Dev |
| `devRelease` | development | ❌ all off | ✅ | `com.user.unsaid.dev` | Unsaid Dev |
| `prodDebug` | production | ✅ all on | ❌ | `com.user.unsaid` | Unsaid |
| `prodRelease` | production | ❌ all off | ✅ | `com.user.unsaid` | Unsaid |

**The flavor and the Dart entry point must be paired correctly** — Gradle's
`--flavor` selects the app identity and `google-services.json`, while
`--target` selects the base URL. Mismatching them yields a prod-signed app
talking to the dev backend, with nothing to stop you:

```bash
# Run
flutter run --flavor dev  --debug   --target=lib/main_dev.dart
flutter run --flavor prod --debug   --target=lib/main_prod.dart

# Build
flutter build apk --flavor dev  --debug   --target=lib/main_dev.dart
flutter build apk --flavor dev  --release --target=lib/main_dev.dart
flutter build apk --flavor prod --debug   --target=lib/main_prod.dart
flutter build apk --flavor prod --release --target=lib/main_prod.dart
```

Every CI workflow passes a matching pair via the `flavor` / `entry-target`
inputs of `_ci.yml`.

### APK output names

Each build produces **two** files:

| Location | Name | Purpose |
|----------|------|---------|
| `build/app/outputs/flutter-apk/` | `app-<flavor>-<mode>.apk` | Canonical. Required by `flutter build/run` and the CI `Locate APK` step. |
| `build/app/outputs/renamed-apk/` | `unsaid_<date>_<time>_<version>_<flavor>_<buildType>.apk` | Human-readable, for sharing/archiving. |

e.g. `unsaid_2026-07-20_16-35-39_1.0.0_prod_release.apk`

The friendly copy is generated by the `renameApk<Variant>` tasks in
[`build.gradle.kts`](apps/android/app/build.gradle.kts), wired via `finalizedBy`
on each `assemble<Variant>` task.

Two constraints shaped this, both worth preserving if you change it:

- **It is a copy, not a rename.** The Flutter Gradle plugin hardcodes the
  canonical name, and `flutter build apk` errors out if that exact file is
  missing. AGP's `outputFileName` can't override it either.
- **It writes to its own directory.** Pointing the task at the shared
  `flutter-apk/` folder makes Gradle's stale-output cleanup delete every file in
  it that the task didn't produce — silently destroying the canonical APK.

Timestamps are evaluated at execution time. A no-op rebuild leaves the task
`UP-TO-DATE` and the old timestamp stands, correctly reflecting when the APK was
actually built. Each variant keeps only its most recent copy.

### Where variant behaviour is decided

- **Base URL / secrets** — [`core/app_env`](core/app_env/), envied-backed
  (`.env_development`, `.env_production`), surfaced through `AppConfig`.
- **Debug features** — `DebugFeatures`, derived from `BuildVariant` (i.e.
  `kDebugMode`), *never* from the environment. This is what keeps `devRelease`
  silent while still pointing at the dev backend.
- **Identity / shrinking** — [`build.gradle.kts`](apps/android/app/build.gradle.kts).

Consume flags via `AppConfig.I.debugFeatures.<flag>`; never test `kDebugMode`
inline at a call site.

### Adding an environment (qa, staging, uat)

Additive, with no edits to existing flavors or build types:

1. `create("qa") { ... }` in `build.gradle.kts` + `src/qa/google-services.json`.
2. `AppEnvironment.qa`, a `.env_qa` file and a `QaEnv` envied class.
3. A branch in `AppConfig._envFieldsFor` and `apps/lib/main_qa.dart`.

Nothing about logging needs touching — a QA *release* is silent for the same
reason a prod release is.

---

## Versioning

Every build gets a **unique version code** = the workflow **run number**
(`github.run_number`), injected via `flutter build --build-number`. The version
name comes from `apps/pubspec.yaml`. The Gradle config
([`build.gradle.kts`](apps/android/app/build.gradle.kts)) reads these from
Flutter's `local.properties`, so no manual bumping is needed for CI builds.
Release notes/changelogs embed the short commit SHA, branch, run number and
timestamp for traceability.

---

## Branch protection (required checks)

To block merges on red CI: **Settings ▸ Branches ▸ Add rule** for `main` →
enable **Require status checks to pass** and select:

- `Validate (format · analyze · test)`
- `Build dev (debug)`

(Names come from the reusable workflow's job names as run by `pr.yml`.)

---

## Dependency updates

Dependency updates are **manual and deliberate** — there is no Dependabot config
and no automated bump job. Package versions change only when a human edits
`pubspec.yaml` and commits a matching `pubspec.lock`.

This is intentional. The workspace pins several packages that share a
transitive `analyzer` constraint (notably `freezed`, `build_runner` and
`intl_utils`); an automated single-package bump routinely produces an unsolvable
version graph. Bump these together, as one reviewed change.

To check what's available without changing anything:

```bash
melos run outdated        # Flutter packages
melos run outdated:all    # including pure Dart packages
```

Then edit the shared dependency block in the root [`pubspec.yaml`](pubspec.yaml),
run `melos bootstrap`, and commit the resulting lockfile.

---

## Troubleshooting

| Symptom | Likely cause / fix |
|---------|--------------------|
| `Target of URI hasn't been generated: *.g.dart` | Codegen didn't run/failed. Check the **Generate code** step; run `melos run gen:env && melos run build_runner && melos run build_runner_feature` locally. |
| `flutter analyze` fails only in CI | Run `dart format .` and `melos exec -- flutter analyze` locally; formatting drift and analyzer warnings both fail the gate. |
| Validate fails instantly on formatting | The format gate covers every tracked `.dart` file. Run `git ls-files '*.dart' -z \| xargs -0 dart format` and commit. |
| `version solving failed` mentioning `analyzer` | Incompatible bump across `freezed` / `build_runner` / `intl_utils`. See [Dependency updates](#dependency-updates) — these must move together. |
| `Could not locate built APK` | Flavor/mode mismatch. The APK glob expects `app-<flavor>-<mode>.apk`; confirm the `flavor`/`build-mode` inputs match `productFlavors` in `build.gradle.kts` (`dev`/`prod`). |
| Release APK installs but is unsigned / "App not installed" | Signing secrets missing → debug fallback. Verify `KEYSTORE_BASE64` et al. are set on the repo. |
| `No key with alias '<x>' found in keystore` | `KEY_ALIAS` in `keystore.properties` doesn't match the keystore. List the real aliases with `keytool -list -keystore <file>`. |
| Release build crashes/misbehaves only when minified | An R8 keep rule is missing for a reflection-based plugin. Reproduce with `flutter build apk --flavor prod --release`, then add a targeted `-keep` to `proguard-rules.pro`. De-obfuscate the trace with the `mapping.txt` artifact. |
| Firebase step: `INVALID_ARGUMENT` / `app not found` | `FIREBASE_APP_ID` doesn't match the built flavor's app, or the service account lacks the App Distribution Admin role. |
| `keystoreProperties["KEY_ALIAS"]` cast error | `keystore.properties` is missing a key. All four keys (`KEYSTORE_FILE/PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`) are required when present. |
| Gradle OOM | `org.gradle.jvmargs` is already `-Xmx8G` in `gradle.properties`; GitHub runners have ~7 GB. Lower to `-Xmx4G` if the build is killed. |
| Security workflow fails on `upload-sarif` / `analyze` | Code scanning requires **GitHub Advanced Security** on private repos. Enable it under Settings ▸ Code security, or make the repo public. |
| CodeQL reports nothing for Dart | Expected — CodeQL doesn't support Dart. Dart security relies on `flutter analyze` + the OSV dependency scan. |
| Nightly didn't run at exactly 02:00 | GitHub cron is best-effort and can lag under load; trigger **Nightly** manually if needed. |

---

_Keep this file in sync when you change workflow inputs, secrets or signing
behaviour._
