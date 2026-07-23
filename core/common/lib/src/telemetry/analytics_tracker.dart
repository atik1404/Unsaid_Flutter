import 'analytics_event.dart';

/// ---------------------------------------------------------------------------
/// Vendor-agnostic behaviour-analytics contract.
///
/// Features depend on THIS interface, never on Microsoft Clarity directly, so
/// the analytics backend can be swapped or disabled without touching a single
/// feature module (Dependency Inversion + Interface Segregation).
///
/// The implementation lives in `package:analytics` ([ClarityAnalyticsTracker]).
/// A [NoopAnalyticsTracker] is provided for tests and for when analytics is
/// disabled (e.g. missing project id).
/// ---------------------------------------------------------------------------
abstract interface class AnalyticsTracker {
  /// Report a single behaviour event. Fire-and-forget: implementations must
  /// never throw or block the UI thread.
  void logEvent(AnalyticsEvent event);

  /// Associate the current session with a (pseudonymous) user id. Call on
  /// login / session restore; pass `null` or call [reset] on logout.
  Future<void> setUserId(String? userId);

  /// Attach a custom tag to the session (e.g. `flavor`, `experiment`). Tags are
  /// searchable/filterable in the analytics dashboard.
  Future<void> setCustomTag(String key, String value);

  /// Clear user association and session-scoped state (e.g. on logout).
  Future<void> reset();
}

/// No-op tracker used when analytics is disabled or in tests. Every method is a
/// safe, silent no-op so call sites need no null checks.
final class NoopAnalyticsTracker implements AnalyticsTracker {
  const NoopAnalyticsTracker();

  @override
  void logEvent(AnalyticsEvent event) {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setCustomTag(String key, String value) async {}

  @override
  Future<void> reset() async {}
}
