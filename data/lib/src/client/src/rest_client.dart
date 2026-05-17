import 'package:common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final class RestClient {
  final Dio _dio;
  const RestClient(this._dio);

  // --- GET ---
  Future<Result<T, Failure>> get<T>(
    String path, {
    required T Function(dynamic data) parser,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _execute(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
      parser: parser,
    );
  }

  // --- POST ---
  Future<Result<T, Failure>> post<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _execute(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      parser: parser,
    );
  }

  // --- PUT ---
  Future<Result<T, Failure>> put<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  // --- PATCH ---
  Future<Result<T, Failure>> patch<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  // --- DELETE ---
  Future<Result<T, Failure>> delete<T>(
    String path, {
    required T Function(dynamic data) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  // --- Fire-and-forget / void endpoints ---
  Future<Result<void, Failure>> send(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      ),
      parser: (_) {},
    );
  }

  // ============================================================
  // 5. CORE EXECUTION — Private, every call funnels through here
  // ============================================================

  Future<Result<T, Failure>> _execute<T>(
    Future<Response> Function() request, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();
      final parsed = parser(response.data);
      return SuccessResult(parsed);
    } on DioException catch (e) {
      return FailureResult(_mapDioException(e));
    } on TypeError catch (e, stackTrace) {
      if (kDebugMode) rethrow; // fail loud in dev
      _logError('TypeError during parsing', e, stackTrace);
      return FailureResult(ParseFailure(FailureKey.unknown, e.toString()));
    } on FormatException catch (e, stackTrace) {
      if (kDebugMode) rethrow;
      _logError('FormatException during parsing', e, stackTrace);
      return FailureResult(ParseFailure(FailureKey.unknown, e.toString()));
    } catch (e, stackTrace) {
      _logError('Unexpected error', e, stackTrace);
      return const FailureResult(UnknownFailure(FailureKey.unknown, null));
    }
  }

  // ============================================================
  // 6. ERROR MAPPING
  // ============================================================

  Failure _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;

    return switch (e.type) {
      DioExceptionType.sendTimeout || DioExceptionType.receiveTimeout || DioExceptionType.connectionTimeout => NetworkFailure(FailureKey.connectionTimeout, statusCode),

      DioExceptionType.connectionError => NetworkFailure(FailureKey.network, statusCode),

      DioExceptionType.cancel => UnknownFailure(FailureKey.requestCancelled, statusCode),

      DioExceptionType.badResponse => _handleServerError(statusCode, e.response?.data),

      DioExceptionType.badCertificate || DioExceptionType.unknown => UnknownFailure(FailureKey.unknown, statusCode),
    };
  }

  Failure _handleServerError(int? statusCode, dynamic errorData) {
    var message = ''; // will fall through to locale key at UI layer
    Map<String, List<String>>? fieldErrors;

    if (errorData is Map<String, dynamic>) {
      message = errorData['message'] ?? 'Unknown error occurred';
      final rawErrors = errorData['errors'];
      if (rawErrors is Map<String, dynamic>) {
        fieldErrors = rawErrors.map(
          (key, value) => MapEntry(
            key,
            (value is List) ? value.cast<String>() : [value.toString()],
          ),
        );
      }
    } else if (errorData is String) {
      message = errorData;
    }
    return ServerFailure(message, statusCode, fieldErrors: fieldErrors);
  }

  void _logError(String context, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('[$context] $error\n$stackTrace');
      return;
    }
    //FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: context);
  }
}
