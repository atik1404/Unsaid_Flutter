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
        ),
      )
      ..registerSingleton<RestClient>(RestClient(getIt<Dio>()))
      // Image Dio — separate host/port for multipart image uploads
      ..registerSingleton<Dio>(
        DioFactory.createImageClient(prefStorage),
        instanceName: _imageClientName,
      )
      ..registerSingleton<RestClient>(
        RestClient(getIt<Dio>(instanceName: _imageClientName)),
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
