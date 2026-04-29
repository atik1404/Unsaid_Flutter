import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:post_details/src/state/post_details_model.dart';

part 'post_details_state.freezed.dart';

/// State for the Post Details screen.
///
/// Wraps the [PostDetailsModel] and a loading flag.
/// The post data is typically passed from the list screen via navigation extras.
@freezed
abstract class PostDetailsState with _$PostDetailsState {
  const factory PostDetailsState({
    PostDetailsModel? post,
    @Default(false) bool isLoading,
  }) = _PostDetailsState;
}
