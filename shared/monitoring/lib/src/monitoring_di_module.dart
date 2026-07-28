import 'package:common/common.dart';
import 'package:get_it/get_it.dart';

import 'app_bloc_observer.dart';
import 'composite_crash_reporter.dart';
import 'crashlytics_crash_reporter.dart';
import 'sentry_crash_reporter.dart';

/// ---------------------------------------------------------------------------
/// Registers the stability-monitoring graph in the DI container.
///
/// Consumers resolve the [CrashReporter] abstraction, never a concrete backend,
/// so nothing outside this package is coupled to Sentry or Crashlytics — or to
/// how many of them are active.
///
/// Each backend is gated independently:
///   • [sentryEnabled]      mirrors "is a DSN configured?"
///   • [crashlyticsEnabled] mirrors "is Crashlytics collection on?"
///
/// With both on, reports fan out through a [CompositeCrashReporter]. With
/// neither, a [NoopCrashReporter] keeps every call site working unchanged.
/// ---------------------------------------------------------------------------
abstract final class MonitoringDiModule {
  const MonitoringDiModule._();

  static void init(
    GetIt getIt, {
    required bool sentryEnabled,
    required bool crashlyticsEnabled,
  }) {
    final reporters = <CrashReporter>[
      if (sentryEnabled) const SentryCrashReporter(),
      if (crashlyticsEnabled) const CrashlyticsCrashReporter(),
    ];

    getIt.registerSingleton<CrashReporter>(
      switch (reporters.length) {
        0 => const NoopCrashReporter(),
        // Skip the composite's indirection when only one backend is live.
        1 => reporters.first,
        _ => CompositeCrashReporter(reporters),
      },
    );

    // The global Bloc observer routes unhandled bloc errors to the reporter.
    getIt.registerSingleton<AppBlocObserver>(
      AppBlocObserver(getIt<CrashReporter>()),
    );
  }
}
