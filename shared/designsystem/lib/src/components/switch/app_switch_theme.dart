import 'package:designsystem/src/components/switch/app_switch_colors.dart';
import 'package:designsystem/src/components/switch/app_switch_enums.dart';
import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppSwitchTheme extends ThemeExtension<AppSwitchTheme> {
  final AppSwitchColors primary;
  final AppSwitchColors secondary;

  const AppSwitchTheme({
    required this.primary,
    required this.secondary,
  });

  AppSwitchColors byIntent(AppSwitchIntent intent) => switch (intent) {
    AppSwitchIntent.primary => primary,
    AppSwitchIntent.secondary => secondary,
  };

  factory AppSwitchTheme.light() => const AppSwitchTheme(
    primary: AppSwitchColors(
      trackActive: AppColors.brand500,
      trackInactive: AppColors.neutral300,
      thumb: AppColors.white,
    ),
    secondary: AppSwitchColors(
      trackActive: AppColors.warning500,
      trackInactive: AppColors.neutral300,
      thumb: AppColors.white,
    ),
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppSwitchTheme.dark() => AppSwitchTheme.light();

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppSwitchTheme> copyWith() => this;

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppSwitchTheme> lerp(
    covariant ThemeExtension<AppSwitchTheme>? other,
    double t,
  ) => this;
}
