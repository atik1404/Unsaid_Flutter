import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:post_details/src/state/post_details_cubit.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:post_details/src/widgets/comment_input_box.dart';
import 'package:post_details/src/widgets/comments_card.dart';
import 'package:post_details/src/widgets/post_details_card.dart';

/// The Post Details screen.
///
/// Receives post data via the cubit (set from GoRouter extras) and
/// displays a header card followed by the full description card.
class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: context.scaffoldTheme.backgroundColor,
        titleWidget: AppText.headlineSmall(
          context.l10n.post_details_title,
          color: context.appColors.contentBrand,
          textWeight: AppTextWeight.extraBold,
        ),
        foregroundColor: context.appColors.brand,
      ),
      body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
        builder: (context, state) {
          if (state.isLoading || state.post == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.s16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PostDetailsCard(),
                SizedBox(height: AppSpacing.s16.h),
                _buildReplyCountText(context, 19),
                SizedBox(height: AppSpacing.s8.h),
                _buildCommentsSection(),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: const CommentInputBox(),
    );
  }

  Widget _buildCommentsSection() {
    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.s8.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const CommentsCard();
      },
    );
  }

  Widget _buildReplyCountText(BuildContext context, int count) {
    return AppText.captionMedium(
      context.l10n.post_details_replies_count(count),
      color: context.appColors.contentPrimary,
      textWeight: AppTextWeight.light,
    );
  }
}
