import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:home/src/model/mood_model.dart';
import 'package:ui/ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoodList extends StatelessWidget {
  final category = moods;

  MoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s24.h,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: (context, index) {
          return _buildCategoryItem(context, category[index]);
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    MoodModel mood,
  ) {
    final isCategorySelected = mood.name == MoodType.all;

    final effectiveIcon = mood.name == MoodType.all ? null : mood.icon;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.s8.w),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s8.w,
        ),
        decoration: BoxDecoration(
          color: isCategorySelected ? context.appColors.borderCard : context.appColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.rFull),
          border: Border.all(
            color: isCategorySelected ? context.appColors.borderPrimary : context.appColors.borderSecondary,
          ),
        ),
        child: Center(
          child: InlineIconLabel(
            text: AppText.captionSmall(
              mood.name.name.toUpperCase(),
              textAlign: TextAlign.center,
              color: isCategorySelected ? context.appColors.contentPrimary : context.appColors.contentSecondary,
            ),
            leadingWidget: effectiveIcon != null
                ? AppImage.asset(
                    effectiveIcon,
                    width: IconSizes.inline,
                    height: IconSizes.inline,
                    color: isCategorySelected ? context.appColors.contentPrimary : context.appColors.contentSecondary,
                  )
                : null,
            horizontalGap: AppSpacing.s4.w,
          ),
        ),
      ),
    );
  }
}
