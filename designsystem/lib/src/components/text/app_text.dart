// ignore_for_file: unused_element_parameter, unused_element
import 'package:designsystem/src/components/text/app_text_weight.dart';
import 'package:designsystem/src/components/typography/app_typography_intent.dart';
import 'package:designsystem/src/components/typography/app_typography_theme.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  final AppTypographyIntent intent;
  final AppTextWeight? textWeight;

  const AppText._(
    this.text, {
    super.key,
    required this.intent,
    this.color,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
    this.textWeight,
  });

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<AppTypographyTheme>()!;
    final intentStyle = typography.byIntent(intent);
    final defaultStyle = DefaultTextStyle.of(context).style;

    // Start from the ambient DefaultTextStyle (so parent colors propagate),
    // then layer the variant's typographic properties on top — but DON'T
    // overwrite color unless our variant explicitly defines one AND no
    // parent has provided one.
    final merged = defaultStyle.merge(
      intentStyle.copyWith(
        fontWeight: textWeight?.fontWeight ?? intentStyle.fontWeight,
      ),
    );

    // Explicit color param always wins.
    final finalStyle = color != null ? merged.copyWith(color: color) : merged;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      style: finalStyle,
    );
  }

  const AppText.displayLarge(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.displayLarge;

  const AppText.displayMedium(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.displayMedium;

  const AppText.displaySmall(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.displaySmall;

  const AppText.headlineLarge(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.headlineLarge;

  const AppText.headlineMedium(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.headlineMedium;

  const AppText.headlineSmall(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.headlineSmall;

  const AppText.titleLarge(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.titleLarge;

  const AppText.titleMedium(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.titleMedium;

  const AppText.titleSmall(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.titleSmall;

  const AppText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.bodyLarge;

  const AppText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.bodyMedium;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.bodySmall;

  const AppText.labelLarge(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.labelLarge;

  const AppText.labelMedium(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.labelMedium;

  const AppText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.labelSmall;

  const AppText.captionLarge(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.captionLarge;

  const AppText.captionMedium(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.captionMedium;

  const AppText.captionSmall(
    this.text, {
    super.key,
    this.color,
    this.textWeight,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
  }) : intent = AppTypographyIntent.captionSmall;
}
