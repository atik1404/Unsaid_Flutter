import 'package:dio/dio.dart';

extension AuthOptions on Options {
  /// Mark a request as requiring authentication.
  /// The interceptor will attach the Bearer token automatically.
  static Options authenticated() {
    return Options(extra: {DioExtraKeys.requiresAuth: true});
  }

  /// Mark a request as supporting optional authentication.
  /// The interceptor attaches the Bearer token when the user is logged in,
  /// and otherwise lets the request through unauthenticated (no force logout).
  static Options optional() {
    return Options(extra: {DioExtraKeys.optionalAuth: true});
  }

  /// Merge auth flag with other options (timeout, headers, etc.)
  Options withAuth() {
    return Options(
      method: method,
      headers: headers,
      contentType: contentType,
      responseType: responseType,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      extra: {...?extra, DioExtraKeys.requiresAuth: true},
    );
  }

  /// Merge optional-auth flag with other options (timeout, headers, etc.)
  Options withOptionalAuth() {
    return Options(
      method: method,
      headers: headers,
      contentType: contentType,
      responseType: responseType,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      extra: {...?extra, DioExtraKeys.optionalAuth: true},
    );
  }
}

abstract final class DioExtraKeys {
  static const requiresAuth = 'requiresAuth';
  static const optionalAuth = 'optionalAuth';
  static const isRetry = '_isRetry';
  static const skipRetry = '_skipRetry';
}
