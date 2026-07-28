import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// ---------------------------------------------------------------------------
/// Wires Firebase Crashlytics into the app's global error handlers.
///
/// Native crashes (Android JVM/NDK, iOS signals) are captured by the Crashlytics
/// native SDK on its own as soon as collection is enabled. Dart-side errors are
/// not: nothing reaches Crashlytics unless `FlutterError.onError` and
/// `PlatformDispatcher.onError` are pointed at it, which is what [install] does.
///
/// ## Call this BEFORE `MonitoringInitializer.run`
///
/// Ordering is what lets Sentry and Crashlytics coexist. Both of Sentry's
/// integrations *chain*: `FlutterErrorIntegration` stores the existing
/// `FlutterError.onError` and always calls it after capturing, and
/// `OnErrorIntegration` calls the existing `PlatformDispatcher.onError` first
/// and forwards its result. So with Crashlytics installed first, Sentry wraps
/// it and **both** backends receive every Dart error.
///
/// Reversing the order silently breaks Sentry instead: these assignments would
/// overwrite Sentry's handlers, and only Crashlytics would report.
///
/// Requires `Firebase.initializeApp` to have completed.
/// ---------------------------------------------------------------------------
abstract final class CrashlyticsInitializer {
  const CrashlyticsInitializer._();

  static Future<void> install({required bool enabled}) async {
    // Gates upload at the SDK level. When false the handlers below still run
    // but Crashlytics drops the reports, so nothing leaks from a build that
    // should stay silent.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
    if (!enabled) return;

    // Framework errors (build/layout/gesture callbacks). Recorded as fatal per
    // Firebase's documented Flutter setup, so they surface as crashes rather
    // than being buried in non-fatals.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Uncaught asynchronous errors that reach the platform dispatcher.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // `true` marks the error handled so the framework stops printing it.
      // Sentry's OnErrorIntegration forwards this value, so both backends
      // agree on how the error was treated.
      return true;
    };
  }
}
