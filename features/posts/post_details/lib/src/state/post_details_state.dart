import 'package:common/common.dart';
import 'package:entity/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_details_state.freezed.dart';

/// State for the Post Details screen.
///
/// Wraps the [PostDetailsEntity] and a loading flag.
/// The post data is typically passed from the list screen via navigation extras.
@freezed
abstract class PostDetailsState with _$PostDetailsState {
  const factory PostDetailsState({
    PostDetailsEntity? postDetails,
    @Default(false) bool isLoading,
    @Default(null) Failure? errorMessage,
  }) = _PostDetailsState;
}

// @freezed
// sealed class PostDetailsState with _$PostDetailsState {
//   const factory PostDetailsState.success({required PostDetailsEntity postDetails}) = _Success;
//   const factory PostDetailsState.loading() = _Loading;
//   const factory PostDetailsState.error({required String error}) = _Error;
// }
