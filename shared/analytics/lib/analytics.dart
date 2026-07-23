/// User-behaviour analytics, backed by Microsoft Clarity.
///
/// Public surface:
///   • [AnalyticsDiModule]      — register the [AnalyticsTracker].
///   • [AnalyticsRouteObserver] — auto screen-view / navigation tracking.
///   • [ClarityAppWrapper]      — wraps the app for Clarity session recording.
///   • [ClarityAnalyticsTracker]— the `AnalyticsTracker` implementation.
///
/// The vendor-agnostic `AnalyticsTracker` and `AnalyticsEvent` types live in
/// `package:common` — depend on those from feature code, not on Clarity.
library;

export 'src/analytics_di_module.dart';
export 'src/analytics_route_observer.dart';
export 'src/clarity_analytics_tracker.dart';
export 'src/clarity_app_wrapper.dart';
