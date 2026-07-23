import 'package:common/common.dart';
import 'package:get_it/get_it.dart';

import 'app_bloc_observer.dart';
import 'sentry_crash_reporter.dart';

/// ---------------------------------------------------------------------------
/// Registers the stability-monitoring graph in the DI container.
///
/// Consumers resolve the [CrashReporter] abstraction (never the Sentry impl),
/// so nothing outside this package is coupled to Sentry.
///
/// [enabled] mirrors "is a DSN configured?": when `false` a [NoopCrashReporter]
/// is registered so the whole app keeps working with reporting turned off.
/// ---------------------------------------------------------------------------
abstract final class MonitoringDiModule {
  const MonitoringDiModule._();

  static void init(GetIt getIt, {required bool enabled}) {
    getIt.registerSingleton<CrashReporter>(
      enabled ? const SentryCrashReporter() : const NoopCrashReporter(),
    );

    // The global Bloc observer routes unhandled bloc errors to the reporter.
    getIt.registerSingleton<AppBlocObserver>(
      AppBlocObserver(getIt<CrashReporter>()),
    );
  }
}
