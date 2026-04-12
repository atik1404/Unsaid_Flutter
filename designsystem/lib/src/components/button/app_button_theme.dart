import 'package:designsystem/src/components/button/button.dart';
import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  final AppButtonVariantSet brand;

  const AppButtonTheme({
    required this.brand,
  });

  AppButtonVariantSet byIntent(AppButtonIntent intent) => switch (intent) {
    AppButtonIntentBrand() => brand,
    AppButtonIntentCustom(variants: final v) => v,
  };

  factory AppButtonTheme.light() => AppButtonTheme(
    brand: AppButtonVariantSet.standard(
      solid: AppColors.brand500,
      onSolid: AppColors.white,
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
