import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryList extends StatelessWidget {
  final category = [
    "ALL",
    "RAGE",
    "LOVE",
    "RANT",
    "DARK",
  ];

  CategoryList({super.key});

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
    String category,
  ) {
    final isCategorySelected = category == "ALL";

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.s8.w),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s8.w,
        ),
        decoration: BoxDecoration(
          color: isCategorySelected ? context.colorScheme.borderCard : context.colorScheme.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.rFull),
          border: Border.all(
            color: isCategorySelected ? context.colorScheme.borderPrimary : context.colorScheme.borderSecondary,
          ),
        ),
        child: Center(
          child: InlineIconLabel(
            text: AppText.captionSmall(
              category,
              textAlign: TextAlign.center,
              color: isCategorySelected ? context.colorScheme.contentPrimary : context.colorScheme.contentSecondary,
            ),
            leadingWidget: AppIcon(
              Icon(
                CupertinoIcons.heart,
                size: IconSizes.indicator,
                color: context.colorScheme.contentTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
