import 'package:common/common.dart';
import 'package:flutter/widgets.dart';

/// ---------------------------------------------------------------------------
/// A [NavigatorObserver] that turns route transitions into analytics events.
///
/// Wiring this once into the router's `observers` gives automatic, lifecycle-
/// aware tracking of:
///   • **Screen views**   — one [ScreenViewEvent] per route entered.
///   • **Navigation flow** — a [NavigationEvent] describing each push/pop/replace.
///   • **User journey**    — the ordered stream of the above *is* the journey.
///
/// Because it lives at the navigator level, no screen needs to emit its own
/// screen-view event — eliminating a whole class of duplicate/missing events.
///
/// This is also exactly where Clarity's docs recommend driving the current
/// screen name from ("to cover all route changes, call it inside a
/// RouteObserver"); the translation to that API happens in the tracker.
///
/// Suppressing repeat screen views is the tracker's job, so this observer stays
/// a plain, backend-agnostic translation of navigator callbacks into events.
/// ---------------------------------------------------------------------------
final class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._tracker);

  final AnalyticsTracker _tracker;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record(entered: route, left: previousRoute, action: 'push');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // On pop the user returns to [previousRoute].
    _record(entered: previousRoute, left: route, action: 'pop');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _record(entered: newRoute, left: oldRoute, action: 'replace');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _record({
    required Route<dynamic>? entered,
    required Route<dynamic>? left,
    required String action,
  }) {
    final to = _nameOf(entered);
    if (to == null) return; // dialogs / unnamed routes are skipped
    final from = _nameOf(left);

    _tracker.logEvent(ScreenViewEvent(screenName: to));
    _tracker.logEvent(NavigationEvent(from: from, to: to, action: action));
  }

  String? _nameOf(Route<dynamic>? route) => route?.settings.name;
}
