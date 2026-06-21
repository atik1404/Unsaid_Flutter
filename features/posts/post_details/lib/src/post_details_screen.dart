import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
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
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.postDetails == null) {
            return Center(
              child: AppText.bodyMedium(
                'post details not found',
                color: context.appColors.contentPrimary,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.s16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostDetailsCard(
                  postDetails: state.postDetails!,
                ),
                SizedBox(height: AppSpacing.s16.h),
                _buildReplyCountText(context, state.postDetails!.commentCount),
                SizedBox(height: AppSpacing.s8.h),
                _buildCommentsSection(state.postDetails!.comments),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Visibility(
        visible: AuthStateNotifier().isLoggedIn,
        child: const CommentInputBox(),
      ),
    );
  }

  Widget _buildCommentsSection(List<CommentEntity> comments) {
    return ListView.separated(
      itemCount: comments.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.s8.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CommentsCard(comment: comments[index]);
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
