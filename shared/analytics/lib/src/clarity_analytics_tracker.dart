import 'dart:async';

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:common/common.dart';

/// ---------------------------------------------------------------------------
/// Microsoft Clarity implementation of the vendor-agnostic [AnalyticsTracker].
///
/// This is the ONLY place that talks to the Clarity SDK. Features emit typed
/// [AnalyticsEvent]s against the interface, so the analytics backend can be
/// swapped without touching a single feature (Dependency Inversion Principle).
///
/// Clarity models a custom event as a single string; the event [AnalyticsEvent.name]
/// is sent as that string and its [AnalyticsEvent.parameters] are attached as
/// custom tags so they remain filterable in the Clarity dashboard.
///
/// All calls are fire-and-forget and guarded — analytics must never throw into,
/// or block, the UI.
/// ---------------------------------------------------------------------------
final class ClarityAnalyticsTracker implements AnalyticsTracker {
  ClarityAnalyticsTracker();

  /// Signature of the last screen-view sent, used to suppress duplicate
  /// consecutive screen views (e.g. an observer firing twice for one route).
  String? _lastScreenSignature;

  @override
  void logEvent(AnalyticsEvent event) {
    // De-duplicate only screen views; genuine repeat interactions (two taps)
    // must still be recorded.
    if (event is ScreenViewEvent) {
      if (event.screenName == _lastScreenSignature) return;
      _lastScreenSignature = event.screenName;
    }

    unawaited(_safe(() => Clarity.sendCustomEvent(event.name)));
    // Attach parameters as tags for slice-and-dice in the dashboard.
    event.parameters.forEach((key, value) {
      if (value != null) {
        unawaited(_safe(() => Clarity.setCustomTag(key, value.toString())));
      }
    });
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (userId == null || userId.isEmpty) return;
    await _safe(() => Clarity.setCustomUserId(userId));
  }

  @override
  Future<void> setCustomTag(String key, String value) async {
    await _safe(() => Clarity.setCustomTag(key, value));
  }

  @override
  Future<void> reset() async {
    _lastScreenSignature = null;
    // Clarity has no explicit "clear user" call; a fresh app session detaches
    // the previous custom user id.
  }

  /// Swallows any SDK/plugin error so analytics failures never surface to the
  /// user or crash the app.
  Future<void> _safe(FutureOr<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Intentionally ignored — analytics is best-effort.
    }
  }
}
