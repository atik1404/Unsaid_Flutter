import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/src/state/profile_state.dart';
import 'package:domain/domain.dart';
import 'package:common/common.dart';

/// Manages the state for the Profile screen.
///
/// Loads the user's personal information and their own posts.
/// In production this would delegate to a repository; here we use
/// simulated data so the UI can be verified independently.
class ProfileBloc extends Cubit<ProfileState> {
  final FetchProfileUseCase _fetchProfileUseCase;
  final FetchMyPostsUseCase _fetchMyPostsUseCase;
  ProfileBloc({
    required FetchProfileUseCase fetchProfileUseCase,
    required FetchMyPostsUseCase fetchMyPostsUseCase,
  }) : _fetchProfileUseCase = fetchProfileUseCase,
       _fetchMyPostsUseCase = fetchMyPostsUseCase,
       super(const ProfileState());

  /// Fetches the profile owner's data and their posts.
  void fetchProfile() async {
    emit(state.copyWith(isLoading: true));

    final result = await _fetchProfileUseCase();

    result.when(
      success: (data) {
        fetchMyPosts();
        emit(
          state.copyWith(
            profile: data,
          ),
        );
      },
      failure: (failure) {
        final message = switch (failure.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };
        emit(
          state.copyWith(
            errorMessage: message,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> fetchMyPosts() async {
    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
    }

    final result = await _fetchMyPostsUseCase(
      FetchPostsParams(pageNo: state.currentPage),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            posts: [...state.posts, ...data.posts],
            isLoading: false,
            isLastPage: data.hasReachedMax,
            currentPage: state.currentPage + 1,
          ),
        );
      },
      failure: (failure) {
        final message = switch (failure.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };
        emit(
          state.copyWith(
            errorMessage: message,
            isLoading: false,
          ),
        );
      },
    );
  }
}
