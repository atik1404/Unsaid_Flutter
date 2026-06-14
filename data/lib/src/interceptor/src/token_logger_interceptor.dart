import 'package:common/common.dart';
import 'package:dio/dio.dart';

class TokenLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = options.headers['Authorization'];
    AppLog.log('AccessToken: $token');
    super.onRequest(options, handler);
  }
}
