import 'package:common/common.dart';
import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:post_details/src/state/post_details_event.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:domain/domain.dart';

/// Manages the state for the Post Details screen.
///
/// Receives post data through [setPost] — usually called immediately
/// after the route is pushed with the [PostDetailsModel] passed as
/// a GoRouter extra.
class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final FetchPostDetailsUseCase _fetchPostDetailsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final String _postId;

  PostDetailsBloc({required String postId, required FetchPostDetailsUseCase fetchPostDetailsUseCase, required AddCommentUseCase addCommentUseCase})
    : _fetchPostDetailsUseCase = fetchPostDetailsUseCase,
      _addCommentUseCase = addCommentUseCase,
      _postId = postId,
      super(const PostDetailsState()) {
    on<FetchPostDetailsEvent>(_fetchPostDetails);
    on<AddCommentEvent>(_addComment);
    add(FetchPostDetailsEvent(postId));
  }

  /// Stores the incoming post data and marks loading as complete.
  Future<void> _fetchPostDetails(
    FetchPostDetailsEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(
      state.copyWith(isLoading: true, postDetails: null, showToastMessage: false),
    );

    final result = await _fetchPostDetailsUseCase(event.postId);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            isLoading: false,
            postDetails: data,
            comments: data.comments,
          ),
        );
      },
      failure: (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure, showToastMessage: false));
      },
    );
  }

  Future<void> _addComment(
    AddCommentEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(
      state.copyWith(isSubmitting: true),
    );
    final result = await _addCommentUseCase.call(AddCommentParams(postId: _postId, commentBody: event.comment));

    result.when(
      success: (data) {
        final comments = List<CommentEntity>.from(state.comments)..add(data);
        emit(state.copyWith(isSubmitting: false, comments: comments));
      },
      failure: (failure) {
        emit(state.copyWith(isSubmitting: false, errorMessage: failure, showToastMessage: true));
      },
    );
  }
}
