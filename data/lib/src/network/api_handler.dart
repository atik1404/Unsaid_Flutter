import 'package:common/common.dart';
import 'package:dio/dio.dart';

mixin ApiHandler {
  Future<Result<T, Failure>> execute<T>(Future<T> Function() apiCall) async {
    try {
      final response = await apiCall();
      return SuccessResult(response);
    } on DioException catch (e) {
      return FailureResult(_mapDioExceptionToFailure(e));
      // ignore: avoid_catching_errors
    } on TypeError catch (e) {
      // if the response type is not correct or parsing fails
      return FailureResult(ParseFailure(FailureKey.unknown, e.toString()));
    } on FormatException catch (e) {
      // if the json format is not correct
      return FailureResult(ParseFailure(FailureKey.unknown, e.toString()));
    } catch (e) {
      return const FailureResult(UnknownFailure(FailureKey.unknown, null));
    }
  }

  // --- ERROR MAPPER (Generics Preserved) ---
  Failure _mapDioExceptionToFailure(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
        return NetworkFailure(
          FailureKey.connectionTimeout,
          dioException.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          FailureKey.internet,
          dioException.response?.statusCode,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return UnknownFailure(
          FailureKey.unknown,
          dioException.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleServerError(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
    }
  }

  Failure _handleServerError(int? statusCode, dynamic errorData) {
    var message = "Oops! Something went wrong";
    if (errorData is Map<String, dynamic>) {
      message = errorData['message'] ?? message;
    } else if (errorData is String) {
      message = errorData;
    }
    return ServerFailure(message, statusCode);
  }
}
