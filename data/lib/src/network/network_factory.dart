import 'package:common/common.dart';
import 'package:data/src/network/interceptors/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sharedpref/sharedpref.dart';

final class NetworkFactory {
  static Dio create(SharedPrefManager pref) {
    final dio = Dio(
      BaseOptions(
        baseUrl:
            "https://jsonplaceholder.typicode.com", //TODO : set this from ENV file
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    if (kDebugMode) {
      AppLog.log('AuthToken: ${pref.getString(SharedPrefKeys.authToken)}');
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    //adding Retry Interceptor
    dio.interceptors.add(RetryInterceptor(dio: dio));

    //adding Token Refresh Interceptor
    //dio.interceptors.add(TokenRefreshInterceptor(dio: dio, prefm: pref));
    return dio;
  }
}
