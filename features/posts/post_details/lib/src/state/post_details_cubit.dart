import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_details/src/state/post_details_state.dart';
import 'package:domain/domain.dart';

/// Manages the state for the Post Details screen.
///
/// Receives post data through [setPost] — usually called immediately
/// after the route is pushed with the [PostDetailsModel] passed as
/// a GoRouter extra.
class PostDetailsCubit extends Cubit<PostDetailsState> {
  final FetchPostDetailsUseCase _fetchPostDetailsUseCase;
  PostDetailsCubit({required FetchPostDetailsUseCase fetchPostDetailsUseCase}) : _fetchPostDetailsUseCase = fetchPostDetailsUseCase, super(const PostDetailsState());

  /// Stores the incoming post data and marks loading as complete.
  Future<void> fetchPostDetails(String postId) async {
    AppLog.log('postId: $postId');
    emit(state.copyWith(isLoading: true, postDetails: null, errorMessage: ''));
    final result = await _fetchPostDetailsUseCase(postId);

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
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
    );
  }
}
