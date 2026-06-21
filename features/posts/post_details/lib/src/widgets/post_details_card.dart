import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigation/navigation.dart';
import 'package:ui/ui.dart';

final class PostDetailsCard extends StatelessWidget {
  final PostDetailsEntity postDetails;
  const PostDetailsCard({super.key, required this.postDetails});

  @override
  Widget build(BuildContext context) {
    final colors = _getTagColor(MoodType.happy.name, context);

    return Container(
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
            _buildPostHeader(context, colors.$2),
            SizedBox(height: AppSpacing.s8.h),
            AppText.bodySmall(
              postDetails.body,
              color: context.appColors.contentPrimary,
            ),
            SizedBox(height: AppSpacing.s12.h),
            Visibility(
              visible: AuthStateNotifier().isLoggedIn,
              child: _buildBottomActionsButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context, Color borderColor) {
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
          child: _buildHeaderTitle(context),
        ),
        SizedBox(width: AppSpacing.s8.w),
        _buildTag(context, postDetails.mood),
      ],
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          postDetails.authorName,
          textWeight: AppTextWeight.regular,
          color: context.appColors.contentPrimary,
        ),
        AppText.captionSmall(
          postDetails.createdAt.toRelativeTime(),
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final colors = _getTagColor(tag, context);
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      backgroundColor: colors.$1,
      child: AppText.captionSmall(
        tag,
        color: colors.$2,
      ),
    );
  }

  Widget _buildBottomActionsButton(BuildContext context) {
    final colors = context.appColors;

    return Row(
      spacing: AppSpacing.s12,
      children: [
        InlineIconLabel(
          text: AppText.captionSmall(postDetails.score.toString(), color: colors.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: AppImage.asset(
            AppDrawables.icFlame,
            width: IconSizes.inline,
            height: IconSizes.inline,
            color: colors.contentTertiary,
          ),
        ),

        InlineIconLabel(
          text: AppText.captionSmall(postDetails.reactionCount.toString(), color: colors.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: Icon(
            CupertinoIcons.heart,
            size: IconSizes.inline,
            color: colors.contentTertiary,
          ),
        ),

        InlineIconLabel(
          text: AppText.captionSmall(postDetails.commentCount.toString(), color: colors.contentTertiary),
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

  (Color, Color) _getTagColor(String tag, BuildContext context) {
    final colors = context.modeColors;
    final mood = MoodTypeX.fromString(tag) ?? MoodType.neutral;

    return switch (mood) {
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
}
