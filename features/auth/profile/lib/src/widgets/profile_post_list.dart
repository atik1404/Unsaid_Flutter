import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:profile/src/state/profile_post_model.dart';
import 'package:profile/src/widgets/profile_post_card.dart';

/// Displays a section heading ("My Posts") followed by the user's own posts.
///
/// Shows an empty-state message when [posts] is empty.
class ProfilePostList extends StatelessWidget {
  /// The list of posts authored by the profile owner.
  final List<ProfilePostModel> posts;

  const ProfilePostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        AppText.titleSmall(
          context.l10n.profile_section_posts,
          textWeight: AppTextWeight.bold,
        ),
        SizedBox(height: AppSpacing.s12.h),

        // Post list or empty state
        if (posts.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.s12.h),
            itemBuilder: (context, index) =>
                ProfilePostCard(post: posts[index]),
          ),
      ],
    );
  }

  /// Renders a centred message when the user has no posts yet.
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s32.h),
        child: AppText.bodySmall(
          context.l10n.profile_no_posts,
          color: context.colorScheme.contentSecondary,
          textWeight: AppTextWeight.medium,
        ),
      ),
    );
  }
}
