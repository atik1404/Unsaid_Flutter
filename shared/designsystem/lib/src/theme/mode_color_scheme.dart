import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';

final class ModeColorScheme extends ThemeExtension<ModeColorScheme> {
  final ModeColor love;
  final ModeColor angry;
  final ModeColor happy;
  final ModeColor sad;
  final ModeColor lonely;
  final ModeColor excited;
  final ModeColor dark;

  const ModeColorScheme({
    required this.love,
    required this.angry,
    required this.happy,
    required this.sad,
    required this.lonely,
    required this.excited,
    required this.dark,
  });

  @override
  ThemeExtension<ModeColorScheme> copyWith() => this;

  @override
  ThemeExtension<ModeColorScheme> lerp(
    covariant ThemeExtension<ModeColorScheme>? other,
    double t,
  ) => this;

  factory ModeColorScheme.light() {
    return const ModeColorScheme(
      love: ModeColor(
        backgroundColor: AppColors.secondary100,
        textColor: AppColors.secondary500,
        borderColor: AppColors.secondary500,
      ),
      angry: ModeColor(
        backgroundColor: AppColors.warning100,
        textColor: AppColors.warning500,
        borderColor: AppColors.warning500,
      ),
      happy: ModeColor(
        backgroundColor: AppColors.success100,
        textColor: AppColors.success500,
        borderColor: AppColors.success500,
      ),
      sad: ModeColor(
        backgroundColor: AppColors.error100,
        textColor: AppColors.error500,
        borderColor: AppColors.error500,
      ),
      lonely: ModeColor(
        backgroundColor: AppColors.warning50,
        textColor: AppColors.warning800,
        borderColor: AppColors.warning800,
      ),
      excited: ModeColor(
        backgroundColor: AppColors.brand100,
        textColor: AppColors.brand500,
        borderColor: AppColors.brand500,
      ),
      dark: ModeColor(
        backgroundColor: AppColors.neutral100,
        textColor: AppColors.neutral500,
        borderColor: AppColors.neutral500,
      ),
    );
  }

  factory ModeColorScheme.dark() => ModeColorScheme.light();
}

final class ModeColor {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const ModeColor({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}
