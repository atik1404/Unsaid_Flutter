import 'package:app_env/environment.dart';
import 'package:data/src/interceptor/interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pref_storage/pref_storage.dart';

final class DioFactory {
  /// API client — uses [AppConfig.baseUrl] for all JSON endpoints.
  static Dio create(AuthStorageRepository authStorage, StorageRepository storageRepository) {
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
        //contentType: 'application/json': Data is sent as a JSON body. Preserves types — int stays int, bool stays bool, nested objects work. Most modern REST APIs expect this.
        // contentType: 'application/x-www-form-urlencoded': Data is sent as URL-encoded key-value pairs. Good for simple forms and some legacy systems. Nested structures are difficult and usually require manual encoding.
        // contentType: 'multipart/form-data': Used for file uploads (images, PDFs, etc.). Data is sent as a series of form fields, each potentially containing a file. Requires the receiving server to parse the multipart boundary.
      ),
    );
    if (AppConfig.I.environment.isDev || kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
    dio.interceptors.add(TokenRefreshInterceptor(dio: dio, authStorage: authStorage, storageRepository: storageRepository));
    if (AppConfig.I.environment.isDev || kDebugMode) {
      dio.interceptors.add(TokenLoggerInterceptor());
    }
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }

  /// Image-upload client — uses [AppConfig.imageUrl] (different host/port).
  static Dio createImageClient(AuthStorageRepository authStorage, StorageRepository storageRepository) {
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
    dio.interceptors.add(TokenRefreshInterceptor(dio: dio, authStorage: authStorage, storageRepository: storageRepository));
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }
}
