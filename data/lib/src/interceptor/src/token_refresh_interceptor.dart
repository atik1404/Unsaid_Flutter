import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pref_storage/pref_storage.dart';

final class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final Dio _tokenDio;
  final AuthStorageRepository _authStorage;
  final StorageRepository _storageRepository;
  final String _refreshPath;

  /// Completer-based concurrency control.
  /// Multiple 401s share a single refresh call.
  Completer<String?>? _refreshCompleter;

  TokenRefreshInterceptor({
    required Dio dio,
    required StorageRepository storageRepository,
    required AuthStorageRepository authStorage,
    String refreshPath = '/auth/api/v1/partner/refresh-token',
  }) : _dio = dio,
       _storageRepository = storageRepository,
       _authStorage = authStorage,
       _refreshPath = refreshPath,
       _tokenDio = Dio(
         BaseOptions(
           baseUrl: dio.options.baseUrl,
           connectTimeout: dio.options.connectTimeout,
           receiveTimeout: dio.options.receiveTimeout,
           sendTimeout: dio.options.sendTimeout,
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       )..httpClientAdapter = dio.httpClientAdapter; // share cert pinning

  // -------------------------------------------------------
  // REQUEST: Attach token if requiresAuth
  // -------------------------------------------------------

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_requiresAuth(options)) {
      return handler.next(options);
    }

    final token = await _authStorage.getAuthToken();
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  // -------------------------------------------------------
  // ERROR: Handle 401 → refresh → retry
  // -------------------------------------------------------

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 on authenticated requests
    if (err.response?.statusCode != 401 || !_requiresAuth(err.requestOptions)) {
      return handler.next(err);
    }

    // Refresh endpoint itself returned 401 → token is dead
    if (_isRefreshRequest(err.requestOptions)) {
      await _forceLogout();
      return handler.reject(err);
    }

    // Get a fresh token (concurrent callers share one refresh)
    final newToken = await _performTokenRefresh();

    if (newToken == null) {
      return handler.reject(err);
    }

    // Retry the original request with the new token
    try {
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await _dio.fetch(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.reject(retryError);
    }
  }

  // -------------------------------------------------------
  // REFRESH LOGIC — Completer-based concurrency
  // -------------------------------------------------------

  /// Returns a fresh access token, or null if refresh failed.
  /// If a refresh is already in progress, callers share the result.
  Future<String?> _performTokenRefresh() async {
    // Another request already triggered a refresh → wait for it
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    String? newAccessToken;

    try {
      final tokens = await _fetchNewTokens();

      if (tokens != null) {
        await _authStorage.saveAuthToken(tokens.accessToken);
        await _authStorage.saveRefreshToken(tokens.refreshToken);
        newAccessToken = tokens.accessToken;
      } else {
        await _forceLogout();
      }
    } catch (e) {
      debugPrint('TokenRefreshInterceptor: refresh failed — $e');
      await _forceLogout();
    }

    _refreshCompleter!.complete(newAccessToken);
    _refreshCompleter = null;

    return newAccessToken;
  }

  /// Calls the refresh endpoint using a dedicated Dio (no interceptors).
  Future<_TokenPair?> _fetchNewTokens() async {
    final refreshToken = await _authStorage.getRefreshToken();

    try {
      final response = await _tokenDio.post(
        _refreshPath,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final accessToken = data['accessToken'] as String?;
        if (accessToken == null) return null;

        return _TokenPair(
          accessToken: accessToken,
          refreshToken: (data['refreshToken'] as String?) ?? refreshToken,
        );
      }
    } catch (e) {
      debugPrint('TokenRefreshInterceptor: refresh request failed — $e');
    }

    return null;
  }

  // -------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------

  bool _requiresAuth(RequestOptions options) {
    return options.extra['requiresAuth'] == true;
  }

  bool _isRefreshRequest(RequestOptions options) {
    return options.path.contains(_refreshPath);
  }

  Future<void> _forceLogout() async {
    _refreshCompleter?.complete(null);
    _refreshCompleter = null;
    await _storageRepository.deleteAllData();
    //AuthEventBus.instance.dispatch(AuthEvent.sessionExpired);
  }
}

// -------------------------------------------------------
// INTERNAL: Token pair from refresh response
// -------------------------------------------------------

final class _TokenPair {
  final String accessToken;
  final String refreshToken;

  const _TokenPair({
    required this.accessToken,
    required this.refreshToken,
  });
}
