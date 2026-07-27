import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:common/common.dart';

import 'clarity_event_encoder.dart';

/// ---------------------------------------------------------------------------
/// Microsoft Clarity implementation of the vendor-agnostic [AnalyticsTracker].
///
/// This is the ONLY place that talks to the Clarity SDK. Features emit typed
/// [AnalyticsEvent]s against the interface, so the analytics backend can be
/// swapped without touching a single feature (Dependency Inversion Principle).
///
/// ## How each concept maps onto Clarity's API
///
/// | Our concept       | Clarity API            | Scope             |
/// |-------------------|------------------------|-------------------|
/// | [ScreenViewEvent] | `setCurrentScreenName` | page              |
/// | any other event   | `sendCustomEvent`      | single, timestamp |
/// | [setUserId]       | `setCustomUserId`      | session           |
/// | [setCustomTag]    | `setCustomTag`         | session           |
/// | [reset] (logout)  | `startNewSession`      | session           |
///
/// Screen views deliberately do **not** also go out as custom events: Clarity
/// starts a new page whenever the screen name changes, so the screen is already
/// a first-class dimension in the dashboard. Emitting a duplicate `screen_view`
/// custom event would double-count every navigation. The user's journey is
/// still captured, because [NavigationEvent] (from → to → action) is sent as a
/// custom event by [AnalyticsRouteObserver].
///
/// ## What is deliberately NOT sent here
///
/// Crashes, exceptions and ANRs are **never** reported to Clarity. Those belong
/// to the stability-monitoring pipeline (Sentry, via `CrashReporter`), and the
/// Clarity SDK installs no error handlers of its own — it does not hook
/// `FlutterError.onError`, `PlatformDispatcher.onError` or `runZonedGuarded`.
/// Keeping the two pipelines disjoint means a given failure is reported exactly
/// once, to the tool built for it. Do not add error capture to this class.
///
/// All calls are guarded — analytics must never throw into, or block, the UI.
/// Every Clarity API used here is synchronous and cheap (it hands the value to
/// the SDK's own session isolate), so nothing here blocks a frame.
/// ---------------------------------------------------------------------------
final class ClarityAnalyticsTracker implements AnalyticsTracker {
  ClarityAnalyticsTracker();

  /// Last screen name handed to Clarity, used to suppress redundant calls when
  /// an observer reports the same destination twice (e.g. a replace that leaves
  /// the user on the same route).
  String? _lastScreenName;

  /// Last user id associated with the session, so a session restore followed by
  /// a login for the same account does not re-tag the session needlessly.
  String? _currentUserId;

  @override
  void logEvent(AnalyticsEvent event) {
    // Screen views drive Clarity's page model rather than the custom-event
    // stream — see the class doc for why these are not double-reported.
    if (event is ScreenViewEvent) {
      _setScreenName(event.screenName);
      return;
    }

    final encoded = ClarityEventEncoder.encode(event);
    if (encoded == null) return; // unnamed event — nothing meaningful to send

    _safe(() => Clarity.sendCustomEvent(encoded));
  }

  @override
  Future<void> setUserId(String? userId) async {
    // A null/blank id means "no authenticated user". Clarity has no API to
    // unset a custom user id mid-session, so clearing is handled by [reset],
    // which starts a fresh session instead.
    if (userId == null || userId.trim().isEmpty) return;

    final encoded = ClarityEventEncoder.encodeTag(userId);
    if (encoded == null || encoded == _currentUserId) return;

    _safe(() {
      Clarity.setCustomUserId(encoded);
      _currentUserId = encoded;
    });
  }

  @override
  Future<void> setCustomTag(String key, String value) async {
    final encodedKey = ClarityEventEncoder.encodeTag(key);
    final encodedValue = ClarityEventEncoder.encodeTag(value);
    if (encodedKey == null || encodedValue == null) return;

    _safe(() => Clarity.setCustomTag(encodedKey, encodedValue));
  }

  @override
  Future<void> reset() async {
    _lastScreenName = null;
    _currentUserId = null;

    // Clarity scopes the custom user id (and every custom tag) to the session,
    // and exposes no way to clear them in place. Starting a new session is the
    // supported way to detach the previous identity: the recording that follows
    // a logout is anonymous and is not linked to the account that just left.
    _safe(() => Clarity.startNewSession((_) {}));
  }

  /// Sets Clarity's current screen name, which also starts a new Clarity page.
  void _setScreenName(String screenName) {
    final encoded = ClarityEventEncoder.encodeScreenName(screenName);
    if (encoded == null || encoded == _lastScreenName) return;

    _safe(() {
      Clarity.setCurrentScreenName(encoded);
      _lastScreenName = encoded;
    });
  }

  /// Swallows any SDK/plugin error so analytics failures never surface to the
  /// user or crash the app. This is a local guard only — nothing is forwarded
  /// to Clarity or to the crash reporter, keeping analytics strictly
  /// best-effort and the two telemetry pipelines independent.
  void _safe(void Function() action) {
    try {
      action();
    } catch (_) {
      // Intentionally ignored — analytics is best-effort.
    }
  }
}
