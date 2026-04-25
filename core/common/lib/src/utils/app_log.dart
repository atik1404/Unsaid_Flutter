import 'package:flutter/foundation.dart';

final class AppLog {
  static void log<T>(T message) {
    if (kDebugMode) {
      debugPrint(message.toString());
    }
  }
}
