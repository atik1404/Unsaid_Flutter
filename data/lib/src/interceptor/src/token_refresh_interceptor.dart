import 'package:data/src/client/client.dart';
import 'package:dio/dio.dart';
import 'package:pref_storage/pref_storage.dart';

final class TokenRefreshInterceptor extends QueuedInterceptor {
  static const _kAccessTokenKey = 'access_token';
  static const _kRefreshTokenKey = 'refresh_token';
  static const _kExpiresInKey = 'expires_in';

  final Dio _tokenRefreshDio;
  final AppPrefStorage _prefStorage;
  final String _refreshPath;

  TokenRefreshInterceptor({
    required this._tokenRefreshDio,
    required this._prefStorage,
    this._refreshPath = '/auth/refresh',
  });

  // -------------------------------------------------------
  // REQUEST: Attach token if requiresAuth
  // -------------------------------------------------------

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final requiresAuth = _requiresAuth(options);
    final optionalAuth = _optionalAuth(options);
    if (!requiresAuth && !optionalAuth) return handler.next(options);

    final bearerToken = _toBearerHeader(await _prefStorage.getSecureString(PrefKey.accessToken));
    if (bearerToken == null) {
      // Optional-auth endpoints proceed as a guest when no token is stored.
      if (optionalAuth) return handler.next(options);
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
    final currentAuth = _toBearerHeader(await _prefStorage.getSecureString(PrefKey.accessToken));

    if (currentAuth != null && attemptedAuth != currentAuth) {
      await _retry(err, currentAuth, handler);
      return;
    }

    late final String newToken;
    try {
      final (accessToken, refreshToken, expiresIn) = await _fetchNewTokens();
      await _saveTokens(accessToken, refreshToken, expiresIn);
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
  Future<_TokenRecord> _fetchNewTokens() async {
    final refreshToken = await _prefStorage.getSecureString(PrefKey.refreshToken);
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
      final newAccessToken = data[_kAccessTokenKey]?.toString();
      final newRefreshToken = data[_kRefreshTokenKey]?.toString();
      final expiresIn = data[_kExpiresInKey]?.toString();
      if (newAccessToken != null && newRefreshToken != null && expiresIn != null) {
        return (newAccessToken, newRefreshToken, expiresIn);
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

  bool _optionalAuth(RequestOptions options) => options.extra[DioExtraKeys.optionalAuth] == true;

  /// True when the request participates in the auth lifecycle: either it
  /// strictly requires auth, or it is optional-auth and actually carried a
  /// token (so a 401 is worth a refresh). Guest optional-auth requests are
  /// excluded — there is nothing to refresh.
  bool _isAuthEnforced(RequestOptions options) =>
      _requiresAuth(options) || (_optionalAuth(options) && options.headers.containsKey('Authorization'));

  bool _isRefreshRequest(RequestOptions options) => options.path == _refreshPath || options.path.endsWith(_refreshPath);

  bool _isUnauthorized(DioException err) => err.response?.statusCode == 401 && _isAuthEnforced(err.requestOptions);

  bool _isSessionConflict(DioException err) => err.response?.statusCode == 409 && _isAuthEnforced(err.requestOptions);

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError;

  String? _toBearerHeader(String? token) => (token == null || token.isEmpty) ? null : 'Bearer $token';

  Future<void> _saveTokens(String accessToken, String refreshToken, String expiresIn) async {
    await _prefStorage.write(PrefKey.accessToken, accessToken);
    await _prefStorage.write(PrefKey.refreshToken, refreshToken);
    await _prefStorage.write(PrefKey.accessTokenExpiresIn, expiresIn);
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
typedef _TokenRecord = (String accessToken, String refreshToken, String expiresIn);
