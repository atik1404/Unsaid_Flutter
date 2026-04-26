import 'package:designsystem/designsystem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home/src/state/post_model.dart';
import 'package:jiffy/jiffy.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.borderPrimary,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText.titleSmall(
                  post.title,
                  textWeight: AppTextWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12.w,
                  vertical: AppSpacing.s4.h,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.backgroundBadge,
                  borderRadius: BorderRadius.circular(AppSpacing.s8.r),
                ),
                child: AppText.captionSmall(
                  post.tag,
                  color: context.colorScheme.contentBrand,
                  textWeight: AppTextWeight.bold,
                ),
              ),
            ],
          ),
          AppText.labelSmall(
            Jiffy.parseFromDateTime(post.dateTime).yMMMMEEEEd,
            color: context.colorScheme.contentSecondary,
            textWeight: AppTextWeight.light,
          ),
          SizedBox(height: AppSpacing.s8.h),
          AppText.bodySmall(
            post.description,
            color: context.colorScheme.contentPrimary,
            textWeight: AppTextWeight.medium,
          ),
          SizedBox(height: AppSpacing.s12.h),
        ],
      ),
    );
  }
}
