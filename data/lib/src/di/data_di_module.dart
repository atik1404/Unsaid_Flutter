import 'package:common/common.dart';
import 'package:data/src/client/client.dart';
import 'package:data/src/datasource/data_source.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:pref_storage/pref_storage.dart';

class DataDiModule {
  DataDiModule._();

  static const String _imageClientName = 'imageClient';
  static const String _tokenRefreshClientName = 'tokenRefreshClient';

  static void init(GetIt getIt) {
    final prefStorage = getIt<AppPrefStorage>();
    // Resolve the crash reporter registered by MonitoringDiModule (runs first).
    // Falls back to a no-op if monitoring wasn't registered (e.g. in tests).
    final crashReporter = getIt.isRegistered<CrashReporter>()
        ? getIt<CrashReporter>()
        : const NoopCrashReporter();

    // Same contract as above for the telemetry session composed in app_di: the
    // token interceptor uses it to clear the Sentry/Clarity user when the
    // backend rejects the stored credentials (session expiry).
    final telemetrySession = getIt.isRegistered<TelemetrySession>()
        ? getIt<TelemetrySession>()
        : const TelemetrySession.noop();

    final tokenRefreshDio = DioFactory.createTokenRefreshClient();
    getIt
      ..registerSingleton<Dio>(
        tokenRefreshDio,
        instanceName: _tokenRefreshClientName,
      )
      // API Dio — base URL for all JSON endpoints
      ..registerSingleton<Dio>(
        DioFactory.create(
          prefStorage: prefStorage,
          tokenRefreshDio: tokenRefreshDio,
          telemetrySession: telemetrySession,
        ),
      )
      ..registerSingleton<RestClient>(
        RestClient(getIt<Dio>(), crashReporter),
      )
      // Image Dio — separate host/port for multipart image uploads
      ..registerSingleton<Dio>(
        DioFactory.createImageClient(prefStorage, telemetrySession: telemetrySession),
        instanceName: _imageClientName,
      )
      ..registerSingleton<RestClient>(
        RestClient(
          getIt<Dio>(instanceName: _imageClientName),
          crashReporter,
        ),
        instanceName: _imageClientName,
      )
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepoImpl(getIt<RestClient>(), prefStorage),
      )
      ..registerLazySingleton<CommonRepository>(
        () => CommonRepoImpl(getIt<RestClient>()),
      )
      ..registerLazySingleton<PostRepository>(
        () => PostRepoImpl(getIt<RestClient>()),
      );
  }
}
