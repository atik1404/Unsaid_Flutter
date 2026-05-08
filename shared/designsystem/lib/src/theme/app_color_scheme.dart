import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class AppColorScheme extends ThemeExtension<AppColorScheme> {
  // ─── Surfaces ─────────────────────────────────────────────────────────────
  final Color backgroundPrimary; // light #FFFFFF  | dark #0B0B14
  final Color backgroundSecondary; // light #F5F3FF  | dark #111120
  final Color backgroundTertiary; // light #EDE8FF  | dark #1A1A2E

  final Color surfacePrimary; // light #FFFFFF  | dark #111120
  final Color surfaceSecondary; // light #F5F3FF  | dark #1A1A2E
  final Color surfaceTertiary; // light #EDE8FF  | dark #25253A

  // ── Added surfaces ────────────────────────────────────────────────────────
  final Color surfaceDeep; // light #FFFFFF  | dark #0D0D1C  — deep feed/nested card bg
  final Color surfaceAvatar; // light #F5F0FF  | dark #13102A  — tinted bg behind avatar icons
  final Color surfaceDestructive; // light #FFF0F0  | dark #1A0C0C  — danger zone / delete area bg
  final Color surfaceInput; // light #FAF8FF  | dark #111120  — text input / textarea bg

  // ─── Overlay ──────────────────────────────────────────────────────────────
  final Color overlay; // light #1A1A2E  | dark #0B0B14  — scrim behind modals/dialogs (use with opacity)

  // ─── Content hierarchy (text + icons by emphasis level) ───────────────────
  final Color contentPrimary; // light #3D3060  | dark #C0B8D8  — high emphasis
  final Color contentSecondary; // light #8878AA  | dark #7070A0  — medium emphasis
  final Color contentTertiary; // light #B0A8CC  | dark #46466A  — low emphasis
  final Color contentDisabled; // light #C0B8D8  | dark #25253A  — non-interactive
  final Color contentBrand; // light #6D3FD4  | dark #9D71F0  — brand-colored content
  final Color contentError; // light #E25448  | dark #E25448  — error-colored content
  final Color contentSuccess; // light #17B26A  | dark #17B26A  — success-colored content
  final Color contentWarning; // light #F97316  | dark #F97316  — warning-colored content
  final Color contentInfo; // light #EC4899  | dark #EC4899  — info-colored content

  // ── Added content ─────────────────────────────────────────────────────────
  final Color contentSubtle; // light #A09AB8  | dark #35354E  — timestamps, captions, status bar labels

  // ─── Borders & dividers ───────────────────────────────────────────────────
  final Color borderPrimary; // light #E8E4F0  | dark #25253A  — standard borders
  final Color borderSecondary; // light #EDE8FF  | dark #1A1A2E  — light dividers, separators
  final Color borderBrand; // light #6D3FD4  | dark #9D71F0  — brand-colored border & divider
  final Color borderFocused; // light #6D3FD4  | dark #9D71F0  — keyboard/accessibility focus rings
  final Color borderError; // light #E25448  | dark #E25448  — error-colored border & divider

  // ── Added borders ─────────────────────────────────────────────────────────
  final Color borderInner; // light #EDE8FF  | dark #1E1E30  — inner dividers within card components
  final Color borderCard; // light #E8E2FF  | dark #22223A  — card-specific outer borders
  final Color borderBrandMuted; // light #DDD8F5  | dark #6B21A8  — muted brand borders (avatar rings, icon outlines)

  // ─── Global ───────────────────────────────────────────────────────────────
  final Color white; // #FFFFFF
  final Color black; // #000000
  final Color brand; // light #6D3FD4  | dark #9D71F0
  final Color secondary; // light #EC4899  | dark #EC4899

  const AppColorScheme({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.surfaceDeep,
    required this.surfaceAvatar,
    required this.surfaceDestructive,
    required this.surfaceInput,
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
    required this.contentSubtle,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderBrand,
    required this.borderFocused,
    required this.borderError,
    required this.borderInner,
    required this.borderCard,
    required this.borderBrandMuted,
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
      // ── Backgrounds ───────────────────────────────────────────────────────
      backgroundPrimary: AppColors.white, // #FFFFFF — pure white canvas
      backgroundSecondary: AppColors.neutral50, // #F5F3FF — lavender-tinted page bg
      backgroundTertiary: AppColors.neutral100, // #EDE8FF — subtle section divider bg
      // ── Surfaces ──────────────────────────────────────────────────────────
      surfacePrimary: AppColors.white, // #FFFFFF — cards & sheets
      surfaceSecondary: AppColors.neutral50, // #F5F3FF — elevated surface
      surfaceTertiary: AppColors.neutral100, // #EDE8FF — nested surface
      // ── Added surfaces ────────────────────────────────────────────────────
      surfaceDeep: AppColors.white, // #FFFFFF — same as primary; no extra depth in light
      surfaceAvatar: AppColors.brand50, // #F5F0FF — lightest purple tint behind avatar icons
      surfaceDestructive: AppColors.error50, // #FFF0F0 — danger zone / delete area bg
      surfaceInput: AppColors.lightSurfaceInput, // #FAF8FF — text input / textarea background
      // ── Overlay ───────────────────────────────────────────────────────────
      overlay: AppColors.brand700, // #1A1A2E — dark purple scrim
      // ── Content ───────────────────────────────────────────────────────────
      contentPrimary: AppColors.neutral900, // #3D3060 — dark purple body text
      contentSecondary: AppColors.neutral500, // #8878AA — username / secondary text
      contentTertiary: AppColors.neutral400, // #B0A8CC — muted / placeholder text
      contentDisabled: AppColors.neutral300, // #C0B8D8 — non-interactive text
      contentBrand: AppColors.brand500, // #6D3FD4 — brand purple
      contentError: AppColors.error500, // #E25448 — rage red
      contentSuccess: AppColors.success500, // #17B26A — success green
      contentWarning: AppColors.warning500, // #F97316 — rant orange
      contentInfo: AppColors.secondary500, // #EC4899 — love pink
      // ── Added content ─────────────────────────────────────────────────────
      contentSubtle: AppColors.lightContentSubtle, // #A09AB8 — status bar / very faint text
      // ── Borders ───────────────────────────────────────────────────────────
      borderPrimary: AppColors.neutral200, // #E8E4F0 — standard card borders
      borderSecondary: AppColors.neutral100, // #EDE8FF — light separators
      borderBrand: AppColors.brand500, // #6D3FD4 — brand border
      borderFocused: AppColors.brand500, // #6D3FD4 — focus ring
      borderError: AppColors.error500, // #E25448 — error border
      // ── Added borders ─────────────────────────────────────────────────────
      borderInner: AppColors.neutral100, // #EDE8FF — inner dividers within cards
      borderCard: AppColors.brand100, // #E8E2FF — card-specific outer border
      borderBrandMuted: AppColors.lightBorderMuted, // #DDD8F5 — muted border / phone frame
      // ── Global ────────────────────────────────────────────────────────────
      white: AppColors.white, // #FFFFFF
      black: AppColors.black, // #000000
      brand: AppColors.brand500, // #6D3FD4
      secondary: AppColors.secondary500, // #EC4899
    );
  }

  factory AppColorScheme.dark() {
    return const AppColorScheme(
      // ── Backgrounds ───────────────────────────────────────────────────────
      backgroundPrimary: AppColors.brand900, // #0B0B14 — deepest app background
      backgroundSecondary: AppColors.brand800, // #111120 — card & feed background
      backgroundTertiary: AppColors.brand700, // #1A1A2E — borders used as bg layer
      // ── Surfaces ──────────────────────────────────────────────────────────
      surfacePrimary: AppColors.brand800, // #111120 — primary card surface
      surfaceSecondary: AppColors.brand700, // #1A1A2E — elevated surface / bottom nav
      surfaceTertiary: AppColors.neutral800, // #25253A — subtle border / input bg
      // ── Added surfaces ────────────────────────────────────────────────────
      surfaceDeep: AppColors.darkSurfaceDeep, // #0D0D1C — deep feed / nested card bg
      surfaceAvatar: AppColors.darkSurfaceBrand, // #13102A — purple-tinted avatar icon bg
      surfaceDestructive: AppColors.darkSurfaceDanger, // #1A0C0C — danger zone / delete area bg
      surfaceInput: AppColors.brand800, // #111120 — same as card surface; dark inputs blend in
      // ── Overlay ───────────────────────────────────────────────────────────
      overlay: AppColors.brand900, // #0B0B14 — full-screen dark scrim
      // ── Content ───────────────────────────────────────────────────────────
      contentPrimary: AppColors.neutral300, // #C0B8D8 — primary body text (light on dark)
      contentSecondary: AppColors.neutral600, // #7070A0 — username / secondary text
      contentTertiary: AppColors.neutral700, // #46466A — muted / timestamp text
      contentDisabled: AppColors.neutral800, // #25253A — non-interactive elements
      contentBrand: AppColors.brand300, // #9D71F0 — brand purple on dark
      contentError: AppColors.error500, // #E25448 — rage red
      contentSuccess: AppColors.success500, // #17B26A — success green
      contentWarning: AppColors.warning500, // #F97316 — rant orange
      contentInfo: AppColors.secondary500, // #EC4899 — love pink
      // ── Added content ─────────────────────────────────────────────────────
      contentSubtle: AppColors.darkContentSubtle, // #35354E — faint text: timestamps, captions
      // note: status bar labels (#3D3D5C → AppColors.darkContentMuted) sit one step
      //       below contentSubtle and can be applied directly where needed.

      // ── Borders ───────────────────────────────────────────────────────────
      borderPrimary: AppColors.neutral800, // #25253A — standard dark borders
      borderSecondary: AppColors.brand700, // #1A1A2E — subtle inner separators
      borderBrand: AppColors.brand300, // #9D71F0 — brand border on dark
      borderFocused: AppColors.brand300, // #9D71F0 — focus ring on dark
      borderError: AppColors.error500, // #E25448 — error border
      // ── Added borders ─────────────────────────────────────────────────────
      borderInner: AppColors.darkBorderInner, // #1E1E30 — inner dividers within cards
      borderCard: AppColors.darkBorderCard, // #22223A — card outer border
      borderBrandMuted: AppColors.darkBorderBrandMuted, // #6B21A8 — muted brand borders (avatar rings)
      // ── Global ────────────────────────────────────────────────────────────
      white: AppColors.white, // #FFFFFF
      black: AppColors.black, // #000000
      brand: AppColors.brand300, // #9D71F0
      secondary: AppColors.secondary500, // #EC4899
    );
  }
}
