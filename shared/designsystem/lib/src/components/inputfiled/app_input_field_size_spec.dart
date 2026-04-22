import 'package:designsystem/src/components/inputfiled/inputfield.dart';
import 'package:designsystem/src/components/typography/app_typography_intent.dart';
import 'package:flutter/material.dart';

class AppInputFieldSizeSpec {
  final double height;
  final EdgeInsetsGeometry contentPadding;
  final double iconSize;
  final double borderRadius;

  // Typography intents — resolved at build time, not hardcoded sizes
  final AppTypographyIntent textIntent;
  final AppTypographyIntent labelIntent;
  final AppTypographyIntent helperIntent;

  const AppInputFieldSizeSpec({
    required this.height,
    required this.contentPadding,
    required this.iconSize,
    required this.borderRadius,
    required this.textIntent,
    required this.labelIntent,
    required this.helperIntent,
  });

  static const sm = AppInputFieldSizeSpec(
    height: 36,
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    iconSize: 16,
    borderRadius: 6,
    textIntent: AppTypographyIntent.bodySmall,
    labelIntent: AppTypographyIntent.labelSmall,
    helperIntent: AppTypographyIntent.captionSmall,
  );

  static const md = AppInputFieldSizeSpec(
    height: 44,
    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    iconSize: 18,
    borderRadius: 8,
    textIntent: AppTypographyIntent.bodyMedium,
    labelIntent: AppTypographyIntent.labelMedium,
    helperIntent: AppTypographyIntent.captionMedium,
  );

  static const lg = AppInputFieldSizeSpec(
    height: 52,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    iconSize: 20,
    borderRadius: 10,
    textIntent: AppTypographyIntent.bodyLarge,
    labelIntent: AppTypographyIntent.labelLarge,
    helperIntent: AppTypographyIntent.captionLarge,
  );

  static AppInputFieldSizeSpec of(AppInputFieldSize size) => switch (size) {
    AppInputFieldSize.sm => sm,
    AppInputFieldSize.md => md,
    AppInputFieldSize.lg => lg,
  };
}
