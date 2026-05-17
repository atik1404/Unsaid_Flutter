import 'package:dio/dio.dart';

class TimeoutOptions {
  const TimeoutOptions._();

  static Options longRunning({
    Duration timeout = const Duration(minutes: 5),
  }) {
    return Options(receiveTimeout: timeout, sendTimeout: timeout);
  }

  static Options quick({
    Duration timeout = const Duration(seconds: 10),
  }) {
    return Options(receiveTimeout: timeout, sendTimeout: timeout);
  }
}
