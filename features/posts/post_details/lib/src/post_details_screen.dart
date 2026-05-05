import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:post_details/src/state/post_details_cubit.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:post_details/src/widgets/post_detail_content.dart';
import 'package:post_details/src/widgets/post_detail_header.dart';

/// The Post Details screen.
///
/// Receives post data via the cubit (set from GoRouter extras) and
/// displays a header card followed by the full description card.
class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: AppText.titleMedium(
          context.l10n.post_details_title,
          textWeight: AppTextWeight.extraBold,
        ),
        backgroundColor: context.colorScheme.backgroundPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
        builder: (context, state) {
          if (state.isLoading || state.post == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final post = state.post!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.s16.r),
            child: Column(
              children: [
                // Post title, tag, author, date
                PostDetailHeader(post: post),
                SizedBox(height: AppSpacing.s16.h),

                // Full description
                PostDetailContent(description: post.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
