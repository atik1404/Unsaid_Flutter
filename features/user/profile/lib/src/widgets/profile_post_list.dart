import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:entity/entity.dart';

/// Displays a section heading ("My Posts") followed by the user's own posts.
///
/// Shows an empty-state message when [posts] is empty.
class ProfilePostList extends StatelessWidget {
  /// The list of posts authored by the profile owner.
  final List<PostEntity> posts;

  const ProfilePostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (posts.isNotEmpty) ...[
          // Section heading
          AppText.captionLarge(
            context.l10n.profile_section_confessions,
            color: context.appColors.contentTertiary,
          ),
          SizedBox(height: AppSpacing.s12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            separatorBuilder: (_, _) => SizedBox(height: AppSpacing.s12.h),
            itemBuilder: (context, index) => _ProfilePostCard(
              post: posts[index],
              onTap: () {},
            ),
          ),
        ] else
          _buildEmptyState(context),
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
          color: context.appColors.contentError,
          textWeight: AppTextWeight.medium,
        ),
      ),
    );
  }
}

class _ProfilePostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;

  const _ProfilePostCard({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getTagColor(post.mood, context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: AppSpacing.s2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          color: colors.$2,
        ),
        child: AppCard.rounded(
          variant: AppCardVariant.outline,
          cornerRadius: AppCardCornerRadius.lg,
          padding: EdgeInsets.all(AppSpacing.s12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostHeader(
                title:
                    'Anonymous User', // In production this would be the user's display name
                avatar:
                    'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
                dateTime: DateTime.now().subtract(const Duration(minutes: 10)),
                mood: post.mood,
                colors: colors,
              ),
              SizedBox(height: AppSpacing.s8.h),
              AppText.bodySmall(
                post.body,
                color: context.appColors.contentPrimary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color) _getTagColor(String tag, BuildContext context) {
    final colors = context.modeColors;
    final mood = MoodTypeX.fromString(tag) ?? MoodType.neutral;

    return switch (mood) {
      MoodType.love => (colors.love.backgroundColor, colors.love.textColor),
      MoodType.angry => (colors.angry.backgroundColor, colors.angry.textColor),
      MoodType.happy => (colors.happy.backgroundColor, colors.happy.textColor),
      MoodType.sad => (colors.sad.backgroundColor, colors.sad.textColor),
      MoodType.lonely => (
        colors.lonely.backgroundColor,
        colors.lonely.textColor,
      ),
      MoodType.excited => (
        colors.excited.backgroundColor,
        colors.excited.textColor,
      ),
      MoodType.dark => (colors.dark.backgroundColor, colors.dark.textColor),
      MoodType.neutral => (
        colors.neutral.backgroundColor,
        colors.neutral.textColor,
      ),
      MoodType.all => (
        context.appColors.backgroundPrimary,
        context.appColors.contentPrimary,
      ),
      MoodType.confused => (
        colors.confused.backgroundColor,
        colors.confused.textColor,
      ),
    };
  }
}

final class _PostHeader extends StatelessWidget {
  final String title;
  final String avatar;
  final DateTime dateTime;
  final String mood;
  final (Color, Color) colors;

  const _PostHeader({
    required this.title,
    required this.avatar,
    required this.dateTime,
    required this.mood,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage.network(
          avatar,
          width: IconSizes.prominent,
          height: IconSizes.prominent,
          shape: ImageShape.circle,
          fit: BoxFit.cover,
          borderColor: colors.$2,
          borderWidth: 1,
          padding: EdgeInsets.all(AppSpacing.s2.r),
        ),
        SizedBox(width: AppSpacing.s8.w),
        Expanded(
          child: _buildHeaderTitle(context),
        ),
        SizedBox(width: AppSpacing.s8.w),
        _buildTag(
          mood.toUpperCase(),
          backgroundColor: colors.$1,
          textColor: colors.$2,
        ),
      ],
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          title,
          textWeight: AppTextWeight.regular,
          color: context.appColors.contentPrimary,
        ),
        AppText.captionSmall(
          dateTime.toRelativeTime(),
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }

  Widget _buildTag(
    String tag, {
    required Color backgroundColor,
    required Color textColor,
  }) {
    return AppTag(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s8.w,
        vertical: AppSpacing.s2.h,
      ),
      backgroundColor: backgroundColor,
      child: AppText.captionSmall(
        tag,
        color: textColor,
      ),
    );
  }
}
