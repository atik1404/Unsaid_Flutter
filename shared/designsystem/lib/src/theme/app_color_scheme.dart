import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppColorScheme extends ThemeExtension<AppColorScheme> {
  // Surfaces
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceTertiary;

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
  final Color brand;
  final Color secondary;

  const AppColorScheme({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
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
    required this.brand,
    required this.secondary,
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
      // Backgrounds: white base → lavender tints
      backgroundPrimary: AppColors.white, // #FFFFFF — pure white canvas
      backgroundSecondary: AppColors.neutral50, // #F5F3FF — lavender-tinted page bg
      backgroundTertiary: AppColors.neutral100, // #EDE8FF — subtle section divider bg
      // Surfaces: same progression as backgrounds
      surfacePrimary: AppColors.white, // #FFFFFF — cards & sheets
      surfaceSecondary: AppColors.neutral50, // #F5F3FF — elevated surface
      surfaceTertiary: AppColors.neutral100, // #EDE8FF — nested surface

      overlay: AppColors.brand700, // #1A1A2E — dark purple scrim
      // Content / text hierarchy
      contentPrimary: AppColors.neutral900, // #3D3060 — dark purple body text
      contentSecondary: AppColors.neutral500, // #8878AA — username / secondary text
      contentTertiary: AppColors.neutral400, // #B0A8CC — muted / placeholder text
      contentDisabled: AppColors.neutral300, // #C0B8D8 — non-interactive text
      contentBrand: AppColors.brand500, // #6D3FD4 — brand purple
      contentError: AppColors.error500, // #E25448 — rage red
      contentSuccess: AppColors.success500, // #17B26A — success green
      contentWarning: AppColors.warning500, // #F97316 — rant orange
      contentInfo: AppColors.secondary500, // #EC4899 — love pink
      // Borders
      borderPrimary: AppColors.neutral200, // #E8E4F0 — standard card borders
      borderSecondary: AppColors.neutral100, // #EDE8FF — light separators
      borderBrand: AppColors.brand500, // #6D3FD4 — brand border
      borderFocused: AppColors.brand500, // #6D3FD4 — focus ring
      borderError: AppColors.error500, // #E25448 — error border

      white: AppColors.white,
      black: AppColors.black,
      brand: AppColors.brand500, // #6D3FD4
      secondary: AppColors.secondary500, // #EC4899
    );
  }

  factory AppColorScheme.dark() {
    return const AppColorScheme(
      // Backgrounds: deep purple-black → slightly lighter layers
      backgroundPrimary: AppColors.brand900, // #0B0B14 — deepest app background
      backgroundSecondary: AppColors.brand800, // #111120 — card & feed background
      backgroundTertiary: AppColors.brand700, // #1A1A2E — borders used as bg layer
      // Surfaces: layered dark surfaces
      surfacePrimary: AppColors.brand800, // #111120 — primary card surface
      surfaceSecondary: AppColors.brand700, // #1A1A2E — elevated surface / bottom nav
      surfaceTertiary: AppColors.neutral800, // #25253A — subtle border / input bg

      overlay: AppColors.brand900, // #0B0B14 — full-screen dark scrim
      // Content / text hierarchy
      contentPrimary: AppColors.neutral300, // #C0B8D8 — primary body text (light on dark)
      contentSecondary: AppColors.neutral600, // #7070A0 — username / secondary text
      contentTertiary: AppColors.neutral700, // #46466A — muted / timestamp text
      contentDisabled: AppColors.neutral800, // #25253A — non-interactive elements
      contentBrand: AppColors.brand300, // #9D71F0 — brand purple on dark
      contentError: AppColors.error500, // #E25448 — rage red
      contentSuccess: AppColors.success500, // #17B26A — success green
      contentWarning: AppColors.warning500, // #F97316 — rant orange
      contentInfo: AppColors.secondary500, // #EC4899 — love pink
      // Borders
      borderPrimary: AppColors.neutral800, // #25253A — standard dark borders
      borderSecondary: AppColors.brand700, // #1A1A2E — subtle inner separators
      borderBrand: AppColors.brand300, // #9D71F0 — brand border on dark
      borderFocused: AppColors.brand300, // #9D71F0 — focus ring on dark
      borderError: AppColors.error500, // #E25448 — error border

      white: AppColors.white,
      black: AppColors.black,
      brand: AppColors.brand300, // #9D71F0
      secondary: AppColors.secondary500, // #EC4899
    );
  }
}
