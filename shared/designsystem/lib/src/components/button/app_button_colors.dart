import 'package:flutter/material.dart';

@immutable
class AppButtonColors {
  final Color background;
  final Color foreground;
  final Color border;

  const AppButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

@immutable
class AppButtonVariantSet {
  final AppButtonColors filled;
  final AppButtonColors outline;
  final AppButtonColors text;

  const AppButtonVariantSet({
    required this.filled,
    required this.outline,
    required this.text,
  });

  factory AppButtonVariantSet.standard({
    required Color solid,
    required Color onSolid,
    Color? outlineForeground,
    Color? textForeground,
  }) {
    return AppButtonVariantSet(
      filled: AppButtonColors(
        background: solid,
        foreground: onSolid,
        border: solid,
      ),
      outline: AppButtonColors(
        background: Colors.transparent,
        foreground: outlineForeground ?? solid,
        border: solid,
      ),
      text: AppButtonColors(
        background: Colors.transparent,
        foreground: textForeground ?? solid,
        border: Colors.transparent,
      ),
    );
  }
}
