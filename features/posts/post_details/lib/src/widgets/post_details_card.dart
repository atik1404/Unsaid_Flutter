import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:navigation/navigation.dart';
import 'package:post_details/src/state/post_details_bloc.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:ui/ui.dart';

final class PostDetailsCard extends StatelessWidget {
  final PostDetailsEntity postDetails;
  final Function(String) onReaction;

  const PostDetailsCard({super.key, required this.postDetails, required this.onReaction});

  @override
  Widget build(BuildContext context) {
    final (bg, text, stroke) = MoodDecoration.getColor(
      context,
      tag: MoodType.happy.name,
    );

    return Container(
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
            _buildPostHeader(context, text, bg, stroke),
            SizedBox(height: AppSpacing.s8.h),
            AppText.bodySmall(
              postDetails.body,
              color: context.appColors.contentPrimary,
            ),
            SizedBox(height: AppSpacing.s12.h),
            Visibility(
              visible: authStateNotifier.isLoggedIn,
              child: _buildBottomActionsButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context, Color textColor, Color bgColor, Color strokeColor) {
    return Row(
      children: [
        AppImage.network(
          'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
          width: IconSizes.prominent,
          height: IconSizes.prominent,
          shape: ImageShape.circle,
          fit: BoxFit.cover,
          borderColor: strokeColor,
          borderWidth: 1,
          padding: EdgeInsets.all(AppSpacing.s2.r),
        ),
        SizedBox(width: AppSpacing.s8.w),
        Expanded(
          child: _buildHeaderTitle(context),
        ),
        SizedBox(width: AppSpacing.s8.w),
        _buildTag(postDetails.mood, textColor, bgColor),
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
          Jiffy.parse(postDetails.createdAt).dateTime.toRelativeTime(),
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }

  Widget _buildTag(String tag, Color textColor, Color bgColor) {
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      backgroundColor: bgColor,
      child: AppText.captionSmall(
        tag.toUpperCase(),
        color: textColor,
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

        BlocBuilder<PostDetailsBloc, PostDetailsState>(
          builder: (context, state) {
            return InlineIconLabel(
              onTap: () => onReaction(postDetails.postId),
              text: AppText.captionSmall(postDetails.reactionCount.toString(), color: colors.contentTertiary),
              horizontalGap: AppSpacing.s4.w,
              leadingWidget: Icon(
                state.isReacted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                size: IconSizes.inline,
                color: state.isReacted ? colors.secondary : colors.contentTertiary,
              ),
            );
          },
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
}
