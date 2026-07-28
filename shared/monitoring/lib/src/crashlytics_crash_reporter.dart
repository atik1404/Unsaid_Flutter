import 'package:common/common.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// ---------------------------------------------------------------------------
/// Firebase Crashlytics implementation of the vendor-agnostic [CrashReporter].
///
/// Lets everything that already reports through [CrashReporter] — the bloc
/// observer, `RestClient`, and the user context set by `TelemetrySession` —
/// reach Firebase without any call site knowing Crashlytics exists.
///
/// Crashlytics' model is flatter than Sentry's: there is no scoped event, so
/// tags become custom keys (which are global to the session and attached to the
/// next report) and breadcrumbs become log lines (which are attached to the
/// next crash, which is exactly what breadcrumbs are for).
/// ---------------------------------------------------------------------------
final class CrashlyticsCrashReporter implements CrashReporter {
  const CrashlyticsCrashReporter();

  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) async {
    // Custom keys are session-global, so they must be set before the report is
    // recorded to be attached to it.
    if (tags != null) {
      for (final entry in tags.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    }

    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: hint,
      fatal: fatal,
      // Never print to console: Sentry already logs, and RestClient prints its
      // own diagnostics in debug builds.
      printDetails: false,
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) {
    return captureException(
      error,
      stackTrace: stackTrace,
      hint: context,
      fatal: fatal,
      tags: context == null ? null : {'context': context},
    );
  }

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) async {
    tags?.forEach((key, value) => _crashlytics.setCustomKey(key, value));
    // Crashlytics has no standalone "message" event; a log line is the closest
    // equivalent and shows up in the session view of the next report.
    await _crashlytics.log(message);
  }

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) {
    final category = breadcrumb.category;
    final prefix = category == null ? '' : '[$category] ';
    // Fire-and-forget, matching the synchronous contract of the interface.
    _crashlytics.log('$prefix${breadcrumb.message}');
  }

  @override
  Future<void> setUser(TelemetryUser? user) {
    // Crashlytics has no "clear user" call; the documented way to detach the
    // identity is to set an empty identifier, which is what logout needs.
    return _crashlytics.setUserIdentifier(user?.id ?? '');
  }

  @override
  Future<void> setTag(String key, String value) =>
      _crashlytics.setCustomKey(key, value);
}
