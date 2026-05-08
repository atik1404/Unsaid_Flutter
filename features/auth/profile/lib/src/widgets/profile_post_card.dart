import 'package:designsystem/designsystem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:profile/src/state/profile_post_model.dart';

/// A compact card for a single post on the profile's "My Posts" list.
///
/// Mirrors the visual style of the home feed's [PostCard] but is
/// owned by the profile package to keep feature coupling minimal.
class ProfilePostCard extends StatelessWidget {
  /// The post data to display.
  final ProfilePostModel post;

  const ProfilePostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.borderPrimary,
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                child: AppText.titleSmall(
                  post.title,
                  textWeight: AppTextWeight.bold,
                ),
              ),
              _buildTagBadge(context),
            ],
          ),

          // Date
          AppText.labelSmall(
            Jiffy.parseFromDateTime(post.dateTime).yMMMMEEEEd,
            color: context.appColors.contentSecondary,
            textWeight: AppTextWeight.light,
          ),
          SizedBox(height: AppSpacing.s8.h),

          // Description
          AppText.bodySmall(
            post.description,
            color: context.appColors.contentPrimary,
            textWeight: AppTextWeight.medium,
          ),
        ],
      ),
    );
  }

  /// Renders the coloured tag badge for this post.
  Widget _buildTagBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s12.w,
        vertical: AppSpacing.s4.h,
      ),
      decoration: BoxDecoration(
        color: context.appColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.s8.r),
      ),
      child: AppText.captionSmall(
        post.tag,
        color: context.appColors.contentBrand,
        textWeight: AppTextWeight.bold,
      ),
    );
  }
}
