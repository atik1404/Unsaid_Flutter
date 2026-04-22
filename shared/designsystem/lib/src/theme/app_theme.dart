import 'package:designsystem/src/components/button/button.dart';
import 'package:designsystem/src/components/card/card.dart';
import 'package:designsystem/src/components/inputfiled/inputfield.dart';
import 'package:designsystem/src/components/scaffold/app_scaffold_theme.dart';
import 'package:designsystem/src/components/tag/app_tag_theme.dart';
import 'package:designsystem/src/components/topbar/app_topbar_theme.dart';
import 'package:designsystem/src/components/typography/typography.dart';
import 'package:designsystem/src/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

final class AppTheme extends ThemeExtension<AppTheme> {
  final AppTypographyTheme typographyTheme;
  final AppTagTheme tagTheme;
  final AppColorScheme colorSchemeTheme;
  final AppInputFieldTheme inputFieldTheme;
  final AppButtonTheme buttonTheme;
  final AppCardTheme cardTheme;
  final AppTopBarTheme topBarTheme;
  final AppScaffoldTheme scaffoldTheme;

  const AppTheme._({
    required this.typographyTheme,
    required this.tagTheme,
    required this.colorSchemeTheme,
    required this.inputFieldTheme,
    required this.buttonTheme,
    required this.cardTheme,
    required this.topBarTheme,
    required this.scaffoldTheme,
  });

  @override
  ThemeExtension<AppTheme> copyWith({
    AppTypographyTheme? typographyTheme,
    AppTagTheme? tagTheme,
    AppColorScheme? colorSchemeTheme,
    AppInputFieldTheme? inputFieldTheme,
    AppButtonTheme? buttonTheme,
    AppCardTheme? cardTheme,
    AppTopBarTheme? topBarTheme,
    AppScaffoldTheme? scaffoldTheme,
  }) {
    return AppTheme._(
      typographyTheme: this.typographyTheme,
      tagTheme: tagTheme ?? this.tagTheme,
      colorSchemeTheme: colorSchemeTheme ?? this.colorSchemeTheme,
      inputFieldTheme: inputFieldTheme ?? this.inputFieldTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      topBarTheme: topBarTheme ?? this.topBarTheme,
      scaffoldTheme: scaffoldTheme ?? this.scaffoldTheme,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(
    covariant ThemeExtension<AppTheme>? other,
    double t,
  ) {
    if (other is! AppTheme) return this;

    return other;
  }

  factory AppTheme.light() {
    return AppTheme._(
      typographyTheme: AppTypographyTheme.standard(),
      tagTheme: AppTagTheme.light(),
      colorSchemeTheme: AppColorScheme.light(),
      inputFieldTheme: AppInputFieldTheme.light(),
      buttonTheme: AppButtonTheme.light(),
      cardTheme: AppCardTheme.light(),
      topBarTheme: AppTopBarTheme.light(),
      scaffoldTheme: AppScaffoldTheme.light(),
    );
  }

  factory AppTheme.dark() => AppTheme.light();
}
