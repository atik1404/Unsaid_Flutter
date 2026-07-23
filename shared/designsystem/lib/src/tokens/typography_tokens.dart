import 'package:flutter/material.dart';

@immutable
class TypographyTokens {
  const TypographyTokens._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

@immutable
class AppFontSize {
  const AppFontSize._();
  static const double s48 = 48;
  static const double s40 = 40;
  static const double s32 = 32;
  static const double s28 = 28;
  static const double s24 = 24;
  static const double s20 = 20;
  static const double s18 = 18;
  static const double s16 = 16;
  static const double s14 = 14;
  static const double s12 = 12;
  static const double s11 = 11;
  static const double s10 = 10;
  static const double s9 = 9;
  static const double s8 = 8;
}

@immutable
class AppLetterSpacing {
  const AppLetterSpacing._();

  // display
  static const double tighter = -0.5;
  // large headings
  static const double tight = -0.25;
  // titles, body
  static const double normal = 0;
  // labels
  static const double wide = 0.15;
  // caption
  static const double wider = 0.4;
}

@immutable
class AppFontFamily {
  const AppFontFamily._();

  // Primary UI font — body, labels, most text.
  static const String primary = 'Inter';

  // Display font for hero/marketing text. Can be same as primary
  // if you don't have a dedicated display cut.
  static const String display = 'Inter';

  /// Monospace for code, receipts, transaction IDs, tickers.
  static const String mono = 'JetBrainsMono';
}

@immutable
class AppLineHeight {
  const AppLineHeight._();

  // display, large headings
  static const double tight = 1.15;
  // headings
  static const double snug = 1.25;
  // titles, labels
  static const double normal = 1.4;
  // body text
  static const double relaxed = 1.5;
}
