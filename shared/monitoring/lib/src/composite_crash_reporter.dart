import 'package:common/common.dart';

/// ---------------------------------------------------------------------------
/// Fans every [CrashReporter] call out to several backends.
///
/// Lets Sentry and Firebase Crashlytics run side by side without a single call
/// site — the bloc observer, `RestClient`, `TelemetrySession` — knowing more
/// than one exists. Which backends are active is decided once, in
/// [MonitoringDiModule]; adding or removing one changes nothing else.
///
/// One backend failing must not stop the others, so each delegate is awaited
/// independently and its error swallowed. Crash reporting is best-effort by
/// nature: an exception raised *by* the reporter, propagating into the handler
/// that is reporting a crash, is the worst possible failure mode.
/// ---------------------------------------------------------------------------
final class CompositeCrashReporter implements CrashReporter {
  const CompositeCrashReporter(this._delegates);

  final List<CrashReporter> _delegates;

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) {
    return _each(
      (reporter) => reporter.captureException(
        error,
        stackTrace: stackTrace,
        hint: hint,
        tags: tags,
        fatal: fatal,
      ),
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) {
    return _each(
      (reporter) => reporter.recordError(
        error,
        stackTrace,
        context: context,
        fatal: fatal,
      ),
    );
  }

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) =>
      _each((reporter) => reporter.captureMessage(message, tags: tags));

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) {
    for (final reporter in _delegates) {
      try {
        reporter.addBreadcrumb(breadcrumb);
      } catch (_) {
        // Best-effort: a failing backend must not break the others.
      }
    }
  }

  @override
  Future<void> setUser(TelemetryUser? user) =>
      _each((reporter) => reporter.setUser(user));

  @override
  Future<void> setTag(String key, String value) =>
      _each((reporter) => reporter.setTag(key, value));

  /// Runs [action] against every delegate, isolating failures.
  Future<void> _each(Future<void> Function(CrashReporter) action) async {
    for (final reporter in _delegates) {
      try {
        await action(reporter);
      } catch (_) {
        // Best-effort: a failing backend must not break the others.
      }
    }
  }
}
