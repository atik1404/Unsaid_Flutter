import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:entity/entity.dart';

part 'profile_state.freezed.dart';

/// State for the Profile screen.
///
/// Contains the user's personal information and their list of posts.
/// [isLoading] is true while the initial data fetch is in progress.
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    ProfileEntity? profile,
    @Default([]) List<PostEntity> posts,
    @Default(false) bool isLoading,
    @Default(false) bool isLastPage,
    @Default(1) int currentPage,
    String? errorMessage,
  }) = _ProfileState;
}
