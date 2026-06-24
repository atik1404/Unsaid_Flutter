import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  PostDetailsBloc({required FetchPostDetailsUseCase fetchPostDetailsUseCase}) : _fetchPostDetailsUseCase = fetchPostDetailsUseCase, super(const PostDetailsState()) {
    on<FetchPostDetailsEvent>(_fetchPostDetails);
  }

  /// Stores the incoming post data and marks loading as complete.
  Future<void> _fetchPostDetails(
    FetchPostDetailsEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        postDetails: null,
      ),
    );
    final result = await _fetchPostDetailsUseCase(event.postId);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            isLoading: false,
            postDetails: data,
          ),
        );
      },
      failure: (failure) {
        final message = switch (failure.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };
        emit(state.copyWith(isLoading: false, errorMessage: failure));
      },
    );
  }

  Future<void> postNewComment(
    PostNewCommentEvent event,
    Emitter<PostDetailsState> emit,
  ) async {}
}
