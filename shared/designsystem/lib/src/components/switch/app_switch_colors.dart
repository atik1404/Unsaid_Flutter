import 'package:flutter/material.dart';

@immutable
class AppSwitchColors {
  final Color trackActive;
  final Color trackInactive;
  final Color thumb;

  const AppSwitchColors({
    required this.trackActive,
    required this.trackInactive,
    required this.thumb,
  });
}
