import 'package:app_env/environment.dart';
import 'package:data/src/interceptor/interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pref_storage/pref_storage.dart';

final class DioFactory {
  /// API client — uses [AppConfig.baseUrl] for all JSON endpoints.
  ///
  /// [tokenRefreshDio] must be a clean Dio created via [createTokenRefreshClient]
  /// so the refresh call itself never triggers another 401 cycle.
  static Dio create({
    required AppPrefStorage prefStorage,
    required Dio tokenRefreshDio,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.I.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    if (AppConfig.I.environment.isDev || kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    dio.interceptors.add(
      TokenRefreshInterceptor(
        tokenRefreshDio: tokenRefreshDio,
        prefStorage: prefStorage,
      ),
    );
    if (AppConfig.I.environment.isDev || kDebugMode) {
      dio.interceptors.add(TokenLoggerInterceptor());
    }
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }

  /// Image-upload client — uses [AppConfig.imageUrl] (different host/port).
  static Dio createImageClient(AppPrefStorage prefStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.I.imageUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
      ),
    );
    if (AppConfig.I.environment.isDev || kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    dio.interceptors.add(TokenRefreshInterceptor(tokenRefreshDio: dio, prefStorage: prefStorage));
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }

  static Dio createTokenRefreshClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.I.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (AppConfig.I.environment.isDev || kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    return dio;
  }
}
