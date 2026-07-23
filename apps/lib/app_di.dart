import 'package:analytics/analytics.dart';
import 'package:app_env/environment.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:monitoring/monitoring.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:get_it/get_it.dart';

Future<void> configureDependencies(
  GetIt getIt,
  AppEnvironment environment,
) async {
  final config = AppConfig.I;

  // ── Telemetry first ──────────────────────────────────────────────────────
  // Registered before the data & navigation graphs because RestClient consumes
  // the CrashReporter and the router consumes the AnalyticsRouteObserver. Each
  // module falls back to a no-op implementation when its secret is unset, so
  // the app runs identically with telemetry disabled.
  MonitoringDiModule.init(getIt, enabled: config.sentryDsn.isNotEmpty);
  AnalyticsDiModule.init(getIt, enabled: config.clarityProjectId.isNotEmpty);

  await PrefStorageDi.init(getIt);
  DataDiModule.init(getIt);
  DomainDi.init(getIt);
}
