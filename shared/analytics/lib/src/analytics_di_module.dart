import 'package:common/common.dart';
import 'package:get_it/get_it.dart';

import 'analytics_route_observer.dart';
import 'clarity_analytics_tracker.dart';

/// ---------------------------------------------------------------------------
/// Registers the analytics graph in the DI container.
///
/// Consumers resolve the [AnalyticsTracker] abstraction (never the Clarity
/// impl). [enabled] mirrors "is a Clarity project id configured?": when `false`
/// a [NoopAnalyticsTracker] is registered so the app runs with analytics off.
/// ---------------------------------------------------------------------------
abstract final class AnalyticsDiModule {
  const AnalyticsDiModule._();

  static void init(GetIt getIt, {required bool enabled}) {
    getIt.registerSingleton<AnalyticsTracker>(
      enabled ? ClarityAnalyticsTracker() : const NoopAnalyticsTracker(),
    );

    // Navigator-level observer that auto-tracks screen views & navigation.
    getIt.registerSingleton<AnalyticsRouteObserver>(
      AnalyticsRouteObserver(getIt<AnalyticsTracker>()),
    );
  }
}
