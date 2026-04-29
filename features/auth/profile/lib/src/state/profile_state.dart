import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profile/src/state/profile_post_model.dart';

part 'profile_state.freezed.dart';

/// State for the Profile screen.
///
/// Contains the user's personal information and their list of posts.
/// [isLoading] is true while the initial data fetch is in progress.
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String bio,
    @Default('') String avatarUrl,
    @Default([]) List<ProfilePostModel> posts,
    @Default(false) bool isLoading,
  }) = _ProfileState;
}
