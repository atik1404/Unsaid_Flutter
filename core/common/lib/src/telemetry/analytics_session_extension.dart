import 'analytics_event.dart';
import 'analytics_tracker.dart';

/// ---------------------------------------------------------------------------
/// Session-lifecycle helpers layered on top of [AnalyticsTracker].
///
/// These exist so the *order* of the calls that end an authenticated session
/// lives in exactly one place. Getting that order wrong is subtle and silent:
/// [AnalyticsTracker.reset] starts a fresh, anonymous analytics session, so a
/// logout event emitted **after** it would be attributed to the new session
/// instead of the one the user just left — the logout would appear to belong to
/// nobody.
///
/// Kept as an extension (rather than new interface members) so no implementation
/// — including [NoopAnalyticsTracker] and any test double — has to change.
/// ---------------------------------------------------------------------------
extension AnalyticsSession on AnalyticsTracker {
  /// Ends the current authenticated analytics session.
  ///
  /// Records the logout against the *outgoing* session and then detaches the
  /// user identity, so subsequent activity is recorded anonymously. Call this
  /// from every path that signs the user out — explicit sign-out, account
  /// deletion, or an expired session.
  ///
  /// [reason] is a short, stable `snake_case` token (e.g. `user_initiated`,
  /// `account_deleted`, `session_expired`) that keeps the single `logout` event
  /// filterable by cause in the dashboard.
  Future<void> endSession({required String reason}) async {
    // 1. Attribute the logout to the session that is ending.
    logEvent(
      BusinessEvent(
        AnalyticsEventName.logout,
        parameters: {'reason': reason},
      ),
    );

    // 2. Detach the user id / session-scoped context.
    await reset();
  }

  /// Associates the current analytics session with the signed-in user.
  ///
  /// Call after a successful login and whenever a persisted session is restored
  /// on app launch, so warm starts stay attributed to the same account. Safe to
  /// call repeatedly — implementations ignore a redundant id.
  Future<void> startSession({required String userId}) => setUserId(userId);
}
