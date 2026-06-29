# Codebase Analysis — `unsaid_flutter`

> Generated: 2026-06-28 · Branch: `dev` · Reviewer: automated codebase audit

A prioritized backlog of missing features, incomplete implementations, technical debt, and refactoring opportunities.

---

## 1. Overview

| | |
|---|---|
| **Stack** | Flutter · Melos monorepo · Clean Architecture |
| **State management** | BLoC / Cubit + Freezed |
| **Networking** | Dio (`RestClient` wrapper) |
| **DI** | GetIt |
| **Routing** | GoRouter |
| **Source files** | ~304 Dart files across ~35 packages |
| **Locales** | English (`en_US`), Bengali (`bn_BD`) |

**Overall health.** The architecture, networking layer, and design system are solid and consistent. The main gaps are:

1. **Simulated / mocked features that look complete but aren't wired to the backend** (auth recovery flows, notifications, settings persistence).
2. **A complete absence of automated tests.**
3. **Dead code and security-hygiene issues** (plaintext secret logging, bypassable OTP).

### Severity legend

| Tag | Meaning |
|---|---|
| 🔴 P0 | Critical — correctness or security |
| 🟠 P1 | Incomplete features (UI done, backend faked) |
| 🟡 P2 | Testing |
| 🟢 P3 | Dead code & duplication |
| 🔵 P4 | Architecture / quality |
| 📘 P5 | Documentation |

### Complexity legend

`Low` = < ½ day · `Medium` = ½–2 days · `High` = > 2 days

---

## 2. 🔴 P0 — Critical (correctness / security)

### P0-1 · OTP verification is faked
- **Description:** `verifyOtp()` runs `Future.delayed(2s)` and then always sets `isSuccess = true`. It never calls `VerifyOtpUseCase` (which exists and is DI-registered, but is used in **0** files). Any entered code is accepted — the verification step provides no actual security.
- **Files:** `features/auth/otp_verification/lib/src/state/otp_verification_cubit.dart:48-58`
- **Complexity:** Medium
- **Next steps:** Inject and call `VerifyOtpUseCase`; emit failure on invalid/expired codes; surface server errors via l10n.

### P0-2 · Reset password is faked
- **Description:** Simulated delay, always succeeds. No use case, no repository method, no API call — the password is never changed on the backend.
- **Files:** `features/auth/reset_password/lib/src/state/reset_password_cubit.dart`
- **Complexity:** Medium
- **Next steps:** Add `resetPassword` to `AuthRepository` + domain use case; wire the cubit; handle field-level errors.

### P0-3 · Change password is faked
- **Description:** Same pattern as reset — simulated delay, always succeeds, no API.
- **Files:** `features/user/change_password/lib/src/state/change_password_cubit.dart`
- **Complexity:** Medium
- **Next steps:** Add `changePassword` to `AuthRepository` + use case; wire the cubit.

### P0-4 · Passwords & tokens logged in plaintext
- **Description:** `AppLog.log('oldPassword: …, newPassword: …')` (and the reset equivalent) write credentials to logs. `LoginBloc` `debugPrint`s the access token.
- **Files:**
  - `features/user/change_password/lib/src/state/change_password_cubit.dart:28`
  - `features/auth/reset_password/lib/src/state/reset_password_cubit.dart:24`
  - `features/auth/login/lib/src/bloc/login_bloc.dart:73`
- **Complexity:** Low
- **Next steps:** Remove all secret logging; add a lint/guard to prevent regressions.

### P0-5 · `removeReact` uses the wrong HTTP verb
- **Description:** `removeReact` issues `POST /posts/{id}/reactions` — identical to `addReact`. It should almost certainly be `DELETE` (the `RestClient.delete` helper already exists). Reaction removal likely never happens server-side.
- **Files:** `data/lib/src/datasource/src/post_repo_impl.dart:70-77`
- **Complexity:** Low
- **Next steps:** Switch to `_restClient.delete(...)`; verify against the API contract.

---

## 3. 🟠 P1 — Incomplete features (UI complete, backend faked)

### P1-6 · Notifications are fully mocked
- **Description:** `NotificationCubit.loadNotifications()` returns a hardcoded list of 8 fake notifications after an artificial delay. There is **no domain or data layer** for notifications — this violates the architecture used everywhere else in the app.
- **Files:** `features/user/notification/lib/src/state/notification_cubit.dart`
- **Complexity:** High
- **Next steps:** Add a notifications repository/use case + DTO/mapper/entity; replace the hardcoded list with a real fetch; implement read/markAll against the API.

