import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/state/home_state.dart';
import 'package:home/src/state/post_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void loadPosts() async {
    if (state.isLoading || state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate fetching data based on current page
      final newPosts = List.generate(
        10,
        (index) => PostModel(
          id: '${state.currentPage}_$index',
          title: 'Post Title ${state.currentPage}-${index + 1}',
          dateTime: DateTime.now().subtract(Duration(days: index)),
          description: 'This is the description for post ${state.currentPage}-${index + 1}. It contains some interesting content about the topic discussed.',
          tag: 'Tag ${index % 3 + 1}',
        ),
      );

      final hasReachedMax = state.currentPage >= 5; // Limit to 5 pages

      emit(
        state.copyWith(
          isLoading: false,
          posts: List.of(state.posts)..addAll(newPosts),
          hasReachedMax: hasReachedMax,
          currentPage: state.currentPage + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load posts.',
        ),
      );
    }
  }
}
