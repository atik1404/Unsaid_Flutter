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
class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _commentsSectionKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Brings the comments section into view after a new comment is posted.
  void _scrollToFirstComments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commentsContext = _commentsSectionKey.currentContext;
      if (commentsContext == null) return;
      Scrollable.ensureVisible(
        commentsContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostDetailsBloc, PostDetailsState>(
      // Only after a user-submitted comment succeeds (isSubmitting true -> false
      // with a new comment), not on the initial fetch that populates comments.
      listenWhen: (previous, current) =>
          previous.isSubmitting && !current.isSubmitting,
      listener: (context, state) => _scrollToFirstComments(),
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
            // bottomNavigationBar is pinned to the physical bottom and is not
            // lifted above the soft keyboard, so add the keyboard inset as
            // padding to keep the input field and send button visible.
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: CommentInputBox(
                isLoading: state.isSubmitting,
                onCommentSubmitted: (commnet) => {
                  context.read<PostDetailsBloc>().add(
                    AddCommentEvent(comment: commnet),
                  ),
                },
              ),
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
      controller: _scrollController,
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

          CommentsSection(
            key: _commentsSectionKey,
            comments: state.postDetails!.comments,
          ),
          SizedBox(height: AppSpacing.s16.h),
        ],
      ),
    );
  }
}
