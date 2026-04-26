import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home/src/state/post_model.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<PostModel> posts,
    @Default(false) bool isLoading,
    @Default(false) bool hasReachedMax,
    @Default(1) int currentPage,
    String? errorMessage,
  }) = _HomeState;
}
