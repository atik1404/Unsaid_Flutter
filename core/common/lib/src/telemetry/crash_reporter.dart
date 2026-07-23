/// ---------------------------------------------------------------------------
/// Vendor-agnostic stability / crash-reporting contract.
///
/// Everything that needs to report an error (repositories, the bloc observer,
/// global handlers) depends on THIS interface, never on Sentry directly. The
/// implementation lives in `package:monitoring` ([SentryCrashReporter]); a
/// [NoopCrashReporter] backs tests and the "no DSN configured" case.
///
/// This is deliberately about **stability only** — crashes, ANRs, fatal and
/// non-fatal exceptions, breadcrumbs and context. It is NOT an analytics API;
/// user-behaviour tracking goes through [AnalyticsTracker] instead.
/// ---------------------------------------------------------------------------
library;

/// Severity of a breadcrumb, mirroring the common levels every crash backend
/// understands.
enum BreadcrumbLevel { debug, info, warning, error, fatal }

/// A lightweight, ordered trail entry that gives a crash its "story" — the
/// sequence of actions leading up to the failure. Kept vendor-neutral.
final class AppBreadcrumb {
  const AppBreadcrumb({
    required this.message,
    this.category,
    this.level = BreadcrumbLevel.info,
    this.data = const {},
  });

  /// Human-readable description, e.g. `POST /login → 401`.
  final String message;

  /// Grouping label, e.g. `http`, `navigation`, `auth`.
  final String? category;

  final BreadcrumbLevel level;

  /// Optional structured context (keep values primitive).
  final Map<String, Object?> data;
}

/// Minimal, privacy-conscious user descriptor attached to crash reports so
/// issues can be correlated to an account without leaking PII.
final class TelemetryUser {
  const TelemetryUser({required this.id, this.username, this.email});

  final String id;
  final String? username;
  final String? email;
}

/// The stability-monitoring contract implemented by the Sentry package.
abstract interface class CrashReporter {
  /// Report a caught exception. Use [fatal] `true` only for crash-equivalent
  /// conditions; most caught errors are non-fatal.
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  });

  /// Convenience for non-fatal errors from a known [context] (e.g. a repository
  /// method or network call). Equivalent to [captureException] with a context
  /// tag; kept separate for readable call sites in the data layer.
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  });

  /// Report a message with no associated throwable (diagnostics / test pings).
  Future<void> captureMessage(String message, {Map<String, String>? tags});

  /// Append a breadcrumb to the current scope. Cheap and synchronous.
  void addBreadcrumb(AppBreadcrumb breadcrumb);

  /// Set (or clear, with `null`) the user attached to subsequent reports.
  Future<void> setUser(TelemetryUser? user);

  /// Attach a searchable tag to every subsequent report (e.g. `flavor=prod`).
  Future<void> setTag(String key, String value);
}

/// No-op reporter for tests and the "no DSN" case. Silent and safe.
final class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) async {}

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) async {}

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) {}

  @override
  Future<void> setUser(TelemetryUser? user) async {}

  @override
  Future<void> setTag(String key, String value) async {}
}
