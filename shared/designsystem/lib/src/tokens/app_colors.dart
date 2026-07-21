import 'package:flutter/material.dart';

final class AppColors {
  const AppColors._();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  // ─── Neutral — purple-tinted gray scale ───────────────────────────────────
  // 50–200 : light backgrounds & borders  (light theme)
  // 300–500: text hierarchy               (light theme) / muted text (dark theme)
  // 600–800: text & borders               (dark theme)
  // 900    : primary body text            (light theme)
  static const neutral50 = Color(
    0xFFF5F3FF,
  ); // #F5F3FF — light theme app background
  static const neutral100 = Color(0xFFEDE8FF); // #EDE8FF — light theme dividers
  static const neutral200 = Color(
    0xFFE8E4F0,
  ); // #E8E4F0 — light theme card borders
  static const neutral300 = Color(
    0xFFC0B8D8,
  ); // #C0B8D8 — light disabled / dark body text
  static const neutral400 = Color(
    0xFFB0A8CC,
  ); // #B0A8CC — light theme muted text
  static const neutral500 = Color(
    0xFF8878AA,
  ); // #8878AA — light theme secondary text
  static const neutral600 = Color(
    0xFF7070A0,
  ); // #7070A0 — dark theme username text
  static const neutral700 = Color(
    0xFF46466A,
  ); // #46466A — dark theme muted text
  static const neutral800 = Color(
    0xFF25253A,
  ); // #25253A — dark theme subtle borders
  static const neutral900 = Color(
    0xFF3D3060,
  ); // #3D3060 — light theme primary body text

  // ─── Brand — VOID purple ──────────────────────────────────────────────────
  // 50–200 : light tints & avatar backgrounds   (light theme)
  // 300    : primary accent                     (dark theme)
  // 500    : primary accent                     (light theme)
  // 600    : strong brand border                (dark theme)
  // 700–900: dark theme layered backgrounds
  static const brand50 = Color(
    0xFFF5F0FF,
  ); // #F5F0FF — lightest purple tint / avatar bg (light)
  static const brand100 = Color(
    0xFFE8E2FF,
  ); // #E8E2FF — light card borders / card-specific border
  static const brand200 = Color(
    0xFFC4A8F0,
  ); // #C4A8F0 — avatar borders (light theme)
  static const brand300 = Color(
    0xFF9D71F0,
  ); // #9D71F0 — primary accent (dark theme)
  static const brand400 = Color(0xFF8A50E0); // #8A50E0 — mid-range purple
  static const brand500 = Color(
    0xFF6D3FD4,
  ); // #6D3FD4 — primary accent (light theme)
  static const brand600 = Color(
    0xFF5B21B6,
  ); // #5B21B6 — strong brand border (dark theme)
  static const brand700 = Color(
    0xFF1A1A2E,
  ); // #1A1A2E — dark card borders / overlay base
  static const brand800 = Color(0xFF111120); // #111120 — dark card background
  static const brand900 = Color(0xFF0B0B14); // #0B0B14 — dark app background

  // ─── Secondary — Love pink ────────────────────────────────────────────────
  static const secondary50 = Color(0xFFFFF0F8); // #FFF0F8
  static const secondary100 = Color(0xFFFFD6EE); // #FFD6EE
  static const secondary200 = Color(0xFFF0A8CC); // #F0A8CC
  static const secondary300 = Color(0xFFF06CB8); // #F06CB8
  static const secondary400 = Color(0xFFF050A5); // #F050A5
  static const secondary500 = Color(0xFFEC4899); // #EC4899 — love / info accent
  static const secondary600 = Color(0xFFD43585); // #D43585
  static const secondary700 = Color(0xFFB82270); // #B82270
  static const secondary800 = Color(0xFF8A1455); // #8A1455
  static const secondary900 = Color(0xFF5C0A38); // #5C0A38

  // ─── Error — Rage red ─────────────────────────────────────────────────────
  static const error50 = Color(
    0xFFFFF0F0,
  ); // #FFF0F0 — rage / destructive surface (light)
  static const error100 = Color(0xFFFFD9D6); // #FFD9D6
  static const error200 = Color(0xFFFFADA8); // #FFADA8
  static const error300 = Color(0xFFFF8880); // #FF8880
  static const error400 = Color(0xFFEE6A5E); // #EE6A5E
  static const error500 = Color(0xFFE25448); // #E25448 — rage / error accent
  static const error600 = Color(0xFFC43C32); // #C43C32
  static const error700 = Color(0xFFA52820); // #A52820
  static const error800 = Color(0xFF851810); // #851810
  static const error900 = Color(0xFF5C0C08); // #5C0C08

