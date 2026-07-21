import 'package:create_post/src/state/create_post_bloc.dart';
import 'package:create_post/src/state/create_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

class AnonymousCard extends StatelessWidget {
  final String _anonymousName;
  final String _avatar;

  const AnonymousCard({
    super.key,
    required this._anonymousName,
    required this._avatar,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPostHeader(context, context.appColors.brand);
  }

  Widget _buildPostHeader(BuildContext context, Color borderColor) {
    return Row(
      children: [
        AppImage.network(
          _avatar,
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
        _buildTag(),
      ],
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          _anonymousName,
          textWeight: AppTextWeight.bold,
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

  Widget _buildTag() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      //selector: (state) => state.mood,
      builder: (context, state) {
        if (state.selectedMood == null) {
          return const SizedBox.shrink();
        }
        final (bg, text, _) = MoodDecoration.getColor(
          context,
          tag: state.selectedMood!.name,
        );
        return AppTag(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s8.w,
            vertical: AppSpacing.s2.h,
          ),
          backgroundColor: bg,
          child: AppText.captionSmall(
            state.selectedMood!.name.toUpperCase(),
            color: text,
          ),
        );
      },
    );
  }
}
