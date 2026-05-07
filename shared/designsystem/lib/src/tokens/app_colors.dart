import 'package:flutter/material.dart';

final class AppColors {
  const AppColors._();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  // Neutral — purple-tinted gray scale
  // 50–200: light backgrounds & borders (light theme)
  // 300–500: text hierarchy (light theme) / muted text (dark theme)
  // 600–900: text & borders (dark theme)
  static const neutral50 = Color(0xFFF5F3FF); // light theme app background
  static const neutral100 = Color(0xFFEDE8FF); // light theme dividers
  static const neutral200 = Color(0xFFE8E4F0); // light theme card borders
  static const neutral300 = Color(0xFFC0B8D8); // light theme disabled / dark theme body text
  static const neutral400 = Color(0xFFB0A8CC); // light theme muted text
  static const neutral500 = Color(0xFF8878AA); // light theme secondary text
  static const neutral600 = Color(0xFF7070A0); // dark theme username text
  static const neutral700 = Color(0xFF46466A); // dark theme muted text
  static const neutral800 = Color(0xFF25253A); // dark theme subtle borders
  static const neutral900 = Color(0xFF3D3060); // light theme primary body text

  // Brand — VOID purple
  // 50–200: light tints & avatar backgrounds (light theme)
  // 300–400: primary accent (dark theme = 300, light theme = 500)
  // 700–900: dark theme backgrounds (deepest = 900)
  static const brand50 = Color(0xFFF5F0FF); // lightest purple tint
  static const brand100 = Color(0xFFE8E2FF); // light card borders
  static const brand200 = Color(0xFFC4A8F0); // avatar borders (light theme)
  static const brand300 = Color(0xFF9D71F0); // primary accent — dark theme
  static const brand400 = Color(0xFF8A50E0); // mid-range purple
  static const brand500 = Color(0xFF6D3FD4); // primary accent — light theme
  static const brand600 = Color(0xFF5B21B6); // dark theme purple borders
  static const brand700 = Color(0xFF1A1A2E); // dark theme card borders / overlay
  static const brand800 = Color(0xFF111120); // dark theme card background
  static const brand900 = Color(0xFF0B0B14); // dark theme app background

  // Secondary — Love pink (#EC4899)
  static const secondary50 = Color(0xFFFFF0F8);
  static const secondary100 = Color(0xFFFFD6EE);
  static const secondary200 = Color(0xFFF0A8CC);
  static const secondary300 = Color(0xFFF06CB8);
  static const secondary400 = Color(0xFFF050A5);
  static const secondary500 = Color(0xFFEC4899); // love / info accent
  static const secondary600 = Color(0xFFD43585);
  static const secondary700 = Color(0xFFB82270);
  static const secondary800 = Color(0xFF8A1455);
  static const secondary900 = Color(0xFF5C0A38);

  // Error — Rage red (#E25448)
  static const error50 = Color(0xFFFFF0F0);
  static const error100 = Color(0xFFFFD9D6);
  static const error200 = Color(0xFFFFADA8);
  static const error300 = Color(0xFFFF8880);
  static const error400 = Color(0xFFEE6A5E);
  static const error500 = Color(0xFFE25448); // rage / error accent
  static const error600 = Color(0xFFC43C32);
  static const error700 = Color(0xFFA52820);
  static const error800 = Color(0xFF851810);
  static const error900 = Color(0xFF5C0C08);

  // Warning — Rant orange (#F97316)
  static const warning50 = Color(0xFFFFF8F0);
  static const warning100 = Color(0xFFFEEBD8);
  static const warning200 = Color(0xFFFED7B0);
  static const warning300 = Color(0xFFFDC088);
  static const warning400 = Color(0xFFFCA85A);
  static const warning500 = Color(0xFFF97316); // rant / warning accent
  static const warning600 = Color(0xFFD95D08);
  static const warning700 = Color(0xFFB84A04);
  static const warning800 = Color(0xFF943A02);
  static const warning900 = Color(0xFF6B2801);

  // Success — green (complementary, unchanged in spirit)
  static const success50 = Color(0xFFECFDF3);
  static const success100 = Color(0xFFDCFAE6);
  static const success200 = Color(0xFFABEFC6);
  static const success300 = Color(0xFF75E0A7);
  static const success400 = Color(0xFF47CD89);
  static const success500 = Color(0xFF17B26A);
  static const success600 = Color(0xFF06C167);
  static const success700 = Color(0xFF079455);
  static const success800 = Color(0xFF085D3A);
  static const success900 = Color(0xFF074D31);
}
