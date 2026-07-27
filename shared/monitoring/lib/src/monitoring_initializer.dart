import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

/// ---------------------------------------------------------------------------
/// Initialises Sentry for **stability monitoring only** and runs the app inside
/// Sentry's guarded zone.
///
/// ## Automatic capture
///
/// `SentryFlutter.init` installs every global error handler for us, so no
/// feature code needs a try/catch to get an error reported:
///   • `FlutterError.onError`       → framework / build / layout errors
///   • `PlatformDispatcher.onError` → uncaught async errors
///   • `runZonedGuarded([appRunner])` → uncaught zone errors
///   • native crash handlers        → Android NDK & iOS signal/exception crashes
///   • ANR watchdogs                → see [anrEnabled] / [enableAppHangTracking]
///
/// This must be the outermost thing in `bootstrap`: everything the app does
/// happens inside [appRunner], so a failure during startup is reported too.
///
/// ## Scope
///
/// Deliberately ON: crashes, ANRs / app hangs, watchdog terminations, fatal and
/// non-fatal exceptions, breadcrumbs, release health.
/// Deliberately OFF: performance tracing, profiling, session replay, screenshots
/// and view hierarchies. Behaviour analytics is Clarity's job, not Sentry's, and
/// the two pipelines are kept disjoint so nothing is reported twice.
///
/// When [dsn] is empty (secrets not configured) Sentry is skipped and the app
/// simply runs — builds and local dev never depend on a DSN, and DI registers
/// the no-op `CrashReporter` in that case.
/// ---------------------------------------------------------------------------
abstract final class MonitoringInitializer {
  const MonitoringInitializer._();

  static Future<void> run({
    required String dsn,
    required String environment,
    required FutureOr<void> Function() appRunner,
    bool debug = false,
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

      // Left unset by default so Sentry's LoadReleaseIntegration derives
      // `package@version+build` from the platform package info. That matches
      // what the store actually shipped, which a hand-passed value can drift
      // from. [release] is only for callers that need to override it.
      if (release != null) options.release = release;

      // ── Crash & unresponsiveness detection ────────────────────────────────
      options.attachStacktrace = true; // stack traces on non-fatal reports too
      options.anrEnabled = true; // Android: ANR ("App Not Responding")
      options.enableAppHangTracking = true; // iOS/macOS: the ANR equivalent
      options.enableWatchdogTerminationTracking = true; // iOS OOM/watchdog kills
      // Native (NDK/iOS) crash handling is on by default and left that way.

      // Syncs user/tags/breadcrumbs from Dart down to the Android native layer,
      // so a native crash still carries the user id set at login instead of
      // arriving anonymous. On by default; set explicitly because the user
      // context requirement depends on it.
      options.enableNdkScopeSync = true;

      // Report every error. Crash reporting is only useful when it is complete,
      // and this app's volume does not warrant client-side sampling.
      options.sampleRate = 1.0;

      // Release health (crash-free users/sessions). Not performance tracing.
      options.enableAutoSessionTracking = true;
      options.maxBreadcrumbs = 100;

      // ── Privacy ───────────────────────────────────────────────────────────
      // No request bodies, headers, IP addresses or device names. The only user
      // data attached is the opaque id set via TelemetrySession. These are the
      // SDK defaults; pinned here so a future SDK upgrade cannot loosen them
      // silently.
      options.sendDefaultPii = false;
      options.attachScreenshot = false;
      // `attachViewHierarchy` is also off by default; it is not pinned here
      // because the option is still marked experimental in the SDK.

      // ── Performance / replay OFF ──────────────────────────────────────────
      options.tracesSampleRate = 0.0; // no performance tracing
      options.enableAutoPerformanceTracing = false;
      // Profiling requires tracing (off above), so none is collected. Session
      // replay is left at its disabled default and never configured.

      // SDK's own diagnostic logging — on only where verbose logging is already
      // permitted (debug builds), never in a release binary.
      options.debug = debug;
    }, appRunner: appRunner);
  }
}
