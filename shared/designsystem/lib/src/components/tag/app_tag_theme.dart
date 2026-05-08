import 'package:designsystem/src/components/tag/tag.dart';
import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppTagTheme extends ThemeExtension<AppTagTheme> {
  final AppTagVariantSet brand;
  final AppTagVariantSet info;

  const AppTagTheme({required this.brand, required this.info});

  AppTagVariantSet byIntent(AppTagIntent intent) => switch (intent) {
    AppTagIntent.brand => brand,
    AppTagIntent.info => info,
  };

  factory AppTagTheme.light() => AppTagTheme(
    brand: AppTagVariantSet.standard(
      solid: AppColors.brand500,
      onSolid: AppColors.white,
    ),
    info: AppTagVariantSet.standard(
      solid: AppColors.neutral200,
      onSolid: AppColors.black,
    ),
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppTagTheme.dark() => AppTagTheme.light();

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppTagTheme> copyWith() => this;

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppTagTheme> lerp(
    covariant ThemeExtension<AppTagTheme>? other,
    double t,
  ) => this;
}
