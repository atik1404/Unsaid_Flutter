import 'package:common/common.dart';
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
  /// Screen label attached to events this bloc shares with the feed, so the
  /// same event name can still be split by origin in the dashboard. A local
  /// constant keeps the bloc free of a dependency on the navigation package.
  static const String _screenName = 'post_details';

  final FetchPostDetailsUseCase _fetchPostDetailsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final AddReactUseCase _addReactUseCase;
  final RemoveReactUseCase _removeReactUseCase;
  final AnalyticsTracker _analytics;
  final String _postId;

  PostDetailsBloc({
    required String postId,
    required this._fetchPostDetailsUseCase,
    required this._addCommentUseCase,
    required this._removeReactUseCase,
    required this._addReactUseCase,
    required this._analytics,
  }) : _postId = postId,
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
      state.copyWith(
        isLoading: true,
        postDetails: null,
        showToastMessage: false,
      ),
    );

    final result = await _fetchPostDetailsUseCase(event.postId);

    result.when(
      success: (data) {
        // Tracked on a confirmed load rather than on route entry, so a failed
        // fetch is not counted as the user having read the post.
        _analytics.logEvent(
          BusinessEvent(
            AnalyticsEventName.postOpened,
            parameters: {'post': event.postId},
          ),
        );

        emit(
          state.copyWith(
            isLoading: false,
            postDetails: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure,
            showToastMessage: false,
          ),
        );
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
    final result = await _addCommentUseCase.call(
      AddCommentParams(postId: _postId, commentBody: event.comment),
    );

    result.when(
      success: (data) {
        // The comment text is user-authored content and is never sent.
        _analytics.logEvent(
          BusinessEvent(
            AnalyticsEventName.postCommented,
            parameters: {'post': _postId},
          ),
        );

        final comments = List<CommentEntity>.from(state.postDetails!.comments)
          ..add(data);
        emit(
          state.copyWith(
            isSubmitting: false,
            postDetails: state.postDetails!.copyWith(
              comments: comments,
              commentCount: comments.length,
            ),
            showToastMessage: true,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: failure,
            showToastMessage: true,
          ),
        );
      },
    );
  }

  void _submitReact(
    SubmitReactEvent event,
    Emitter<PostDetailsState> emit,
  ) {
    if (state.isReacting) {
      return;
    }
    if (state.postDetails!.isReacted) {
      add(const _RemoveReactEvent());
    } else {
      add(const _AddReactEvent());
    }
  }

  Future<void> _addReact(
    _AddReactEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        isReacting: true,
        postDetails: _toggleReaction(reacted: true),
      ),
    );
    final result = await _addReactUseCase.call(AddReactParams(postId: _postId));

    result.when(
      success: (data) {
        // Same event name the feed emits, so reactions aggregate across both
        // surfaces; `screen` keeps them separable when that matters.
        _analytics.logEvent(
          BusinessEvent(
            AnalyticsEventName.postReacted,
            parameters: {
              'action': 'add',
              'post': _postId,
              'screen': _screenName,
            },
          ),
        );

        emit(state.copyWith(isReacting: false));
      },
      failure: (_) {
        emit(
          state.copyWith(
            isReacting: false,
            postDetails: _toggleReaction(reacted: false),
          ),
        );
      },
    );
  }

  Future<void> _removeReact(
    _RemoveReactEvent event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        isReacting: true,
        postDetails: _toggleReaction(reacted: false),
      ),
    );
    final result = await _removeReactUseCase.call(
      _postId,
    );

    result.when(
      success: (data) {
        _analytics.logEvent(
          BusinessEvent(
            AnalyticsEventName.postReacted,
            parameters: {
              'action': 'remove',
              'post': _postId,
              'screen': _screenName,
            },
          ),
        );

        emit(state.copyWith(isReacting: false));
      },
      failure: (_) {
        emit(
          state.copyWith(
            isReacting: false,
            postDetails: _toggleReaction(reacted: true),
          ),
        );
      },
    );
  }

  /// Returns a new posts list with the reaction state of the [postId] item
  /// set to [reacted], adjusting [PostEntity.reactionCount] accordingly.
  ///
  /// Only the matching item is rebuilt; the rest keep their identity.
  PostDetailsEntity _toggleReaction({required bool reacted}) {
    final post = state.postDetails!;
    final updatedPost = post.copyWith(
      isReacted: reacted,
      reactionCount: reacted ? post.reactionCount + 1 : post.reactionCount - 1,
    );
    return updatedPost;
  }
}
