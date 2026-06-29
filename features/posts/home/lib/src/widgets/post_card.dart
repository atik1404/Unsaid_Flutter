import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:entity/entity.dart';
import 'package:ui/ui.dart';

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
    final (bg, _, stroke) = MoodDecoration.getColor(context, tag: post.mood);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: AppSpacing.s2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          color: bg,
        ),
        child: AppCard.rounded(
          variant: AppCardVariant.outline,
          cornerRadius: AppCardCornerRadius.lg,
          padding: EdgeInsets.all(AppSpacing.s12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostHeader(
                mood: post.mood,
                authorName: post.authorName,
                dateTime: post.createdAt.toRelativeTime(),
                avatar: post.authorAvatar,
                borderColor: stroke,
              ),
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
  final String mood;
  final String authorName;
  final String dateTime;
  final String avatar;
  final Color borderColor;

  const _PostHeader({required this.mood, required this.authorName, required this.dateTime, required this.borderColor, required this.avatar});

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
          borderColor: borderColor,
          borderWidth: 1,
          padding: EdgeInsets.all(AppSpacing.s2.r),
        ),
        SizedBox(width: AppSpacing.s8.w),
        Expanded(
          child: _HeaderTitle(
            username: authorName,
            dateTime: dateTime,
          ),
        ),
        SizedBox(width: AppSpacing.s8.w),
        _MoodTag(tag: mood.toUpperCase()),
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
    final (bg, text, _) = MoodDecoration.getColor(context, tag: tag);
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      backgroundColor: bg,
      child: AppText.captionSmall(tag, color: text),
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
