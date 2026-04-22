import 'package:flutter/foundation.dart';

final class Logcat {
  static void log<T>(T message) {
    if (kDebugMode) {
      debugPrint(message.toString());
    }
  }
}
