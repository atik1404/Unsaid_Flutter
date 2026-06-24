import 'package:designsystem/designsystem.dart';
import 'package:entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:post_details/src/state/post_details_bloc.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:post_details/src/widgets/comment_input_box.dart';
import 'package:post_details/src/widgets/comments_card.dart';
import 'package:post_details/src/widgets/post_details_card.dart';
import 'package:ui/ui.dart';

/// The Post Details screen.
///
/// Receives post data via the cubit (set from GoRouter extras) and
/// displays a header card followed by the full description card.
class PostDetailsScreen extends StatelessWidget {
  final String postId;
  const PostDetailsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostDetailsBloc, PostDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
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
          isLoading: state.isLoading,
          body: _buildBody(context, state),
          bottomNavigationBar: Visibility(
            visible: AuthStateNotifier().isLoggedIn && state.postDetails != null,
            child: const CommentInputBox(),
          ),
        );
      },
    );
  }

  /// Renders the error message on failure, otherwise the post details.
  Widget _buildBody(BuildContext context, PostDetailsState state) {
    if (state.errorMessage != null) {
      return AppErrorScreen(
        message: state.errorMessage?.resolveMessage(context),
      );
    }

    if (state.postDetails == null) {
      return const SizedBox.shrink();
    }

    final postDetails = state.postDetails!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostDetailsCard(postDetails: postDetails),
          SizedBox(height: AppSpacing.s16.h),
          _buildReplyCountText(context, postDetails.commentCount),
          SizedBox(height: AppSpacing.s8.h),
          _buildCommentsSection(postDetails.comments),
        ],
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
