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
    @Default(false) bool isSubmitting,
    @Default(false) bool isReacting,
    @Default(false) bool showToastMessage,
    @Default(null) Failure? errorMessage,
  }) = _PostDetailsState;
}
