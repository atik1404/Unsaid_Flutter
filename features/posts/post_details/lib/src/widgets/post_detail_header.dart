import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localization/localization.dart';
import 'package:post_details/src/state/post_details_model.dart';

/// Displays the post title, tag badge, author, and publication date.
///
/// Used at the top of the Post Details screen as a visual summary.
class PostDetailHeader extends StatelessWidget {
  /// The post whose header information to display.
  final PostDetailsModel post;

  const PostDetailHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.s16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.borderPrimary,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with tag badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText.titleMedium(
                  post.title,
                  textWeight: AppTextWeight.bold,
                ),
              ),
              _buildTagBadge(context),
            ],
          ),
          SizedBox(height: AppSpacing.s12.h),

          // Author
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18.r,
                color: context.colorScheme.contentSecondary,
              ),
              SizedBox(width: AppSpacing.s4.w),
              AppText.bodySmall(
                '${context.l10n.post_details_posted_by} ${post.author}',
                color: context.colorScheme.contentSecondary,
                textWeight: AppTextWeight.medium,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.s4.h),

          // Date
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18.r,
                color: context.colorScheme.contentSecondary,
              ),
              SizedBox(width: AppSpacing.s4.w),
              AppText.bodySmall(
                '${context.l10n.post_details_posted_on} '
                '${Jiffy.parseFromDateTime(post.dateTime).yMMMMEEEEd}',
                color: context.colorScheme.contentSuccess,
                textWeight: AppTextWeight.medium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Renders the coloured tag badge.
  Widget _buildTagBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s12.w,
        vertical: AppSpacing.s4.h,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.s8.r),
      ),
      child: AppText.captionSmall(
        post.tag,
        color: context.colorScheme.contentBrand,
        textWeight: AppTextWeight.bold,
      ),
    );
  }
}
