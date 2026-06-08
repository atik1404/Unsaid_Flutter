import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

class CommentInputBox extends StatelessWidget {
  const CommentInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      child: Row(
        children: [
          _buildAvatar(context),
          SizedBox(width: AppSpacing.s8.w),
          _buildInputField(context),
          SizedBox(width: AppSpacing.s8.w),
          _buildSendButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return AppImage.network(
      'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
      width: IconSizes.prominent,
      height: IconSizes.prominent,
      shape: ImageShape.circle,
      fit: BoxFit.cover,
      borderColor: context.appColors.contentPrimary,
      borderWidth: 1,
      padding: EdgeInsets.all(AppSpacing.s2.r),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Expanded(
      child: AppInputField(
        shape: AppInputFieldShape.pill,
        hint: context.l10n.post_details_comment_hint,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s8.r),
      decoration: BoxDecoration(
        color: context.appColors.brand,
        shape: BoxShape.circle,
      ),
      child: AppIconButton(
        AppIcon(
          const AppImage.asset(
            AppDrawables.icSend,
            width: IconSizes.dense,
            height: IconSizes.dense,
          ),
          color: context.appColors.white,
          tint: true,
        ),
        onPressed: () {},
      ),
    );
  }
}
