import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_details/src/state/post_details_model.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:jiffy/jiffy.dart';

/// Manages the state for the Post Details screen.
///
/// Receives post data through [setPost] — usually called immediately
/// after the route is pushed with the [PostDetailsModel] passed as
/// a GoRouter extra.
class PostDetailsCubit extends Cubit<PostDetailsState> {
  PostDetailsCubit() : super(const PostDetailsState());

  /// Stores the incoming post data and marks loading as complete.
  void fetchPostDetails(String postId) {
    Future.delayed(const Duration(seconds: 1), () {
      final post = PostDetailsModel(
        id: postId,
        title: 'Post Title',
        description: 'This is the full description of the post.',
        tag: 'happy',
        dateTime: Jiffy.parse(Jiffy.now().toString()).yMMMdjm,
      );
      emit(state.copyWith(post: post, isLoading: false));
    });
  }
}
