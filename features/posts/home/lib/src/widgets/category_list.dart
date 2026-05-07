import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.s32.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(width: AppSpacing.s8.w),
        itemBuilder: (context, index) {
          return _buildCategoryItem(context, 'Category ${index + 1}');
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12.w, vertical: AppSpacing.s4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.rFull),
        border: Border.all(color: context.colorScheme.borderPrimary),
      ),
      child: AppText.captionMedium(
        category,
        color: context.colorScheme.contentTertiary,
        textAlign: TextAlign.center,
      ),
    );
  }
}
