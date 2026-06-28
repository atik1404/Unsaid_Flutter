import 'package:common/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.freezed.dart';

/// Lifecycle of a create-post submission.
///
/// Drives both the UI (button spinner, enabled state) and the side effects
/// handled by the screen's [BlocListener] (success/error toasts, navigation).
enum CreatePostStatus { initial, submitting, success, failure }

/// Immutable UI state for the Create Post screen.
///
/// Holds the user's draft ([postBody], [selectedMood]) plus the submission
/// [status]. The post body lives here so the "Post" action can be validated and
/// enabled/disabled reactively.
@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    /// The text the user is composing.
    @Default('') String postBody,

    /// Currently selected mood for the post.
    @Default(MoodType.all) MoodType selectedMood,

    /// Current submission lifecycle state.
    @Default(CreatePostStatus.initial) CreatePostStatus status,

    /// Server acknowledgement message, shown on success.
    String? successMessage,

    /// Failure surfaced to the user when submission fails.
    Failure? errorMessage,
  }) = _CreatePostState;

  const CreatePostState._();

  /// True while a create request is in flight.
  bool get isSubmitting => status == CreatePostStatus.submitting;

  /// The post can only be submitted with non-empty content and no in-flight
  /// request.
  bool get canSubmit => postBody.trim().isNotEmpty && !isSubmitting;
}
