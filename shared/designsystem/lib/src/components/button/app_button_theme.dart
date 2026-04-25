import 'package:designsystem/src/components/button/button.dart';
import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  final AppButtonVariantSet primary;
  final AppButtonVariantSet secondary;

  const AppButtonTheme({
    required this.primary,
    required this.secondary,
  });

  AppButtonVariantSet byIntent(AppButtonIntent intent) => switch (intent) {
    AppButtonIntentPrimary() => primary,
    AppButtonIntentCustom(variants: final v) => v,
    AppButtonIntentSecondary() => secondary,
  };

  factory AppButtonTheme.light() => const AppButtonTheme(
    primary: AppButtonVariantSet(
      filled: AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.white,
        border: AppColors.brand500,
        gradient: LinearGradient(
          colors: [AppColors.brand500, AppColors.brand300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      outline: AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.brand500,
        border: AppColors.brand500,
      ),
      text: AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.brand500,
        border: Colors.transparent,
      ),
    ),
    secondary: AppButtonVariantSet(
      filled: AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.warning500,
        border: AppColors.warning500,
      ),
      outline: AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.warning500,
        border: AppColors.warning500,
      ),
      text: AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.warning500,
        border: Colors.transparent,
      ),
    ),
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppButtonTheme.dark() => AppButtonTheme.light();

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppButtonTheme> copyWith() => this;

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppButtonTheme> lerp(
    covariant ThemeExtension<AppButtonTheme>? other,
    double t,
  ) => this;
}
