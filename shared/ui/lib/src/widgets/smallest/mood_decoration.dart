import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

final class MoodDecoration {
  static (Color bg, Color text, Color stroke) getColor(
    BuildContext context, {
    required String tag,
  }) {
    final colors = context.modeColors;
    final mood = MoodTypeX.fromString(tag) ?? MoodType.neutral;

    return switch (mood) {
      MoodType.love => (
        colors.love.backgroundColor,
        colors.love.textColor,
        colors.love.backgroundColor,
      ),
      MoodType.angry => (
        colors.angry.backgroundColor,
        colors.angry.textColor,
        colors.angry.backgroundColor,
      ),
      MoodType.happy => (
        colors.happy.backgroundColor,
        colors.happy.textColor,
        colors.happy.backgroundColor,
      ),
      MoodType.sad => (
        colors.sad.backgroundColor,
        colors.sad.textColor,
        colors.sad.backgroundColor,
      ),
      MoodType.lonely => (
        colors.lonely.backgroundColor,
        colors.lonely.textColor,
        colors.lonely.backgroundColor,
      ),
      MoodType.excited => (
        colors.excited.backgroundColor,
        colors.excited.textColor,
        colors.excited.backgroundColor,
      ),
      MoodType.dark => (
        colors.dark.backgroundColor,
        colors.dark.textColor,
        colors.dark.backgroundColor,
      ),
      MoodType.neutral => (
        colors.neutral.backgroundColor,
        colors.neutral.textColor,
        colors.neutral.backgroundColor,
      ),
      MoodType.all => (
        context.appColors.backgroundPrimary,
        context.appColors.contentPrimary,
        context.appColors.backgroundPrimary,
      ),
      MoodType.confused => (
        colors.confused.backgroundColor,
        colors.confused.textColor,
        colors.confused.backgroundColor,
      ),
    };
  }

  static String getMoodIcon(String mood) {
    final moodType = MoodTypeX.fromString(mood);
    switch (moodType) {
      case MoodType.neutral:
        return AppDrawables.icNeutral;
      case MoodType.angry:
        return AppDrawables.icAngry;
      case MoodType.love:
        return AppDrawables.icLove;
      case MoodType.happy:
        return AppDrawables.icHappy;
      case MoodType.sad:
        return AppDrawables.icSad;
      case MoodType.lonely:
        return AppDrawables.icLonely;
      case MoodType.excited:
        return AppDrawables.icExcited;
      case MoodType.confused:
        return AppDrawables.icConfused;
      case MoodType.dark:
        return AppDrawables.icDark;
      default:
        return ""; // Return an empty string or a default icon path if mood is not recognized
    }
  }
}
