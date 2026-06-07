import 'package:common/common.dart';
import 'package:entity/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<PostEntity> posts,
    @Default(false) bool isLoading,
    @Default(false) bool hasReachedMax,
    @Default(1) int currentPage,
    String? errorMessage,
    @Default(MoodType.all) MoodType mood,
  }) = _HomeState;
}
