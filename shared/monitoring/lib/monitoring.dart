/// Application stability monitoring, backed by Sentry and Firebase Crashlytics.
///
/// Public surface:
///   • [CrashlyticsInitializer]   — point the global handlers at Crashlytics.
///   • [MonitoringInitializer]    — init Sentry (stability only) + run the app.
///   • [MonitoringDiModule]       — register the [CrashReporter] + bloc observer.
///   • [AppBlocObserver]          — funnels bloc errors into the reporter.
///   • [SentryCrashReporter]      — Sentry `CrashReporter` implementation.
///   • [CrashlyticsCrashReporter] — Crashlytics `CrashReporter` implementation.
///   • [CompositeCrashReporter]   — fans reports out to several backends.
///   • [SentryNavigatorObserver]  — navigation breadcrumbs (re-exported).
///
/// Both backends run together. `CrashlyticsInitializer.install` must be called
/// **before** `MonitoringInitializer.run` — see its doc for why the order is
/// what makes the two coexist.
///
/// The vendor-agnostic `CrashReporter`, `AppBreadcrumb` and `TelemetryUser`
/// types live in `package:common` — depend on those from feature code.
library;

export 'src/app_bloc_observer.dart';
export 'src/composite_crash_reporter.dart';
export 'src/crashlytics_crash_reporter.dart';
export 'src/crashlytics_initializer.dart';
export 'src/monitoring_di_module.dart';
export 'src/monitoring_initializer.dart';
export 'src/sentry_crash_reporter.dart';

// Re-export just the navigation observer so the DI/navigation layer can add
// Sentry breadcrumbs without importing the Sentry SDK directly.
export 'package:sentry_flutter/sentry_flutter.dart' show SentryNavigatorObserver;