### P1-7 · Settings toggles are not persisted
- **Description:** `allowAnonymousDms`, `ghostMode`, `pushNotifications`, `soundEnabled` only `emit()` to state — never written to prefs or the backend, so they reset on screen exit. The alias is demo data (`'ghost_8899'`).
- **Files:**
  - `features/user/setting/lib/src/state/setting_cubit.dart:35-45`
  - `features/user/setting/lib/src/widgets/setting_menu_list.dart:21`
- **Complexity:** Medium
- **Next steps:** Persist toggles (prefs and/or backend); wire real alias generation.

### P1-8 · Reaction type hardcoded; weak reaction model
- **Description:** Reaction submission is hardcoded to `'support'` — the user can't choose a reaction. State is a bare `isReacted` boolean: no reaction count and no server-provided initial value.
- **Files:** `features/posts/post_details/lib/src/state/post_details_bloc.dart:102`
- **Complexity:** Medium
- **Next steps:** Add reaction-type selection UI; model counts; hydrate initial reacted state from the server.

### P1-9 · Profile post tap is a no-op; profile card uses fake data
- **Description:** `onTap: () {}` so a post can't be opened from the profile. The card also shows hardcoded `'Anonymous User'`, a hardcoded dreamstime.com avatar URL, and `DateTime.now()` instead of real author/timestamp.
- **Files:** `features/user/profile/lib/src/widgets/profile_post_list.dart:40,91-93`
- **Complexity:** Medium
- **Next steps:** Navigate to post details on tap; bind real author/avatar/timestamp from the entity.

### P1-10 · Home search button is a no-op
- **Description:** Search icon `onPressed: () {}` — search is not implemented.
- **Files:** `features/posts/home/lib/src/home_screen.dart:78`
- **Complexity:** High
- **Next steps:** Design a search screen/endpoint; add use case + bloc.

### P1-11 · Social login / sign-up buttons are no-ops
- **Description:** Google/Facebook buttons have empty handlers (documented as placeholders).
- **Files:** `features/auth/signup/lib/src/signup_screen.dart:393-395`
- **Complexity:** Medium
- **Next steps:** Integrate the chosen OAuth providers or hide the buttons until ready.

### P1-12 · Create post is text-only
- **Description:** Media/image support is not implemented; `type: 'text'` is hardcoded.
- **Files:** `features/posts/create_post/lib/src/state/create_post_bloc.dart:46-47`
- **Complexity:** Medium
- **Next steps:** Add media picker + upload; extend params/DTO to carry media.

### P1-13 · `resendOtp()` doesn't actually resend
- **Description:** Only restarts the countdown timer; doesn't re-trigger `SendOtpUseCase`.
- **Files:** `features/auth/otp_verification/lib/src/state/otp_verification_cubit.dart:38-42`
- **Complexity:** Low
- **Next steps:** Call `SendOtpUseCase` on resend; handle errors.

### P1-14 · Hardcoded English error in forgot-password
- **Description:** Uses a literal string (`'User with this phone number does not exist'`) instead of an l10n key.
- **Files:** `features/auth/forgot_password/lib/src/state/forgot_password_cubit.dart:38`
- **Complexity:** Low
- **Next steps:** Replace with a localized key.

---

## 4. 🟡 P2 — Testing

### P2-15 · Zero automated tests in the repo
- **Description:** `melos run test` is documented but there are no `*_test.dart` files anywhere. `login/test/helpers` and `login/test/src` directories are empty. `mockito` is a declared dependency but unused.
- **Files:** repo-wide
- **Complexity:** High
- **Next steps:**
  1. Add `bloc_test` coverage for wired blocs: `HomeBloc`, `CreatePostBloc`, `PostDetailsBloc`, `LoginBloc`, `ProfileBloc`.
  2. Unit-test mappers and `RestClient` error mapping.
  3. Add a CI step running `melos run test`.

---

## 5. 🟢 P3 — Dead code & duplication

### P3-16 · Four empty leftover packages
- **Description:** `features/auth/{change_password, notification, profile, setting}` contain only `.dart_tool/`. The real versions live under `features/user/`.
- **Complexity:** Low — **quick win**
- **Next steps:** Delete the empty directories.

### P3-17 · Dead localization strings
- **Description:** `home_mock_post_*`, `profile_mock_post_*`, `profile_mock_user_*` (EN + BN) are defined but referenced nowhere. Left over from when feeds were mocked; repos now hit the real API.
- **Files:** `shared/localization` ARB files + generated localizations
- **Complexity:** Low — **quick win**
- **Next steps:** Remove unused keys and regenerate localizations.

