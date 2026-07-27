import 'package:common/common.dart';
import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_event.dart';
import 'package:home/src/state/home_state.dart';
import 'package:domain/domain.dart';

/// BLoC that drives the home feed screen.
///
/// Handles pagination via [LoadPostsEvent] and mood filtering via
/// [SelectMoodEvent]. Posts are fetched with [FetchPostsUseCase] and
/// accumulated in [HomeState.posts] across pages.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchPostsUseCase _fetchPostsUseCase;

  final AddReactUseCase _addReactUseCase;
  final RemoveReactUseCase _removeReactUseCase;
  final AnalyticsTracker _analytics;

  HomeBloc({
    required this._fetchPostsUseCase,
    required this._addReactUseCase,
    required this._removeReactUseCase,
    required this._analytics,
  }) : super(const HomeState()) {
    on<LoadPostsEvent>((event, emit) => _loadPosts(emit));
    on<SelectMoodEvent>(_selectMood);
    on<AddReactEvent>(_addReact);
    on<RemoveReactEvent>(_removeReact);
  }

  /// Switches the active mood filter and resets pagination state before
  /// immediately triggering a fresh [LoadPostsEvent].
  void _selectMood(SelectMoodEvent event, Emitter<HomeState> emit) {
    if (state.mood == event.mood) return;

    // Filtering the feed is the main discovery gesture in this app — the
    // closest equivalent to a search — so which moods people reach for is a
    // signal worth having.
    _analytics.logEvent(
      FeatureUsageEvent(
        feature: 'feed_mood_filter',
        action: event.mood.name,
      ),
    );

    emit(
      state.copyWith(
        mood: event.mood,
        posts: [],
        currentPage: 1,
        hasReachedMax: false,
      ),
    );
    add(const LoadPostsEvent());
  }

  /// Fetches the next page of posts and appends them to [HomeState.posts].
  ///
  /// Early-exits when a fetch is already running or all pages are loaded.
  /// On failure the error message is stored in [HomeState.errorMessage].
  Future<void> _loadPosts(Emitter<HomeState> emit) async {
    if (state.isLoading || state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _fetchPostsUseCase(
      FetchPostsParams(
        pageNo: state.currentPage,
        mood: state.mood != MoodType.all ? state.mood.name : null,
      ),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            posts: List.of(state.posts)..addAll(data.posts),
            isLoading: false,
            hasReachedMax: data.hasReachedMax,
            currentPage: state.currentPage + 1,
          ),
        );
      },
      failure: (error) {
        final message = switch (error.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
    );
  }

  Future<void> _addReact(
    AddReactEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isReacting) return;
    emit(
      state.copyWith(
        isReacting: true,
        posts: _toggleReaction(event.postId, reacted: true),
      ),
    );
    final result = await _addReactUseCase.call(
      AddReactParams(postId: event.postId),
    );

    result.when(
      success: (data) {
        // Logged only once the backend confirms it — the optimistic UI update
        // above is rolled back on failure, so tracking it earlier would
        // over-count reactions.
        _analytics.logEvent(
          BusinessEvent(
            AnalyticsEventName.postReacted,
            parameters: {'action': 'add', 'post': event.postId},
          ),
        );

        emit(state.copyWith(isReacting: false));
      },
      failure: (_) {
        emit(
          state.copyWith(
            isReacting: false,
            posts: _toggleReaction(event.postId, reacted: false),
          ),
        );
      },
    );
  }

  Future<void> _removeReact(
    RemoveReactEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isReacting) return;
    emit(
      state.copyWith(
        isReacting: true,
        posts: _toggleReaction(event.postId, reacted: false),
      ),
    );
    final result = await _removeReactUseCase.call(
      event.postId,
    );

    result.when(
      success: (data) {
        _analytics.logEvent(
          BusinessEvent(
            AnalyticsEventName.postReacted,
            parameters: {'action': 'remove', 'post': event.postId},
          ),
        );

        emit(state.copyWith(isReacting: false));
      },
      failure: (_) {
        emit(
          state.copyWith(
            isReacting: false,
            posts: _toggleReaction(event.postId, reacted: true),
          ),
        );
      },
    );
  }

  /// Returns a new posts list with the reaction state of the [postId] item
  /// set to [reacted], adjusting [PostEntity.reactionCount] accordingly.
  ///
  /// Only the matching item is rebuilt; the rest keep their identity.
  List<PostEntity> _toggleReaction(String postId, {required bool reacted}) {
    final index = state.posts.indexWhere((post) => post.id == postId);
    if (index == -1 || state.posts[index].isReacted == reacted) {
      return state.posts;
    }

    final post = state.posts[index];
    final updatedPosts = List<PostEntity>.of(state.posts);
    updatedPosts[index] = post.copyWith(
      isReacted: reacted,
      reactionCount: reacted ? post.reactionCount + 1 : post.reactionCount - 1,
    );
    return updatedPosts;
  }
}
