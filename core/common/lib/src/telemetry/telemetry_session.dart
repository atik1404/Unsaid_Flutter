import 'analytics_event.dart';
import 'analytics_tracker.dart';
import 'crash_reporter.dart';

/// ---------------------------------------------------------------------------
/// Owns the identity attached to the app's telemetry for the signed-in user.
///
/// Sentry ([CrashReporter]) and Clarity ([AnalyticsTracker]) both need to know
/// who the current user is, and both need it cleared at exactly the same
/// moments. Calling the two SDKs side by side at every login/logout site
/// duplicated that pairing four times over and made it easy to update one
/// pipeline and forget the other — so the pairing lives here instead, and call
/// sites express intent ("this session started/ended") rather than mechanics.
///
/// Two ordering rules are encoded here, both silent if broken:
///   • On logout the logout **event** must be recorded before
///     [AnalyticsTracker.reset], which starts a fresh anonymous analytics
///     session — afterwards it would be attributed to nobody.
///   • The crash-reporter user is cleared before the analytics reset so a
///     failure in either path still leaves no stale identity behind.
///
/// Only the backend's opaque user id is ever sent. Name, email and phone stay
/// on the device: crash reports and session recordings do not need them, and
/// [SentryFlutterOptions.sendDefaultPii] is left at its safe default.
/// ---------------------------------------------------------------------------
final class TelemetrySession {
  const TelemetrySession({
    required AnalyticsTracker analytics,
    required CrashReporter crashReporter,
  }) : _analytics = analytics,
       _crashReporter = crashReporter;

  /// Inert session for tests and for layers constructed before telemetry is
  /// registered. Mirrors the [NoopCrashReporter] / [NoopAnalyticsTracker]
  /// fallbacks used elsewhere, so nothing needs a null check.
  const TelemetrySession.noop()
    : _analytics = const NoopAnalyticsTracker(),
      _crashReporter = const NoopCrashReporter();

  final AnalyticsTracker _analytics;
  final CrashReporter _crashReporter;

  /// Associates all subsequent telemetry with [userId].
  ///
  /// Call after a successful login and when a persisted session is restored on
  /// launch, so warm starts stay attributed to the same account. Safe to call
  /// repeatedly — both backends ignore a redundant id.
  Future<void> start({required String userId}) async {
    if (userId.trim().isEmpty) return;

    await _crashReporter.setUser(TelemetryUser(id: userId));
    await _analytics.setUserId(userId);
  }

  /// Ends the authenticated session: records the logout, then detaches the
  /// identity from both pipelines so later activity is anonymous.
  ///
  /// [reason] is a short, stable `snake_case` token (`user_initiated`,
  /// `account_deleted`, `session_expired`) that keeps the single `logout` event
  /// filterable by cause.
  Future<void> end({required String reason}) async {
    // Attribute the logout to the session that is ending (see class doc).
    _analytics.logEvent(
      BusinessEvent(
        AnalyticsEventName.logout,
        parameters: {'reason': reason},
      ),
    );

    await _crashReporter.setUser(null);
    await _analytics.reset();
  }
}
