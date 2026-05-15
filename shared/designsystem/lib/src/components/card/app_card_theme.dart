import 'package:designsystem/src/components/card/card.dart';
import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:designsystem/src/tokens/app_elevation.dart';
import 'package:flutter/material.dart';

final class AppCardTheme extends ThemeExtension<AppCardTheme> {
  final AppCardVariantSet warning;
  final AppCardVariantSet primary;
  final AppCardVariantSet secondary;
  final AppCardVariantSet danzer;

  const AppCardTheme({
    required this.warning,
    required this.primary,
    required this.secondary,
    required this.danzer,
  });

  AppCardVariantSet byTone(AppCardTone tone) => switch (tone) {
    AppCardTone.warning => warning,
    AppCardTone.primary => primary,
    AppCardTone.secondary => secondary,
    AppCardTone.danzer => danzer,
  };

  double defaultElevationFor(AppCardTone tone) => switch (tone) {
    AppCardTone.warning => AppElevation.flat,
    AppCardTone.primary => AppElevation.flat,
    AppCardTone.secondary => AppElevation.flat,
    AppCardTone.danzer => AppElevation.flat,
  };

  factory AppCardTheme.light() => AppCardTheme(
    warning: AppCardVariantSet.standard(
      surface: AppColors.white,
      border: AppColors.neutral100,
    ),
    primary: AppCardVariantSet.standard(
      surface: AppColors.white,
      border: AppColors.neutral100,
    ),
    secondary: AppCardVariantSet.standard(
      surface: AppColors.white,
      border: AppColors.neutral100,
    ),
    danzer: AppCardVariantSet.standard(
      surface: AppColors.error50,
      border: AppColors.error200,
    ),
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppCardTheme.dark() => AppCardTheme(
    warning: AppCardVariantSet.standard(
      surface: AppColors.neutral800,
      border: AppColors.neutral600,
    ),
    primary: AppCardVariantSet.standard(
      surface: AppColors.neutral800,
      border: AppColors.neutral600,
    ),
    secondary: AppCardVariantSet.standard(
      surface: AppColors.neutral800,
      border: AppColors.neutral600,
    ),
    danzer: AppCardVariantSet.standard(
      surface: AppColors.error800,
      border: AppColors.error700,
    ),
  );

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppCardTheme> copyWith() => this;

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppCardTheme> lerp(
    covariant ThemeExtension<AppCardTheme>? other,
    double t,
  ) {
    return this;
  }
}
