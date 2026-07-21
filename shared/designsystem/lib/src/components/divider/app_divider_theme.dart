import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

class AppDividerTheme extends ThemeExtension<AppDividerTheme> {
  final Color primary;
  final Color secondary;
  final Color brand;

  const AppDividerTheme({
    required this.primary,
    required this.brand,
    required this.secondary,
  });

  Color byIntent(AppDividerIntent intent) => switch (intent) {
    AppDividerIntent.primary => primary,
    AppDividerIntent.secondary => secondary,
    AppDividerIntent.brand => brand,
  };

  factory AppDividerTheme.light() => const AppDividerTheme(
    primary: AppColors.neutral50,
    secondary: AppColors.neutral200,
    brand: AppColors.brand500,
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppDividerTheme.dark() => const AppDividerTheme(
    primary: AppColors.neutral700,
    secondary: AppColors.neutral600,
    brand: AppColors.brand500,
  );

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppDividerTheme> copyWith() => this;

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppDividerTheme> lerp(
    covariant ThemeExtension<AppDividerTheme>? other,
    double t,
  ) => this;
}
