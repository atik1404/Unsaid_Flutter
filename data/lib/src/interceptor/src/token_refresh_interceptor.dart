import 'package:data/src/client/client.dart';
import 'package:dio/dio.dart';
import 'package:pref_storage/pref_storage.dart';

final class TokenRefreshInterceptor extends QueuedInterceptor {
  static const _kAccessTokenKey = 'accessToken';
  static const _kRefreshTokenKey = 'refreshToken';

  final Dio _tokenRefreshDio;
  final AppPrefStorage _prefStorage;
  final String _refreshPath;

  TokenRefreshInterceptor({
    required Dio tokenRefreshDio,
    required AppPrefStorage prefStorage,
    String refreshPath = '/auth/api/v1/partner/refresh-token',
  }) : _tokenRefreshDio = tokenRefreshDio,
       _prefStorage = prefStorage,
       _refreshPath = refreshPath;

  // -------------------------------------------------------
  // REQUEST: Attach token if requiresAuth
  // -------------------------------------------------------

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_requiresAuth(options)) return handler.next(options);

    final bearerToken = _toBearerHeader(await _prefStorage.getString(PrefKey.accessToken));
    if (bearerToken == null) {
      await _forceLogout();
      return handler.reject(DioException(requestOptions: options));
    }

    options.headers['Authorization'] = bearerToken;
    handler.next(options);
  }

  // -------------------------------------------------------
  // ERROR: Handle 401 → refresh → retry
  // -------------------------------------------------------

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra[DioExtraKeys.isRetry] == true) {
      if (_isUnauthorized(err) || _isSessionConflict(err)) {
        return _handleAuthFailure(err, handler);
      }
      return handler.next(err);
    }
    if (_isSessionConflict(err)) return _handleAuthFailure(err, handler);
    if (!_isUnauthorized(err)) return handler.next(err);
    if (_isRefreshRequest(err.requestOptions)) return _handleAuthFailure(err, handler);

    final attemptedAuth = err.requestOptions.headers['Authorization'];
    final currentAuth = _toBearerHeader(await _prefStorage.getString(PrefKey.accessToken));

    if (currentAuth != null && attemptedAuth != currentAuth) {
      await _retry(err, currentAuth, handler);
      return;
    }

    late final String newToken;
    try {
      final (accessToken, refreshToken) = await _fetchNewTokens();
      await _saveTokens(accessToken, refreshToken);
      newToken = accessToken;
    } on DioException catch (e) {
      if (_isNetworkError(e)) return handler.next(err);
      return _handleAuthFailure(err, handler);
    } catch (_) {
      return _handleAuthFailure(err, handler);
    }

    await _retry(err, 'Bearer $newToken', handler);
  }

  Future<void> _retry(
    DioException err,
    String authHeader,
    ErrorInterceptorHandler handler,
  ) async {
    err.requestOptions.headers['Authorization'] = authHeader;
    err.requestOptions.extra[DioExtraKeys.isRetry] = true;
    try {
      final response = await _tokenRefreshDio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(e is DioException ? e : err);
    }
  }

  /// Calls the refresh endpoint using a dedicated Dio (no interceptors).
  Future<_TokenPair> _fetchNewTokens() async {
    final refreshToken = await _prefStorage.getString(PrefKey.refreshToken);
    if (refreshToken.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: _refreshPath),
        message: 'No refresh token in storage',
      );
    }
    final response = await _tokenRefreshDio.post(
      _refreshPath,
      data: {_kRefreshTokenKey: refreshToken},
    );

    if (response.statusCode == 200 && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data['data'][_kAccessTokenKey]?.toString();
      final newRefreshToken = data['data'][_kRefreshTokenKey]?.toString();
      if (newAccessToken != null && newRefreshToken != null) {
        return (newAccessToken, newRefreshToken);
      }
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  // -------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------

  bool _requiresAuth(RequestOptions options) => options.extra[DioExtraKeys.requiresAuth] == true;

  bool _isRefreshRequest(RequestOptions options) => options.path == _refreshPath || options.path.endsWith(_refreshPath);

  bool _isUnauthorized(DioException err) => err.response?.statusCode == 401 && _requiresAuth(err.requestOptions);

  bool _isSessionConflict(DioException err) => err.response?.statusCode == 409 && _requiresAuth(err.requestOptions);

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.connectionError;

  String? _toBearerHeader(String? token) => (token == null || token.isEmpty) ? null : 'Bearer $token';

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _prefStorage.write(PrefKey.accessToken, accessToken);
    await _prefStorage.write(PrefKey.refreshToken, refreshToken);
  }

  Future<void> _handleAuthFailure(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    await _forceLogout();
    handler.reject(err);
  }

  Future<void> _forceLogout() async {
    await _prefStorage.clear();
    //AuthEventBus.instance.dispatch(AuthEvent.sessionExpired);
  }
}

// -------------------------------------------------------
// INTERNAL: Token pair from refresh response
// -------------------------------------------------------
typedef _TokenPair = (String accessToken, String refreshToken);
