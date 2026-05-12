import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:common/common.dart';

class MoodPillItem extends StatelessWidget {
  final String mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodPillItem({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMoodPillItem(context);
  }

  Widget _buildMoodPillItem(
    BuildContext context,
  ) {
    final effectiveIcon = mood == "ALL" ? null : _getMoodIcon(mood);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.s8.w),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s8.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.appColors.borderCard : context.appColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.rFull),
          border: Border.all(
            color: isSelected ? context.appColors.borderPrimary : context.appColors.borderSecondary,
          ),
        ),
        child: Center(
          child: InlineIconLabel(
            text: AppText.captionSmall(
              mood.toUpperCase(),
              textAlign: TextAlign.center,
              color: isSelected ? context.appColors.contentPrimary : context.appColors.contentSecondary,
            ),
            leadingWidget: (effectiveIcon != null && effectiveIcon.isNotEmpty)
                ? AppImage.asset(
                    effectiveIcon,
                    width: IconSizes.inline,
                    height: IconSizes.inline,
                    color: isSelected ? context.appColors.contentPrimary : context.appColors.contentSecondary,
                  )
                : null,
            horizontalGap: AppSpacing.s4.w,
          ),
        ),
      ),
    );
  }

  String _getMoodIcon(String mood) {
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
