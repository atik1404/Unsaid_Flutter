import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:entity/entity.dart';
import 'package:ui/ui.dart';
import 'package:jiffy/jiffy.dart';

/// Card widget that renders a single [PostEntity] in the feed.
///
/// Displays the author avatar, name, timestamp, mood tag, post body,
/// and a row of engagement counters (score, reactions, comments).
class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final moodColors = _moodColors(post.mood, context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: AppSpacing.s2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          color: moodColors.$2,
        ),
        child: AppCard.rounded(
          variant: AppCardVariant.outline,
          cornerRadius: AppCardCornerRadius.lg,
          padding: EdgeInsets.all(AppSpacing.s12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostHeader(post: post, borderColor: moodColors.$2),
              SizedBox(height: AppSpacing.s8.h),
              AppText.bodySmall(
                post.body,
                color: context.appColors.contentPrimary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.s12.h),
              _PostActions(
                score: post.score,
                reactionCount: post.reactionCount,
                commentCount: post.commentCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private widgets
// ---------------------------------------------------------------------------

/// Author row: avatar, name + timestamp, and mood tag.
class _PostHeader extends StatelessWidget {
  final PostEntity post;

  /// Accent colour derived from the post mood, used as the avatar border.
  final Color borderColor;

  const _PostHeader({required this.post, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage.network(
          'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
          width: IconSizes.prominent,
          height: IconSizes.prominent,
          shape: ImageShape.circle,
          fit: BoxFit.cover,
          borderColor: borderColor,
          borderWidth: 1,
          padding: EdgeInsets.all(AppSpacing.s2.r),
        ),
        SizedBox(width: AppSpacing.s8.w),
        Expanded(
          child: _HeaderTitle(
            username: post.authorName,
            dateTime: post.createdAt.toRelativeTime(),
          ),
        ),
        SizedBox(width: AppSpacing.s8.w),
        _MoodTag(tag: post.mood.toUpperCase()),
      ],
    );
  }
}

/// Two-line column showing the author's display name and post timestamp.
class _HeaderTitle extends StatelessWidget {
  final String username;
  final String dateTime;

  const _HeaderTitle({required this.username, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          username,
          textWeight: AppTextWeight.regular,
          color: context.appColors.contentPrimary,
        ),
        AppText.captionSmall(
          dateTime,
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }
}

/// Pill-shaped tag coloured according to the post mood.
class _MoodTag extends StatelessWidget {
  final String tag;

  const _MoodTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    final colors = _moodColors(tag, context);
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      backgroundColor: colors.$1,
      child: AppText.captionSmall(tag, color: colors.$2),
    );
  }
}

/// Row of engagement counters: score (flame), reactions (heart), comments (bubble).
class _PostActions extends StatelessWidget {
  final int score;
  final int reactionCount;
  final int commentCount;

  const _PostActions({
    required this.score,
    required this.reactionCount,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      spacing: AppSpacing.s12,
      children: [
        InlineIconLabel(
          text: AppText.captionSmall('$score', color: colors.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: AppImage.asset(
            AppDrawables.icFlame,
            width: IconSizes.inline,
            height: IconSizes.inline,
            color: colors.contentTertiary,
          ),
        ),
        InlineIconLabel(
          text: AppText.captionSmall('$reactionCount', color: colors.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: Icon(
            CupertinoIcons.heart,
            size: IconSizes.inline,
            color: colors.contentTertiary,
          ),
        ),
        InlineIconLabel(
          text: AppText.captionSmall('$commentCount', color: colors.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: Icon(
            CupertinoIcons.chat_bubble,
            size: IconSizes.inline,
            color: colors.contentTertiary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns `(backgroundColor, textColor)` for the given [mood] string.
(Color, Color) _moodColors(String mood, BuildContext context) {
  final colors = context.modeColors;
  final moodType = MoodTypeX.fromString(mood) ?? MoodType.neutral;

  return switch (moodType) {
    MoodType.love => (colors.love.backgroundColor, colors.love.textColor),
    MoodType.angry => (colors.angry.backgroundColor, colors.angry.textColor),
    MoodType.happy => (colors.happy.backgroundColor, colors.happy.textColor),
    MoodType.sad => (colors.sad.backgroundColor, colors.sad.textColor),
    MoodType.lonely => (colors.lonely.backgroundColor, colors.lonely.textColor),
    MoodType.excited => (colors.excited.backgroundColor, colors.excited.textColor),
    MoodType.dark => (colors.dark.backgroundColor, colors.dark.textColor),
    MoodType.neutral => (colors.neutral.backgroundColor, colors.neutral.textColor),
    MoodType.all => (context.appColors.backgroundPrimary, context.appColors.contentPrimary),
    MoodType.confused => (colors.confused.backgroundColor, colors.confused.textColor),
  };
}
