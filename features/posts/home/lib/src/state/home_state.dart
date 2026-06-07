import 'package:common/common.dart';
import 'package:entity/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

/// Immutable state for the home feed, managed by [HomeBloc].
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    /// Accumulated list of posts across all loaded pages.
    @Default([]) List<PostEntity> posts,

    /// True while a page fetch is in flight.
    @Default(false) bool isLoading,

    /// True once the last available page has been loaded.
    @Default(false) bool hasReachedMax,

    /// The next page number to fetch (1-indexed).
    @Default(1) int currentPage,

    /// Non-null when the last fetch failed; contains a displayable message.
    String? errorMessage,

    /// Active mood filter. [MoodType.all] means no filter is applied.
    @Default(MoodType.all) MoodType mood,
  }) = _HomeState;
}
