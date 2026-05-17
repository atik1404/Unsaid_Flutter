import 'package:dio/dio.dart';

extension AuthOptions on Options {
  /// Mark a request as requiring authentication.
  /// The interceptor will attach the Bearer token automatically.
  static Options authenticated() {
    return Options(extra: {'requiresAuth': true});
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
      extra: {...?extra, 'requiresAuth': true},
    );
  }
}
