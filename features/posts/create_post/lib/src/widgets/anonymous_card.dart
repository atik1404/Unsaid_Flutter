import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

class AnonymousCard extends StatelessWidget {
  final String _anonymousName;

  const AnonymousCard({super.key, required String anonymousName}) : _anonymousName = anonymousName;

  @override
  Widget build(BuildContext context) {
    return _buildPostHeader(context, context.appColors.brand);
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
        _buildTag(context, MoodType.happy.name.toUpperCase()),
      ],
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          _anonymousName,
          textWeight: AppTextWeight.regular,
          color: context.appColors.contentPrimary,
        ),
        AppText.captionSmall(
          context.l10n.create_post_anonymous_subtitle,
          textWeight: AppTextWeight.light,
          color: context.appColors.contentSecondary,
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final colors = MoodDecoration.getColor(context, tag: tag);
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      backgroundColor: colors.$1,
      child: AppText.captionSmall(
        tag,
        color: colors.$2,
      ),
    );
  }
}
