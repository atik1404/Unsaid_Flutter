import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home/src/state/post_model.dart';
import 'package:ui/ui.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: AppSpacing.s2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        color: context.colorScheme.contentBrand,
      ),
      child: AppCard.rounded(
        variant: AppCardVariant.outline,
        cornerRadius: AppCardCornerRadius.lg,
        padding: EdgeInsets.all(AppSpacing.s12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(context),
            SizedBox(height: AppSpacing.s8.h),
            AppText.bodySmall(
              post.description,
              color: context.colorScheme.contentPrimary,
            ),
            SizedBox(height: AppSpacing.s12.h),
            _buildBottomActionsButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return Row(
      children: [
        AppImage.network(
          'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
          width: IconSizes.prominent,
          height: IconSizes.prominent,
          shape: ImageShape.circle,
          fit: BoxFit.cover,
          borderColor: context.colorScheme.borderSecondary,
        ),
        SizedBox(width: AppSpacing.s8.w),
        Expanded(
          child: _buildHeaderTitle(context),
        ),
        SizedBox(width: AppSpacing.s8.w),
        _buildTag(context, "LOVE"),
      ],
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          "Ghoost_8821",
          textWeight: AppTextWeight.regular,
          color: context.colorScheme.contentPrimary,
        ),
        AppText.captionSmall(
          "7 min ago",
          textWeight: AppTextWeight.light,
          color: context.colorScheme.contentSecondary,
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      intent: AppTagIntent.love,
      child: AppText.captionSmall(
        tag,
        color: context.colorScheme.contentError,
      ),
    );
  }

  Widget _buildBottomActionsButton(BuildContext context) {
    return Row(
      spacing: AppSpacing.s12,
      children: [
        InlineIconLabel(
          text: AppText.captionSmall("205", color: context.colorScheme.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: Icon(
            Icons.thumb_up_alt_sharp,
            size: IconSizes.inline,
            color: context.colorScheme.contentTertiary,
          ),
        ),

        InlineIconLabel(
          text: AppText.captionSmall("205", color: context.colorScheme.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: Icon(
            CupertinoIcons.heart,
            size: IconSizes.inline,
            color: context.colorScheme.contentTertiary,
          ),
        ),

        InlineIconLabel(
          text: AppText.captionSmall("205", color: context.colorScheme.contentTertiary),
          horizontalGap: AppSpacing.s4.w,
          leadingWidget: Icon(
            CupertinoIcons.chat_bubble,
            size: IconSizes.inline,
            color: context.colorScheme.contentTertiary,
          ),
        ),

        const Spacer(),
        const AppIconButton(
          Icon(
            Icons.send,
            size: IconSizes.inline,
          ),
          onPressed: null,
        ),
      ],
    );
  }
}
