import 'package:designsystem/src/tokens/app_typography_tokens.dart';
import 'package:flutter/material.dart';

/*
Display → splash screens, onboarding hero text, marketing
Headline → screen titles, section headers
Title → card titles, dialog titles, app bar
Body → paragraphs, descriptions, list item text
Label → buttons, chips, tabs, form labels
Caption → timestamps, helper text, metadata
Overline → category tags, all-caps section markers
*/

@immutable
class AppTextStyles {
  const AppTextStyles._();
  // ============================================================
  // DISPLAY — Largest text, reserved for short, hero moments
  // ============================================================
  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFontFamily.display,
    fontSize: AppFontSize.s48,
    fontWeight: AppFontWeight.bold,
    letterSpacing: AppLetterSpacing.tighter,
    height: AppLineHeight.tight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFontFamily.display,
    fontSize: AppFontSize.s40,
    fontWeight: AppFontWeight.bold,
    letterSpacing: AppLetterSpacing.tighter,
    height: AppLineHeight.tight,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppFontFamily.display,
    fontSize: AppFontSize.s32,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: AppLetterSpacing.tight,
    height: AppLineHeight.tight,
  );

  // ============================================================
  // HEADLINE — High-emphasis text for short, important content
  // ============================================================
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s28,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: AppLetterSpacing.tight,
    height: AppLineHeight.snug,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s24,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: AppLetterSpacing.normal,
    height: AppLineHeight.snug,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s20,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: AppLetterSpacing.normal,
    height: AppLineHeight.snug,
  );

  // ============================================================
  // TITLE — Medium-emphasis text, shorter than headlines
  // ============================================================
  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s18,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: AppLetterSpacing.normal,
    height: AppLineHeight.normal,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s16,
    fontWeight: AppFontWeight.medium,
    letterSpacing: AppLetterSpacing.normal,
    height: AppLineHeight.normal,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s14,
    fontWeight: AppFontWeight.medium,
    letterSpacing: AppLetterSpacing.wide,
    height: AppLineHeight.normal,
  );

  // ============================================================
  // BODY — Longer-form reading text
  // ============================================================
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s16,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.normal,
    height: AppLineHeight.relaxed,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s14,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.normal,
    height: AppLineHeight.relaxed,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s12,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.wider,
    height: AppLineHeight.relaxed,
  );

  // ============================================================
  // LABEL — Call-to-action text, buttons, chips, tabs
  // ============================================================
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s14,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: AppLetterSpacing.wide,
    height: AppLineHeight.normal,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s12,
    fontWeight: AppFontWeight.medium,
    letterSpacing: AppLetterSpacing.wide,
    height: AppLineHeight.normal,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s11,
    fontWeight: AppFontWeight.medium,
    letterSpacing: AppLetterSpacing.wide,
    height: AppLineHeight.normal,
  );

  // ============================================================
  // CAPTION & OVERLINE — Supporting / metadata text
  // ============================================================
  static const TextStyle captionLarge = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s11,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.wider,
    height: AppLineHeight.normal,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s10,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.wider,
    height: AppLineHeight.normal,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppFontSize.s9,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.wider,
    height: AppLineHeight.normal,
  );
}
