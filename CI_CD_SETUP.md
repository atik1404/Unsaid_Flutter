# CI/CD Setup Guide

This repository ships a complete GitHub Actions pipeline for the Flutter + Melos
monorepo (the buildable app lives in [`apps/`](apps/), Android project in
[`apps/android/`](apps/android/)).

- [Pipeline overview](#pipeline-overview)
- [Required GitHub Secrets](#required-github-secrets)
- [Firebase App Distribution setup](#firebase-app-distribution-setup)
- [Signing configuration](#signing-configuration)
- [How to trigger each workflow](#how-to-trigger-each-workflow)
- [Versioning](#versioning)
- [Branch protection (required checks)](#branch-protection-required-checks)
- [Slack notifications](#slack-notifications)
- [Troubleshooting](#troubleshooting)

---

## Pipeline overview

| Workflow | File | Trigger | What it does |
|----------|------|---------|--------------|
| **PR** | [`pr.yml`](.github/workflows/pr.yml) | PR → `main` | Validate + build a `dev` **debug** APK (no secrets → fork-safe). |
| **CD** | [`cd.yml`](.github/workflows/cd.yml) | Push → `main` | Validate + build signed `prod` **release** APK → Firebase → Slack. |
| **Nightly** | [`nightly.yml`](.github/workflows/nightly.yml) | Cron 02:00 UTC | Signed `dev` release → Firebase "nightly" group. |
| **Release** | [`release.yml`](.github/workflows/release.yml) | Tag `v*.*.*` | Signed `prod` release → Firebase + GitHub Release + changelog. |
| **Security** | [`security.yml`](.github/workflows/security.yml) | Push/PR/weekly | CodeQL (Kotlin/Java) + OSV dependency scan. |
| _reusable engine_ | [`_ci.yml`](.github/workflows/_ci.yml) | `workflow_call` | validate → build → distribute → notify. |
| _shared setup_ | [`actions/setup-flutter`](.github/actions/setup-flutter/action.yml) | composite | JDK + Flutter + caches + Melos bootstrap + **codegen**. |
| **Dependabot** | [`dependabot.yml`](.github/dependabot.yml) | weekly | Update PRs for pub, Gradle, Actions. |

All the real logic lives once in `_ci.yml`; the trigger workflows just call it
with different inputs. Change build behaviour there and every pipeline follows.

> **Why codegen runs in CI:** `*.g.dart` / `*.freezed.dart` are git-ignored, so a
> fresh checkout has no generated code. The setup action runs `melos run gen:env`,
> `build_runner`, `build_runner_feature` and `locale_gen` before any
> analyze/test/build. Without it those steps fail.

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
| `SLACK_WEBHOOK_URL` | notifications _(optional)_ | Incoming-webhook URL. If unset, Slack step is skipped. |

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

### Enabling R8 / code shrinking (optional)

R8 is intentionally **off** to avoid runtime regressions. `proguard-rules.pro`
is already wired up. When you're ready, flip in `build.gradle.kts`:

```kotlin
isMinifyEnabled = true
isShrinkResources = true
```

Once enabled, `mapping.txt` is produced and the pipeline automatically uploads
it as an artifact (needed to de-obfuscate Crashlytics stack traces).

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

## Slack notifications

Set `SLACK_WEBHOOK_URL` to an [incoming webhook](https://api.slack.com/messaging/webhooks).
The `notify` job posts a colored success/cancel/failure card with a link back to
the run. No webhook → the step is silently skipped, so this is fully optional.
To swap in Discord/Teams/email, replace the single `curl` in the `notify` job of
[`_ci.yml`](.github/workflows/_ci.yml).

---

## Troubleshooting

| Symptom | Likely cause / fix |
|---------|--------------------|
| `Target of URI hasn't been generated: *.g.dart` | Codegen didn't run/failed. Check the **Generate code** step; run `melos run gen:env && melos run build_runner && melos run build_runner_feature` locally. |
| `flutter analyze` fails only in CI | Run `dart format .` and `melos exec -- flutter analyze` locally; formatting drift and analyzer warnings both fail the gate. |
| `Could not locate built APK` | Flavor/mode mismatch. The APK glob expects `app-<flavor>-<mode>.apk`; confirm the `flavor`/`build-mode` inputs match `productFlavors` in `build.gradle.kts` (`dev`/`prod`). |
| Release APK installs but is unsigned / "App not installed" | Signing secrets missing → debug fallback. Verify `KEYSTORE_BASE64` et al. are set on the repo. |
| Firebase step: `INVALID_ARGUMENT` / `app not found` | `FIREBASE_APP_ID` doesn't match the built flavor's app, or the service account lacks the App Distribution Admin role. |
| `keystoreProperties["KEY_ALIAS"]` cast error | `keystore.properties` is missing a key. All four keys (`KEYSTORE_FILE/PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`) are required when present. |
| Gradle OOM | `org.gradle.jvmargs` is already `-Xmx8G` in `gradle.properties`; GitHub runners have ~7 GB. Lower to `-Xmx4G` if the build is killed. |
| CodeQL reports nothing for Dart | Expected — CodeQL doesn't support Dart. Dart security relies on `flutter analyze` + the OSV dependency scan. |
| Nightly didn't run at exactly 02:00 | GitHub cron is best-effort and can lag under load; trigger **Nightly** manually if needed. |

---

_Generated as part of the CI/CD implementation. Keep this file in sync when you
change workflow inputs, secrets or signing behaviour._
