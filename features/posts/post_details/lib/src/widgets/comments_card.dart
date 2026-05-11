import 'package:designsystem/designsystem.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class CommentsCard extends StatelessWidget {
  const CommentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      padding: EdgeInsets.all(AppSpacing.s12.r),
      variant: AppCardVariant.outline,
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          _buildCommentHeader(context),
          SizedBox(height: AppSpacing.s8.h),
          AppText.captionMedium(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt",
            color: context.appColors.contentPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentHeader(BuildContext context) {
    return Row(
      children: [
        AppImage.network(
          'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
          width: IconSizes.dense,
          height: IconSizes.dense,
          shape: ImageShape.circle,
          fit: BoxFit.cover,
          borderColor: context.appColors.contentPrimary,
          borderWidth: 1,
          padding: EdgeInsets.all(AppSpacing.s2.r),
        ),
        SizedBox(width: AppSpacing.s8.w),
        Expanded(
          child: _buildHeaderTitle(context),
        ),
      ],
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.bodySmall(
          "Ghoost_8821",
          textWeight: AppTextWeight.regular,
          color: context.appColors.contentPrimary,
        ),
        SizedBox(width: AppSpacing.s4.w),
        AppText.captionSmall(
          "7 min ago",
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }
}
