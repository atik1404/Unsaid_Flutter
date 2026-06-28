import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:post_details/src/state/post_details_state.dart';

part 'post_details_event.dart';

/// Manages the state for the Post Details screen.
///
/// Receives post data through [setPost] — usually called immediately
/// after the route is pushed with the [PostDetailsModel] passed as
/// a GoRouter extra.
class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final FetchPostDetailsUseCase _fetchPostDetailsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final AddReactUseCase _addReactUseCase;
  final RemoveReactUseCase _removeReactUseCase;
  final String _postId;

  PostDetailsBloc({
    required String postId,
    required FetchPostDetailsUseCase fetchPostDetailsUseCase,
    required AddCommentUseCase addCommentUseCase,
    required RemoveReactUseCase removeReactUseCase,
    required AddReactUseCase addReactUseCase,
  }) : _fetchPostDetailsUseCase = fetchPostDetailsUseCase,
       _addCommentUseCase = addCommentUseCase,
       _addReactUseCase = addReactUseCase,
       _removeReactUseCase = removeReactUseCase,
       _postId = postId,
       super(const PostDetailsState()) {
    on<FetchPostDetailsEvent>(_fetchPostDetails);
    on<AddCommentEvent>(_addComment);
    on<SubmitReactEvent>(_submitReact);
    on<_AddReactEvent>(_addReact);
    on<_RemoveReactEvent>(_removeReact);
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

  Future<void> _submitReact(
    SubmitReactEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    if (state.isReacted) {
      add(const _RemoveReactEvent());
    } else {
      add(const _AddReactEvent());
    }
  }

  Future<void> _addReact(
    _AddReactEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    final result = await _addReactUseCase.call(AddReactParams(postId: _postId, react: 'support'));

    result.when(
      success: (data) {
        emit(state.copyWith(isReacted: true));
      },
      failure: (_) {
        emit(state.copyWith(isReacted: false));
      },
    );
  }

  Future<void> _removeReact(
    _RemoveReactEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    final result = await _removeReactUseCase.call(
      _postId,
    );

    result.when(
      success: (data) {
        emit(state.copyWith(isReacted: false));
      },
      failure: (_) {
        emit(state.copyWith(isReacted: true));
      },
    );
  }
}
