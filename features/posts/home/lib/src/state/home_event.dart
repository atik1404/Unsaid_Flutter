import 'package:common/common.dart';

/// Base class for all events handled by [HomeBloc].
sealed class HomeEvent {
  const HomeEvent();
}

/// Requests the next page of posts from the API.
///
/// Safe to dispatch multiple times — the bloc ignores it while a load
/// is already in progress or when [HomeState.hasReachedMax] is true.
final class LoadPostsEvent extends HomeEvent {
  const LoadPostsEvent();
}

/// Changes the active mood filter and reloads posts from page 1.
///
/// Dispatching the same mood that is already selected is a no-op.
final class SelectMoodEvent extends HomeEvent {
  /// The mood to filter posts by. Use [MoodType.all] to remove the filter.
  final MoodType mood;
  const SelectMoodEvent(this.mood);
}
