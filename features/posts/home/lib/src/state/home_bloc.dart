import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_event.dart';
import 'package:home/src/state/home_state.dart';
import 'package:domain/domain.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchPostsUseCase _fetchPostsUseCase;

  HomeBloc({required FetchPostsUseCase fetchPostsUseCase}) : _fetchPostsUseCase = fetchPostsUseCase, super(const HomeState()) {
    on<LoadPostsEvent>((event, emit) => _loadPosts(emit));
    on<SelectMoodEvent>(_selectMood);
  }

  void _selectMood(SelectMoodEvent event, Emitter<HomeState> emit) {
    if (state.mood == event.mood) return; // No change, do nothing.
    emit(state.copyWith(mood: event.mood, posts: [], currentPage: 1, hasReachedMax: false));
    add(const LoadPostsEvent());
  }

  void _loadPosts(Emitter<HomeState> emit) async {
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
        // Translate the domain Failure into a displayable string.
        final message = switch (error.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: message,
          ),
        );
      },
    );
  }
}
