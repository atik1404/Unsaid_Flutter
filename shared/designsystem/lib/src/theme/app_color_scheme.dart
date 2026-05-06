import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppColorScheme extends ThemeExtension<AppColorScheme> {
  // Surfaces
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundDisabled;

  // Overlay
  final Color overlay; // scrim behind modals/dialogs (use with opacity)

  // Content hierarchy (text + icons by emphasis level)
  final Color contentPrimary; // high emphasis
  final Color contentSecondary; // medium emphasis
  final Color contentTertiary; // low emphasis
  final Color contentDisabled; // non-interactive
  final Color contentBrand; // brand-colored content
  final Color contentError; // error-colored content
  final Color contentSuccess; // success-colored content
  final Color contentWarning; // warning-colored content
  final Color contentInfo; // info-colored content

  // Borders & divider
  final Color borderPrimary; // standard borders
  final Color borderSecondary; // light dividers, separators
  final Color borderBrand; // brand-colored border & divider
  final Color borderFocused; // keyboard/accessibility focus rings
  final Color borderError; // error-colored border & divider

  final Color white;
  final Color black;

  const AppColorScheme({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundDisabled,
    required this.overlay,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.contentDisabled,
    required this.contentBrand,
    required this.contentError,
    required this.contentSuccess,
    required this.contentWarning,
    required this.contentInfo,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderBrand,
    required this.borderFocused,
    required this.borderError,
    required this.white,
    required this.black,
  });

  @override
  ThemeExtension<AppColorScheme> copyWith() => this;

  @override
  ThemeExtension<AppColorScheme> lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) => this;

  factory AppColorScheme.light() {
    return const AppColorScheme(
      backgroundPrimary: AppColors.white,
      backgroundSecondary: AppColors.neutral50,
      backgroundDisabled: AppColors.neutral100,
      overlay: AppColors.neutral800,
      contentPrimary: AppColors.neutral900,
      contentSecondary: AppColors.neutral500,
      contentTertiary: AppColors.brand100,
      contentDisabled: AppColors.neutral300,
      contentBrand: AppColors.brand500,
      contentError: AppColors.error500,
      contentSuccess: AppColors.success500,
      contentWarning: AppColors.warning500,
      contentInfo: AppColors.neutral300,

      borderPrimary: AppColors.neutral200,
      borderSecondary: AppColors.neutral100,
      borderBrand: AppColors.brand500,
      borderFocused: AppColors.brand500,
      borderError: AppColors.error500,
      white: AppColors.white,
      black: AppColors.black,
    );
  }

  factory AppColorScheme.dark() => AppColorScheme.light();
}
