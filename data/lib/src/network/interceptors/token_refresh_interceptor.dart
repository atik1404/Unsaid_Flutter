import 'package:dio/dio.dart';
import 'package:sharedpref/sharedpref.dart';

final class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final SharedPrefManager _prefm;

  bool _isRefreshing = false;
  final List<RequestQueueItem> _requestQueue = [];

  TokenRefreshInterceptor({
    required Dio dio,
    required SharedPrefManager prefm,
  }) : _dio = dio,
       _prefm = prefm;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isWhitelisted(options.path)) {
      return handler.next(options);
    }
    final token = _prefm.getString('accessToken');
    if (token != '') {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      //If refresh token is expired or failed then logout the user
      if (options.path.contains('refresh-token')) {
        await _prefm.clear();
        _requestQueue.clear();
        return handler.next(err);
      }

      // Add the request to the queue
      _requestQueue.add(RequestQueueItem(options, handler));

      // If already refreshing, then add the request to the queue and return
      if (_isRefreshing) {
        return;
      }

      _isRefreshing = true;
      try {
        final newTokens = await _refreshToken();
        if (newTokens != null) {
          await _prefm.setString('accessToken', newTokens['accessToken']);
          await _prefm.setString('refreshToken', newTokens['refreshToken']);
          _processQueue(newTokens['accessToken']);
        } else {
          _rejectQueue(err);
          await _prefm.clear();
        }
      } catch (e) {
        _rejectQueue(err);
        await _prefm.clear();
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }

  void _processQueue(String? newToken) {
    for (final item in _requestQueue) {
      item.options.headers['Authorization'] = 'Bearer $newToken';
      _dio.fetch(item.options).then(item.handler.resolve).catchError((e) {
        item.handler.reject(e as DioException);
      });
    }
    _requestQueue.clear();
    _isRefreshing = false;
  }

  void _rejectQueue(DioException err) {
    for (final item in _requestQueue) {
      item.handler.next(err);
    }
    _requestQueue.clear();
  }

  Future<Map<String, dynamic>?> _refreshToken() async {
    try {
      final refreshToken = _prefm.getString('refreshToken');
      if (refreshToken == '') return null;

      // Separate Dio instance to avoid infinite loops
      final tokenDio = Dio(BaseOptions(baseUrl: "https://api.example.com"));

      final response = await tokenDio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200) {
        return {
          'accessToken': response.data['accessToken'],
          'refreshToken': response.data['refreshToken'] ?? refreshToken,
        };
      }
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  bool _isWhitelisted(String path) {
    return path.contains('login') || path.contains('refresh-token') || path.contains('register');
  }
}

class RequestQueueItem {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  RequestQueueItem(this.options, this.handler);
}
