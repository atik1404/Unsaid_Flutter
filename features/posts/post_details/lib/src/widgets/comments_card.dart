import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class CommentsCard extends StatelessWidget {
  final CommentEntity comment;
  const CommentsCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      padding: EdgeInsets.all(AppSpacing.s12.r),
      variant: AppCardVariant.outline,
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentHeader(context),
          SizedBox(height: AppSpacing.s8.h),
          AppText.captionMedium(
            comment.body,
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
          comment.authorName,
          textWeight: AppTextWeight.regular,
          color: context.appColors.contentPrimary,
        ),
        SizedBox(width: AppSpacing.s4.w),
        AppText.captionSmall(
          comment.createdAt.toRelativeTime(),
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }
}
