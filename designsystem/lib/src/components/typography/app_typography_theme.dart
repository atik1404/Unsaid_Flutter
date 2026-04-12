import 'package:designsystem/src/components/typography/app_text_style.dart';
import 'package:designsystem/src/components/typography/app_typography_intent.dart';
import 'package:flutter/material.dart';

class AppTypographyTheme extends ThemeExtension<AppTypographyTheme> {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;

  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  final TextStyle captionLarge;
  final TextStyle captionMedium;
  final TextStyle captionSmall;

  AppTypographyTheme._({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.captionLarge,
    required this.captionMedium,
    required this.captionSmall,
  });

  factory AppTypographyTheme.standard() {
    return AppTypographyTheme._(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
      captionLarge: AppTextStyles.captionLarge,
      captionMedium: AppTextStyles.captionMedium,
      captionSmall: AppTextStyles.captionSmall,
    );
  }

  TextStyle byIntent(AppTypographyIntent intent) {
    return switch (intent) {
      AppTypographyIntent.displayLarge => displayLarge,
      AppTypographyIntent.displayMedium => displayMedium,
      AppTypographyIntent.displaySmall => displaySmall,
      AppTypographyIntent.headlineLarge => headlineLarge,
      AppTypographyIntent.headlineMedium => headlineMedium,
      AppTypographyIntent.headlineSmall => headlineSmall,
      AppTypographyIntent.titleLarge => titleLarge,
      AppTypographyIntent.titleMedium => titleMedium,
      AppTypographyIntent.titleSmall => titleSmall,
      AppTypographyIntent.bodyLarge => bodyLarge,
      AppTypographyIntent.bodyMedium => bodyMedium,
      AppTypographyIntent.bodySmall => bodySmall,
      AppTypographyIntent.labelLarge => labelLarge,
      AppTypographyIntent.labelMedium => labelMedium,
      AppTypographyIntent.labelSmall => labelSmall,
      AppTypographyIntent.captionLarge => captionLarge,
      AppTypographyIntent.captionMedium => captionMedium,
      AppTypographyIntent.captionSmall => captionSmall,
    };
  }

  @override
  AppTypographyTheme copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? captionLarge,
    TextStyle? captionMedium,
    TextStyle? captionSmall,
  }) {
    return AppTypographyTheme._(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      captionLarge: captionLarge ?? this.captionLarge,
      captionMedium: captionMedium ?? this.captionMedium,
      captionSmall: captionSmall ?? this.captionSmall,
    );
  }

  @override
  AppTypographyTheme lerp(ThemeExtension<AppTypographyTheme>? other, double t) {
    if (other is! AppTypographyTheme) return this;
    return AppTypographyTheme._(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      captionLarge: TextStyle.lerp(captionLarge, other.captionLarge, t)!,
      captionMedium: TextStyle.lerp(captionMedium, other.captionMedium, t)!,
      captionSmall: TextStyle.lerp(captionSmall, other.captionSmall, t)!,
    );
  }
}
