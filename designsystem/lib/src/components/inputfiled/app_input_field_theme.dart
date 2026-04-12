import 'package:designsystem/src/components/inputfiled/app_input_field_colors.dart';
import 'package:designsystem/src/tokens/app_border_width.dart';
import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppInputFieldTheme extends ThemeExtension<AppInputFieldTheme> {
  final AppInputFieldColors colors;
  final double focusedBorderWidth;
  final double defaultBorderWidth;

  const AppInputFieldTheme({
    required this.colors,
    this.focusedBorderWidth = AppBorderWidths.thick,
    this.defaultBorderWidth = AppBorderWidths.thin,
  });

  factory AppInputFieldTheme.light() => const AppInputFieldTheme(
    colors: AppInputFieldColors(
      fill: AppColors.neutral100,
      fillDisabled: AppColors.neutral100,
      borderDefault: AppColors.neutral300,
      borderHover: AppColors.neutral400,
      borderFocused: AppColors.brand500,
      borderError: AppColors.error500,
      borderErrorFocused: AppColors.error600,
      borderDisabled: AppColors.neutral200,
      text: AppColors.neutral900,
      textDisabled: AppColors.neutral400,
      placeholder: AppColors.neutral400,
      label: AppColors.neutral700,
      labelFocused: AppColors.brand500,
      labelError: AppColors.error500,
      labelDisabled: AppColors.neutral400,
      helper: AppColors.neutral600,
      helperError: AppColors.error500,
      icon: AppColors.neutral500,
      iconFocused: AppColors.brand500,
      iconError: AppColors.error500,
      iconDisabled: AppColors.neutral300,
      cursor: AppColors.brand500,
    ),
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppInputFieldTheme.dark() => AppInputFieldTheme.light();

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppInputFieldTheme> copyWith({
    AppInputFieldColors? colors,
    double? focusedBorderWidth,
    double? defaultBorderWidth,
  }) {
    return AppInputFieldTheme(
      colors: colors ?? this.colors,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      defaultBorderWidth: defaultBorderWidth ?? this.defaultBorderWidth,
    );
  }

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppInputFieldTheme> lerp(
    covariant ThemeExtension<AppInputFieldTheme>? other,
    double t,
  ) => this;
}