### P3-18 · Orphaned `VerifyOtpUseCase`
- **Description:** Defined and DI-registered but never used (because OTP is faked — see P0-1).
- **Files:** `domain/lib/src/usecase/auth/verify_otp_use_case.dart`
- **Complexity:** Low
- **Next steps:** Wire it (preferred, via P0-1) or remove it.

### P3-19 · Duplicated password form + cubit logic
- **Description:** `password_form.dart` is duplicated across reset_password & change_password, and the simulated cubit logic is near-identical.
- **Files:** `features/auth/reset_password/...`, `features/user/change_password/...`
- **Complexity:** Medium
- **Next steps:** Extract a shared widget + base flow.

### P3-20 · Repeated `Failure.message` switch
- **Description:** The `RawStringMessage` / `LocaleKeyMessage` switch is copy-pasted in nearly every bloc/cubit.
- **Files:** most blocs/cubits
- **Complexity:** Low
- **Next steps:** Extract a `Failure.resolve(context)` extension/helper.

---

## 6. 🔵 P4 — Architecture / quality

### P4-21 · Notifications & Settings bypass Clean Architecture
- **Description:** These two features have no domain/data layer while the rest of the app strictly follows the pattern — an inconsistency that complicates maintenance and testing.
- **Files:** `features/user/{notification, setting}`
- **Complexity:** Medium
- **Next steps:** Introduce repository/use case layers (ties into P1-6 and P1-7).

### P4-22 · Global mutable auth state in the route guard
- **Description:** Uses a global `authStateNotifier` (acknowledged TODO) and contains a dead empty `if (context.mounted) {}` block.
- **Files:** `shared/navigation/lib/src/auth_route_guard.dart:27-29`
- **Complexity:** Medium
- **Next steps:** Inject auth state via DI; remove the dead block.

### P4-23 · No production error reporting
- **Description:** The Crashlytics call in `RestClient._logError` is commented out, so production errors go unreported.
- **Files:** `data/lib/src/client/src/rest_client.dart:209`
- **Complexity:** Low
- **Next steps:** Wire Crashlytics (or chosen reporter) for non-debug builds.

---

## 7. 📘 P5 — Documentation

### P5-24 · README is significantly outdated
- **Description:** The README documents `post_list` (now `home`) and lists `entity`/`response`/`cache/*`/`di`/`navigation` as top-level packages. Actual layout is `core/entity`, `data/.../dto` (no `response` package), `shared/pref_storage`, `shared/di`, `shared/navigation`. The Features status table omits onboarding, signup, forgot/reset/OTP, profile, settings, notifications, and post details.
- **Files:** `README.md`
- **Complexity:** Low
- **Next steps:** Rewrite structure + dependency graph; refresh the feature status table.

---

## 8. Summary by category

| Category | Count | Highlights |
|---|---|---|
| **Feature development** | 11 | Auth recovery flows (OTP/reset/change pw) and notifications are faked |
| **Bug fixes** | — | `removeReact` verb (P0-5), hardcoded reaction type (P1-8), profile post nav/data (P1-9) |
| **Security** | — | Plaintext password/token logging (P0-4), bypassable OTP (P0-1), no crash reporting (P4-23) |
| **Testing** | 1 | Nonexistent — highest-leverage gap (P2-15) |
| **Code quality** | 5 | 4 dead packages, dead l10n, 1 orphaned use case, duplicated forms & failure-mapping |
| **Architecture** | 3 | Two features skip domain/data layers; global auth state |
| **Documentation** | 1 | README rewrite needed |

---

## 9. Recommended execution order

1. **P0 security & correctness** — P0-1 … P0-5
2. **Test scaffolding** — P2-15 (so subsequent changes are safe)
3. **Real backends for faked features** — P1-6 (notifications), P1-7 (settings)
4. **Quick-win cleanup** — P3-16 (delete dead packages), P3-17/P3-18 (dead l10n/use case), P0-4 (strip logging), P0-5 (DELETE verb)
5. **Remaining features** — P1-8 … P1-14
6. **Architecture & docs** — P4-21 … P4-23, P5-24

### Quick wins (low risk, high signal)
- P3-16 — delete 4 empty leftover packages
- P0-5 — fix `removeReact` to use `DELETE`
- P0-4 — strip password/token logging
- P3-17 / P3-18 — remove dead l10n strings & orphaned use case
