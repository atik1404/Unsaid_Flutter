# Unsaid

[![CD (main)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/cd.yml/badge.svg?branch=main)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/cd.yml)
[![PR](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/pr.yml/badge.svg)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/pr.yml)
[![Nightly](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/nightly.yml/badge.svg)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/nightly.yml)
[![Security](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/security.yml/badge.svg)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/security.yml)

**Unsaid** is a production-ready Flutter monorepo built on **Clean Architecture** and managed with [Melos](https://melos.invertase.dev/) native [Dart pub workspaces](https://dart.dev/tools/pub/workspaces). Every concern — domain logic, data access, UI, navigation, storage, localization — lives in its own isolated package with explicit dependencies, enabling scalable, independently testable feature modules.

> **CI/CD:** GitHub Actions pipeline (validate → build → Firebase App Distribution), plus nightly builds, tagged releases, CodeQL and dependency scanning. See **[CI_CD_SETUP.md](CI_CD_SETUP.md)** for setup, required secrets and troubleshooting.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
  - [Monorepo Structure](#monorepo-structure)
  - [Layer Breakdown](#layer-breakdown)
  - [Package Dependency Graph](#package-dependency-graph)
  - [Data Flow](#data-flow)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Bootstrap](#bootstrap-the-workspace)
  - [Environment & Firebase](#environment--firebase-setup)
  - [Build Flavors](#build-flavors)
  - [Melos Scripts](#melos-scripts)

---

## Tech Stack

### Core

| Technology | Version | Purpose |
|---|---|---|
| Flutter | `sdk: flutter` | UI framework |
| Dart | `^3.12.2` | Programming language |
| Melos | `^8.2.2` | Monorepo workspace management (pub workspaces) |

### State Management

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | `^9.1.1` | BLoC/Cubit state management |
| `freezed` | `^3.2.5` | Immutable state/union types |
| `freezed_annotation` | `^3.1.0` | Annotations for Freezed |
| `equatable` | `^2.1.0` | Value equality |
| `formz` | `^0.8.0` | Form input validation & state |
| `rxdart` | `^0.28.0` | Reactive streams |

### Navigation & DI

| Package | Version | Purpose |
|---|---|---|
| `go_router` | `^17.3.0` | Declarative routing |
| `get_it` | `^9.2.1` | Service locator / DI container |

### Networking

| Package | Version | Purpose |
|---|---|---|
| `dio` | `^5.10.0` | HTTP client (wrapped by `RestClient`) with interceptors |
| `background_downloader` | `^9.5.6` | Background file downloads |

### Firebase & Observability

| Package | Version | Purpose |
|---|---|---|
| `firebase_core` | `^4.12.1` | Firebase initialization |
| `firebase_auth` | `^6.5.6` | Authentication |
| `firebase_messaging` | `^16.4.3` | Push notifications |
| `firebase_crashlytics` | `^5.2.6` | Crash reporting |
| `firebase_analytics` | `^12.4.5` | Analytics |
| `clarity_flutter` | `^1.9.0` | Session analytics (Microsoft Clarity) |
| `logger` | `^2.7.0` | Structured logging |

### Storage & Cache

| Package | Version | Purpose |
|---|---|---|
| `flutter_secure_storage` | `^10.3.1` | Encrypted key-value storage |
| `shared_preferences` | `^2.5.5` | Lightweight key-value persistence |
| `sqflite` | `^2.4.3` | Local SQLite database |
| `cached_network_image` | `^3.4.1` | Image caching |

### Configuration

| Package | Version | Purpose |
|---|---|---|
| `envied` | `^1.3.8` | Compile-time environment secrets (per-flavor `.env`) |
| `package_info_plus` | `^10.2.1` | App/build metadata |
| `in_app_update` | `^5.0.0` | Android in-app updates |

### Localization

| Package | Version | Purpose |
|---|---|---|
| `intl` | `^0.20.2` | Internationalization & formatting |
| `flutter_localizations` | `sdk: flutter` | Flutter localization delegates |
| `intl_utils` | `^2.8.14` | ARB file code generation |

### UI & Design

| Package | Version | Purpose |
|---|---|---|
| `flutter_screenutil` | `^5.9.3` | Adaptive screen size & font scaling |
| `flutter_svg` | `^2.3.0` | SVG rendering |
| `lottie` | `^3.5.1` | Lottie animations |
| `carousel_slider` | `^5.1.2` | Carousels |
| `font_awesome_flutter` | `^11.0.0` | Icon set |
| `flutter_widget_from_html` / `flutter_html` | `^0.17.2` / `^3.0.0` | HTML rendering |
| `flutter_inappwebview` / `webview_flutter` | `^6.1.5` / `^4.14.1` | Embedded web views |
| `cupertino_icons` | `^1.0.9` | iOS-style icons |
| Poppins | (local font) | App-wide typography |

### Platform & Media

| Package | Version | Purpose |
|---|---|---|
| `image_picker` | `^1.2.3` | Camera / gallery selection |
| `flutter_image_compress` | `^2.5.0` | Image compression |
| `flutter_local_notifications` | `^22.1.0` | Local notifications |
| `permission_handler` | `^12.0.3` | Runtime permissions |
| `url_launcher` | `^6.3.2` | External links |
| `path_provider` / `path` | `^2.1.6` / `^1.9.1` | Filesystem paths |

### Utilities

| Package | Version | Purpose |
|---|---|---|
| `jiffy` | `^6.4.5` | Date & time parsing/formatting |
| `fluttertoast` | `^9.1.0` | Toast messages |

### Code Generation

| Package | Version | Purpose |
|---|---|---|
| `build_runner` | `^2.15.0` | Code generation runner |
| `json_serializable` / `json_annotation` | `^6.14.0` / `^4.12.0` | JSON serialization |
| `envied_generator` | `^1.3.8` | Generates env classes from `.env` files |

### Code Quality & Testing

| Package | Version | Purpose |
|---|---|---|
| `dart_code_linter` | `^4.1.7` | Static analysis & custom lint rules |
| `flutter_lints` | `^6.0.0` | Recommended Flutter lint rules |
| `bloc_test` | `^10.0.0` | BLoC/Cubit testing utilities |
| `mocktail` | `^1.0.5` | Mocking without code generation |
| `mockito` | `^5.7.0` | Mock generation for unit tests |

### Supported Locales

- English (`en_US`)
- Bengali (`bn_BD`)

---

## Architecture

Unsaid follows **Clean Architecture** organised as a **Melos / pub-workspace monorepo**. Each concern lives in its own Dart package under one of four top-level groups — `apps/`, `core/`, `shared/`, and `data/` + `domain/` — plus feature packages under `features/`. Packages declare explicit dependencies on one another, enforcing strict layer boundaries.

### Monorepo Structure

```
unsaid/
├── apps/                          # Flutter application entry point (package: app)
│   └── lib/
│       ├── main_dev.dart          # Dev flavor entry
│       ├── main_prod.dart         # Prod flavor entry
│       ├── bootstrap.dart         # Env → Firebase → DI → runApp
│       ├── app_entry.dart         # AppEntry + MultiBlocProvider + MaterialApp.router
│       ├── app_di.dart            # App-level DI wiring
│       └── theme_config.dart      # Light/dark theme construction
│
├── core/
│   ├── common/                    # Shared utilities, extensions, base types
│   ├── entity/                    # Pure domain data models / entities
│   ├── app_env/                   # Envied-based per-flavor config & secrets
│   └── code_analyzer/             # Shared lint rules (dart_code_linter)
│
├── domain/                        # Business logic (pure Dart)
│   └── lib/src/
│       ├── repository/            # Abstract repository interfaces
│       ├── usecase/               # Single-responsibility use cases
│       ├── params/                # Use-case parameter objects
│       └── di/                    # Domain DI registrations
│
├── data/                          # Data layer (implements domain contracts)
│   └── lib/src/
│       ├── client/                # RestClient (Dio wrapper)
│       ├── interceptor/           # Auth / logging / error interceptors
│       ├── datasource/            # Remote & local data sources
│       ├── dto/                   # API response/request DTOs
│       ├── mapper/                # DTO ⇄ entity mappers
│       └── di/                    # Data DI registrations
│
├── shared/
│   ├── designsystem/              # Design tokens: colours, typography, icons, SVGs
│   ├── ui/                        # Reusable widgets built on the design system
│   ├── navigation/                # GoRouter config & route definitions
│   ├── di/                        # Root GetIt container assembly
│   ├── localization/              # ARB-based i18n + LocalizationCubit
│   └── pref_storage/              # shared_preferences + flutter_secure_storage wrappers
│
└── features/
    ├── auth/                      # login · signup · splash · onboarding
    │                              # forgot_password · reset_password · otp_verification
    ├── user/                      # profile · edit_profile · setting · notification
    │                              # change_password · delete_account
    └── posts/                     # home · create_post · post_details
```

### Layer Breakdown

#### Presentation Layer — `apps/`, `features/*`
- Each feature is an independent Flutter package with its own screens, routes, and BLoC/Cubit.
- The `app` package (in `apps/`) is the composition root: `bootstrap.dart` resolves the environment config, initializes Firebase, wires DI, then renders `AppEntry`.
- `AppEntry` provides app-wide `LocalizationCubit` and `ThemeCubit` and mounts `MaterialApp.router` with the shared `GoRouter`.

#### Domain Layer — `domain/`
- **Abstract repository interfaces** define contracts with no implementation coupling.
- **Use cases** encapsulate single business operations, taking typed `params`.
- Pure Dart — no dependency on `data`, `flutter`, or transport concerns.

#### Data Layer — `data/`
- Implements repository interfaces from `domain`.
- `RestClient` wraps `Dio` and installs interceptors (auth, logging, error handling).
- **Mappers** convert `dto` models into `entity` domain models.

#### Core — `core/*`
- `entity` — domain data models shared across `domain` and `data`.
- `common` — shared utilities, extensions, and base abstractions.
- `app_env` — `AppConfig` resolves the active flavor to base URLs and secrets via **envied**-generated classes (`DevEnv`, `ProdEnv`).
- `code_analyzer` — shared `analysis_options` and custom lint rules applied across every package.

#### Shared — `shared/*`
- `designsystem` — single source of truth for colours, text styles, spacing, and SVG assets.
- `ui` — higher-level reusable widgets (buttons, inputs, cards) built from the design system.
- `navigation` — owns the `GoRouter` configuration and named routes; references feature screens.
- `di` — assembles the root `GetIt` container from each package's registrations.
- `localization` — ARB translations generated with `intl_utils`; exposes `LocalizationCubit` for runtime locale switching.
- `pref_storage` — `AppPrefStorage` over `shared_preferences` plus a `secure_storage` wrapper over `flutter_secure_storage`.

### Package Dependency Graph

```
app (apps/)
 ├── navigation ──────────► feature packages (login, splash, home, …)
 ├── di ──────────────────► data ──► domain ──► entity / common
 │                          │        └── response DTOs (data/lib/src/dto)
 │                          └── pref_storage, app_env
 ├── designsystem ◄──────── ui
 ├── localization ──► common
 ├── app_env         (envied config & secrets)
 └── firebase_core / auth / messaging / crashlytics / analytics
```

### Data Flow

```
UI (feature screen)
   │  dispatches Event
   ▼
BLoC / Cubit
   │  calls
   ▼
Use Case  (domain)
   │  calls abstract Repository
   ▼
Repository Implementation  (data)
   │  calls RestClient (Dio)  ──►  Remote API
   ▼  maps DTO → Entity
Entity  ──►  returned up the chain to UI
```

---

## Features

| Domain | Feature | Package |
|---|---|---|
| Auth | Splash | `features/auth/splash` |
| Auth | Onboarding | `features/auth/onboarding` |
| Auth | Login | `features/auth/login` |
| Auth | Signup | `features/auth/signup` |
| Auth | Forgot password | `features/auth/forgot_password` |
| Auth | Reset password | `features/auth/reset_password` |
| Auth | OTP verification | `features/auth/otp_verification` |
| User | Profile | `features/user/profile` |
| User | Edit profile | `features/user/edit_profile` |
| User | Change password | `features/user/change_password` |
| User | Settings | `features/user/setting` |
| User | Notifications | `features/user/notification` |
| User | Delete account | `features/user/delete_account` |
| Posts | Home / feed | `features/posts/home` |
| Posts | Create post | `features/posts/create_post` |
| Posts | Post details | `features/posts/post_details` |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.12.2`
- Dart SDK `>=3.12.2`
- [Melos](https://melos.invertase.dev/) `^8.x` (declared as a workspace dev dependency; activate globally to use the `melos` CLI):

```bash
dart pub global activate melos
```

### Bootstrap the workspace

```bash
melos bootstrap   # or: melos bs
```

This resolves and links all packages across the pub workspace.

### Environment & Firebase setup

The app is flavored and reads secrets at compile time via **envied**. Two env files back the generated config in `core/app_env`:

- `core/app_env/.env_development` → `DevEnv`
- `core/app_env/.env_production` → `ProdEnv`

After editing an env file, regenerate the typed classes:

```bash
melos run gen:env
```

Firebase is initialized in `apps/lib/bootstrap.dart` using `default_firebase_options.dart`. Provide your own Firebase config (via FlutterFire) and the platform config files (`google-services.json` / `GoogleService-Info.plist`) for the app to run.

### Build flavors

The app ships **dev** and **prod** flavors, each with its own entry point.

Run locally:

```bash
cd apps

# Development
flutter run --flavor dev  -t lib/main_dev.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

Build release APKs via Melos:

```bash
melos run build:apk:development:release   # dev flavor, release APK
melos run build:apk:production:release    # prod flavor, release APK
```

### Melos Scripts

| Script | Purpose |
|---|---|
| `melos run analyze` | `flutter analyze` across all packages |
| `melos run clean_and_get` | Clean every package then re-bootstrap |
| `melos run gen:env` | Generate envied env classes (`app_env`) |
| `melos run build_runner` | Run build_runner for `domain` + `data` |
| `melos run build_runner_feature` | Run build_runner for feature packages |
| `melos run locale_gen` | Generate localization from ARB files |
| `melos run outdated` / `outdated:all` | Report outdated dependencies |
| `melos run update_minor_deps` | Apply minor dependency updates |
| `melos run update_major_deps` | Apply major dependency updates |
| `melos run update_overrides` | Regenerate pubspec overrides & bootstrap |

Run the test suites across packages:

```bash
melos exec -- flutter test
```
