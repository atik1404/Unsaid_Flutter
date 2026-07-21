import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final effectiveIcon = mood == "ALL"
        ? null
        : MoodDecoration.getMoodIcon(mood);

    final contentColor = isSelected
        ? context.appColors.contentPrimary
        : context.appColors.contentSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.s8.w),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s8.w,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.borderCard
              : context.appColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.rFull),
          border: Border.all(
            color: isSelected
                ? context.appColors.borderPrimary
                : context.appColors.borderSecondary,
          ),
        ),
        child: Center(
          child: InlineIconLabel(
            text: AppText.captionSmall(
              mood.toUpperCase(),
              textAlign: TextAlign.center,
              color: contentColor,
            ),
            leadingWidget: (effectiveIcon != null && effectiveIcon.isNotEmpty)
                ? AppImage.asset(
                    effectiveIcon,
                    width: IconSizes.inline,
                    height: IconSizes.inline,
                    color: contentColor,
                  )
                : null,
            horizontalGap: AppSpacing.s4.w,
          ),
        ),
      ),
    );
  }
}
