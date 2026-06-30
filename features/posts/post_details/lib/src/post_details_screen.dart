import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:post_details/src/state/post_details_bloc.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:post_details/src/widgets/comment_input_box.dart';
import 'package:post_details/src/widgets/comments_section.dart';
import 'package:post_details/src/widgets/post_details_card.dart';
import 'package:ui/ui.dart';

/// The Post Details screen.
///
/// Receives post data via the cubit (set from GoRouter extras) and
/// displays a header card followed by the full description card.
class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

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
            visible: state.postDetails != null && authStateNotifier.isLoggedIn,
            child: CommentInputBox(
              isLoading: state.isSubmitting,
              onCommentSubmitted: (commnet) => {
                context.read<PostDetailsBloc>().add(AddCommentEvent(comment: commnet)),
              },
            ),
          ),
        );
      },
    );
  }

  /// Renders the error message on failure, otherwise the post details.
  Widget _buildBody(BuildContext context, PostDetailsState state) {
    if (state.errorMessage != null) {
      return AppErrorScreen(
        message: state.errorMessage!.resolveMessage(context),
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
          PostDetailsCard(
            postDetails: postDetails,
            onReaction: (_) {
              context.read<PostDetailsBloc>().add(const SubmitReactEvent());
            },
          ),
          SizedBox(height: AppSpacing.s16.h),

          CommentsSection(comments: state.comments),
          SizedBox(height: AppSpacing.s16.h),
        ],
      ),
    );
  }
}
