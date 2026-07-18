# Flutter Multi-Package Playground

[![CD (main)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/cd.yml/badge.svg?branch=main)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/cd.yml)
[![PR](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/pr.yml/badge.svg)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/pr.yml)
[![Nightly](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/nightly.yml/badge.svg)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/nightly.yml)
[![Security](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/security.yml/badge.svg)](https://github.com/atik1404/Flutter-Multi-Package-App/actions/workflows/security.yml)

A production-ready Flutter monorepo demonstrating Clean Architecture across multiple packages, managed with [Melos](https://melos.invertase.dev/). The project is structured to support scalable, maintainable, and independently testable feature modules.

> **CI/CD:** GitHub Actions pipeline (validate → build → Firebase App Distribution → notify), plus nightly builds, tagged releases, CodeQL and dependency scanning. See **[CI_CD_SETUP.md](CI_CD_SETUP.md)** for setup, required secrets and troubleshooting.

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

---

## Tech Stack

### Core

| Technology | Package | Purpose |
|---|---|---|
| Flutter | `sdk: flutter` | UI framework |
| Dart | `^3.11.4` | Programming language |
| Melos | `^7.5.1` | Monorepo workspace management |

### State Management

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | `^9.1.1` | BLoC/Cubit state management |
| `freezed` | `^3.2.5` | Immutable state/union types |
| `freezed_annotation` | `^3.0.0` | Annotations for Freezed |

### Navigation

| Package | Version | Purpose |
|---|---|---|
| `go_router` | `^17.2.0` | Declarative routing |

### Dependency Injection

| Package | Version | Purpose |
|---|---|---|
| `get_it` | `^9.2.1` | Service locator / DI container |

### Networking

| Package | Version | Purpose |
|---|---|---|
| `dio` | `^5.9.2` | HTTP client with interceptors |

### Storage & Cache

| Package | Version | Purpose |
|---|---|---|
| `flutter_secure_storage` | `^10.0.0` | Encrypted key-value storage |
| `shared_preferences` | `^2.5.5` | Lightweight key-value persistence |

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
| `flutter_svg` | `^2.2.4` | SVG rendering |
| `cupertino_icons` | `^1.0.9` | iOS-style icons |
| Poppins | (local font) | App-wide typography |

### Code Generation

| Package | Version | Purpose |
|---|---|---|
| `build_runner` | `^2.13.1` | Code generation runner |
| `json_serializable` | `^6.13.1` | JSON serialization |
| `json_annotation` | `^4.11.0` | JSON annotations |

### Utilities

| Package | Version | Purpose |
|---|---|---|
| `jiffy` | `^6.4.4` | Date & time parsing/formatting |

### Code Quality & Testing

| Package | Version | Purpose |
|---|---|---|
| `dart_code_linter` | `^4.0.2` | Static analysis & lint rules |
| `flutter_lints` | `^6.0.0` | Recommended Flutter lint rules |
| `mockito` | `^5.6.4` | Mock generation for unit tests |

### Supported Locales

- English (`en_US`)
- Bengali (`bn_BD`)

---

## Architecture

This project follows **Clean Architecture** principles organised as a **Melos monorepo**. Every concern (domain logic, data access, UI, navigation, caching, etc.) lives in its own isolated Dart package. Packages declare explicit dependencies on one another, enforcing strict layer boundaries and enabling independent testing and replacement.

### Monorepo Structure

```
flutter_multi_package_playground/
├── apps/                        # Main Flutter application entry point
├── features/
│   ├── auth/
│   │   ├── login/               # Login feature package
│   │   └── splash/              # Splash screen feature package
│   └── posts/
│       ├── post_list/           # Post list feature package
│       └── create_post/         # Create post feature package
├── domain/                      # Business logic: repositories (abstract), use cases
├── data/                        # Data layer: API clients, mappers, repository implementations
├── entity/                      # Pure data models / entities
├── response/                    # API response wrapper models
├── di/                          # Dependency injection wiring (GetIt)
├── navigation/                  # App routing (GoRouter) and route definitions
├── designsystem/                # Design tokens: colours, typography, icons, SVGs
├── ui/                          # Reusable UI components built on the design system
├── common/                      # Shared utilities and extensions
├── localization/                # ARB-based i18n and LocaleCubit
├── cache/
│   ├── database/                # Local database abstraction
│   ├── secured/                 # Encrypted storage (flutter_secure_storage)
│   └── sharedpref/              # Shared preferences wrapper
└── code_analyzer/               # Shared lint rules applied across all packages
```

### Layer Breakdown

#### Presentation Layer — `apps/`, `features/*`
- Each feature is an independent Flutter package with its own screens, routes, and (optionally) BLoC/Cubit.
- The `apps` package is the top-level entry point that wires everything together via `AppEntry` and `MultiBlocProvider`.
- Screens use `GoRouter`-based routing defined in the `navigation` package.

#### Domain Layer — `domain/`
- Contains **abstract repository interfaces** that define contracts without coupling to any implementation.
- Contains **use cases** (`base_use_case.dart`) that encapsulate single business operations.
- Has no dependency on `data`, `flutter`, or any external packages — pure Dart business logic.

#### Data Layer — `data/`
- Implements repository interfaces from `domain`.
- Contains the **network client** (`Dio`) with interceptors, API handlers, and a network factory.
- **Mappers** transform raw API response models (`response` package) into domain entities (`entity` package).

#### Entity & Response — `entity/`, `response/`
- `entity` — Domain-level data models shared across `domain` and `data`.
- `response` — Raw API response DTOs used only within the `data` layer.

#### Dependency Injection — `di/`
- Centralises all `GetIt` registrations.
- Wires together repositories, use cases, data sources, and storage implementations.
- The `apps` package calls `di` at startup before rendering any UI.

#### Navigation — `navigation/`
- Owns the `GoRouter` configuration and all named route definitions.
- Depends on feature packages (`login`, `splash`) to reference their screen widgets.
- Exposed to `apps` as a single `router` instance.

#### Cache — `cache/*`
- `secured` — Wraps `flutter_secure_storage` for token and sensitive data storage.
- `sharedpref` — Wraps `shared_preferences` for non-sensitive persistent settings.
- `database` — Abstraction layer for local database operations.

#### Design System & UI — `designsystem/`, `ui/`
- `designsystem` — Single source of truth for colours, text styles, spacing, and SVG assets.
- `ui` — Higher-level reusable widgets built from the design system (buttons, inputs, cards, etc.).

#### Localization — `localization/`
- ARB-based translations generated with `intl_utils`.
- Exposes a `LocaleCubit` so the running locale can be changed at runtime via BLoC.

#### Code Analyzer — `code_analyzer/`
- Shared `analysis_options.yaml` and custom lint rules applied uniformly across every package via `dart_code_linter`.

### Package Dependency Graph

```
apps
 ├── navigation
 │    ├── login (feature)
 │    └── splash (feature)
 ├── localization
 │    └── common
 └── designsystem

di
 ├── data
 │    ├── domain
 │    │    ├── entity
 │    │    └── common
 │    ├── response
 │    ├── entity
 │    ├── common
 │    └── sharedpref
 ├── secured
 └── sharedpref
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
   │  calls
   ▼
Network Client (Dio)  ──►  Remote API
   │
   ▼  maps raw response
Entity  ──►  returned up the chain to UI
```

---

## Features

| Feature | Package | Status |
|---|---|---|
| Splash screen | `features/auth/splash` | ✅ |
| Login / Authentication | `features/auth/login` | ✅ |
| Post list | `features/posts/post_list` | 🚧 In progress |
| Create post | `features/posts/create_post` | 🚧 In progress |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.11.4`
- Dart SDK `>=3.11.4`
- [Melos](https://melos.invertase.dev/) installed globally:

```bash
dart pub global activate melos
```

### Bootstrap the workspace

```bash
melos bootstrap
```

This installs all dependencies across every package and links local packages together.

### Run the app

```bash
cd apps
flutter run
```

### Run all tests

```bash
melos run test
```

### Update dependencies

```bash
# Minor updates
dart melos_minor_deps_update.dart

# Major updates
dart melos_major_deps_update.dart
```
