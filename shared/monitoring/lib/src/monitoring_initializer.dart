import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

/// ---------------------------------------------------------------------------
/// Initialises Sentry for **stability monitoring only** and runs the app inside
/// Sentry's guarded zone.
///
/// Deliberately enabled: crash reporting, ANR detection, native crashes, fatal
/// & non-fatal exceptions, breadcrumbs. Deliberately DISABLED: performance
/// tracing, profiling, session replay, Sentry logs — per the integration spec.
///
/// `SentryFlutter.init` wires the global error handlers for us:
///   • `FlutterError.onError`         → framework/UI errors
///   • `PlatformDispatcher.onError`   → uncaught async ("coroutine") errors
///   • runs [appRunner] in `runZonedGuarded` → uncaught zone errors
/// so every uncaught error path reaches Sentry without extra wiring.
///
/// When [dsn] is empty (e.g. secrets not yet configured) Sentry is skipped and
/// the app simply runs — builds and local dev never depend on a DSN.
/// ---------------------------------------------------------------------------
abstract final class MonitoringInitializer {
  const MonitoringInitializer._();

  static Future<void> run({
    required String dsn,
    required String environment,
    required FutureOr<void> Function() appRunner,
    String? release,
  }) async {
    // No DSN → run the app without Sentry (no-op reporter is registered in DI).
    if (dsn.trim().isEmpty) {
      await appRunner();
      return;
    }

    await SentryFlutter.init((options) {
      options.dsn = dsn;
      options.environment = environment;
      if (release != null) options.release = release;

      // ── Stability features ON ──────────────────────────────────────────────
      options.attachStacktrace = true; // stack traces on non-fatal reports
      options.anrEnabled = true; // Android ANR (Application Not Responding)
      options.enableAutoSessionTracking = true; // release health (not tracing)
      options.maxBreadcrumbs = 100;
      // Native crash handling (NDK/iOS) is enabled by default.

      // ── Performance / replay / logs OFF ────────────────────────────────────
      options.tracesSampleRate = 0.0; // no performance tracing
      options.enableAutoPerformanceTracing = false;
      // Profiling is disabled by default and requires tracing (off above), so
      // no profiling data is collected. (`profilesSampleRate` is intentionally
      // not set — the API is experimental and unnecessary here.)
      // Session replay is left at its default (disabled); we never configure it.

      // Drop console noise from crash reports.
      options.debug = false;
    }, appRunner: appRunner);
  }
}
