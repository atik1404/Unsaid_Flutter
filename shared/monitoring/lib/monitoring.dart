/// Application stability monitoring, backed by Sentry.
///
/// Public surface:
///   • [MonitoringInitializer] — init Sentry (stability only) + run the app.
///   • [MonitoringDiModule]     — register the [CrashReporter] + bloc observer.
///   • [AppBlocObserver]        — funnels bloc errors into the reporter.
///   • [SentryCrashReporter]    — the `CrashReporter` implementation.
///   • [SentryNavigatorObserver]— navigation breadcrumbs (re-exported).
///
/// The vendor-agnostic `CrashReporter`, `AppBreadcrumb` and `TelemetryUser`
/// types live in `package:common` — depend on those from feature code.
library;

export 'src/app_bloc_observer.dart';
export 'src/monitoring_di_module.dart';
export 'src/monitoring_initializer.dart';
export 'src/sentry_crash_reporter.dart';

// Re-export just the navigation observer so the DI/navigation layer can add
// Sentry breadcrumbs without importing the Sentry SDK directly.
export 'package:sentry_flutter/sentry_flutter.dart' show SentryNavigatorObserver;
