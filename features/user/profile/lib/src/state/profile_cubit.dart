import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/src/state/profile_state.dart';
import 'package:domain/domain.dart';
import 'package:common/common.dart';

/// Manages the state for the Profile screen.
///
/// Loads the user's personal information and their own posts.
/// In production this would delegate to a repository; here we use
/// simulated data so the UI can be verified independently.
class ProfileCubit extends Cubit<ProfileState> {
  final FetchProfileUseCase _fetchProfileUseCase;
  final FetchMyPostsUseCase _fetchMyPostsUseCase;
  ProfileCubit({
    required this._fetchProfileUseCase,
    required this._fetchMyPostsUseCase,
  }) : super(const ProfileState());

  /// Fetches the profile owner's data and their posts.
  void fetchProfile() async {
    emit(state.copyWith(isLoading: true));

    final result = await _fetchProfileUseCase();

    result.when(
      success: (data) {
        _fetchMyPosts();
        emit(state.copyWith(profile: data, isLoading: false));
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

  Future<void> _fetchMyPosts() async {
    emit(state.copyWith(isPostLoading: true));

    final result = await _fetchMyPostsUseCase(
      const FetchPostsParams(),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            posts: data.posts,
            isPostLoading: false,
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
            isPostLoading: false,
          ),
        );
      },
    );
  }
}
