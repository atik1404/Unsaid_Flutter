import 'package:common/common.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class LoadPostsEvent extends HomeEvent {
  const LoadPostsEvent();
}

final class SelectMoodEvent extends HomeEvent {
  final MoodType mood;
  const SelectMoodEvent(this.mood);
}