  // ─── Warning — Rant orange ────────────────────────────────────────────────
  static const warning50 = Color(0xFFFFF8F0); // #FFF8F0
  static const warning100 = Color(0xFFFEEBD8); // #FEEBD8
  static const warning200 = Color(0xFFFED7B0); // #FED7B0
  static const warning300 = Color(0xFFFDC088); // #FDC088
  static const warning400 = Color(0xFFFCA85A); // #FCA85A
  static const warning500 = Color(
    0xFFF97316,
  ); // #F97316 — rant / warning accent
  static const warning600 = Color(0xFFD95D08); // #D95D08
  static const warning700 = Color(0xFFB84A04); // #B84A04
  static const warning800 = Color(0xFF943A02); // #943A02
  static const warning900 = Color(0xFF6B2801); // #6B2801

  // ─── Success — Complementary green ───────────────────────────────────────
  static const success50 = Color(0xFFECFDF3); // #ECFDF3
  static const success100 = Color(0xFFDCFAE6); // #DCFAE6
  static const success200 = Color(0xFFABEFC6); // #ABEFC6
  static const success300 = Color(0xFF75E0A7); // #75E0A7
  static const success400 = Color(0xFF47CD89); // #47CD89
  static const success500 = Color(0xFF17B26A); // #17B26A — success accent
  static const success600 = Color(0xFF06C167); // #06C167
  static const success700 = Color(0xFF079455); // #079455
  static const success800 = Color(0xFF085D3A); // #085D3A
  static const success900 = Color(0xFF074D31); // #074D31

  static const blue50 = Color(0xFFE6EFFF);
  static const blue100 = Color(0xFFB2CEFF);
  static const blue200 = Color(0xFF8CB6FF);
  static const blue300 = Color(0xFF5895FF);
  static const blue400 = Color(0xFF3781FF);
  static const blue500 = Color(0xFF0561FF);
  static const blue600 = Color(0xFF0558E8);
  static const blue700 = Color(0xFF0445B5);
  static const blue800 = Color(0xFF03358C);
  static const blue900 = Color(0xFF02296B);

  // ─── Extended — Dark theme surfaces ───────────────────────────────────────
  // Colors used in the VOID dark UI that fall between the main brand scale steps.
  static const darkSurfaceDeep = Color(
    0xFF0D0D1C,
  ); // #0D0D1C — deep card / feed bg (darker than brand800)
  static const darkSurfaceBrand = Color(
    0xFF13102A,
  ); // #13102A — purple-tinted avatar icon bg
  static const darkSurfaceDanger = Color(
    0xFF1A0C0C,
  ); // #1A0C0C — danger zone / destructive area bg

  // ─── Extended — Dark theme borders ────────────────────────────────────────
  static const darkBorderInner = Color(
    0xFF1E1E30,
  ); // #1E1E30 — inner dividers within cards
  static const darkBorderCard = Color(
    0xFF22223A,
  ); // #22223A — card outer border
  static const darkBorderBrandMuted = Color(
    0xFF6B21A8,
  ); // #6B21A8 — muted brand border (avatar rings)

  // ─── Extended — Dark theme text ───────────────────────────────────────────
  static const darkContentSubtle = Color(
    0xFF35354E,
  ); // #35354E — faint text: timestamps, captions
  static const darkContentMuted = Color(
    0xFF3D3D5C,
  ); // #3D3D5C — very faint text: status bar labels

  // ─── Extended — Light theme surfaces & borders ────────────────────────────
  static const lightSurfaceInput = Color(
    0xFFFAF8FF,
  ); // #FAF8FF — input / textarea background
  static const lightBorderMuted = Color(
    0xFFDDD8F5,
  ); // #DDD8F5 — muted border / phone frame

  // ─── Extended — Light theme text ──────────────────────────────────────────
  static const lightContentSubtle = Color(
    0xFFA09AB8,
  ); // #A09AB8 — status bar / very faint text
}
