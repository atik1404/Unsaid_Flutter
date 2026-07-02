import 'package:common/common.dart';
import 'package:entity/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.freezed.dart';

/// Immutable UI state for the Create Post screen.
///
/// Holds the user's draft ([postBody], [selectedMood]) plus the submission
/// [status]. The post body lives here so the "Post" action can be validated and
@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    /// The text the user is composing.
    @Default('') String postBody,

    /// Currently selected mood for the post.
    @Default(null) MoodType? selectedMood,
    @Default(null) String? selectedTopic,

    /// Current submission lifecycle state.
    @Default(CreatePostStatus.initial) CreatePostStatus status,
    @Default([]) List<TopicEntity> topics,

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
  bool get canSubmit => postBody.trim().isNotEmpty && !isSubmitting && selectedMood != null && selectedTopic != null;
}

/// Lifecycle of a create-post submission.
///
/// Drives both the UI (button spinner, enabled state) and the side effects
/// handled by the screen's [BlocListener] (success/error toasts, navigation).
enum CreatePostStatus { initial, loading, submitting, success, failure }
