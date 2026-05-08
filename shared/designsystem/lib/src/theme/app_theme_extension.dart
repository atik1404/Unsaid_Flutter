import 'package:designsystem/src/components/button/button.dart';
import 'package:designsystem/src/components/card/card.dart';
import 'package:designsystem/src/components/inputfiled/inputfield.dart';
import 'package:designsystem/src/components/scaffold/app_scaffold_theme.dart';
import 'package:designsystem/src/components/tag/app_tag_theme.dart';
import 'package:designsystem/src/components/topbar/app_topbar_theme.dart';
import 'package:designsystem/src/components/typography/typography.dart';
import 'package:designsystem/src/theme/app_color_scheme.dart';
import 'package:designsystem/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

extension AppThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppTypographyTheme get typography => theme.extension<AppTheme>()!.typographyTheme;

  AppTagTheme get tagTheme => theme.extension<AppTheme>()!.tagTheme;

  AppColorScheme get colorScheme => theme.extension<AppTheme>()!.colorSchemeTheme;

  AppInputFieldTheme get inputTheme => theme.extension<AppTheme>()!.inputFieldTheme;

  AppButtonTheme get buttonTheme => theme.extension<AppTheme>()!.buttonTheme;

  AppCardTheme get cardTheme => theme.extension<AppTheme>()!.cardTheme;

  AppTopBarTheme get topBarTheme => theme.extension<AppTheme>()!.topBarTheme;

  AppScaffoldTheme get scaffoldTheme => theme.extension<AppTheme>()!.scaffoldTheme;
}
