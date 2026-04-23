import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final class AppToast {
  static void toast({
    required String message,
    ToastType toastType = ToastType.info,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: _getColor(toastType),
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static Color _getColor(ToastType type) {
    return switch (type) {
      ToastType.success => Colors.green,
      ToastType.error => Colors.red,
      ToastType.warning => Colors.amberAccent.shade700,
      ToastType.info => Colors.blueAccent,
    };
  }
}

enum ToastType { success, error, warning, info }
