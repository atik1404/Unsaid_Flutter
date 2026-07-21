import 'package:common/common.dart';
import 'package:create_post/src/state/create_post_state.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_post_event.dart';

/// Business logic for the Create Post screen.
///
/// Tracks the in-progress draft (body + mood) as the user edits it and submits
/// it through [CreatePostUseCase]. Emits a terminal [CreatePostStatus] the
/// screen reacts to for navigation and toasts.
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostUseCase _createPostUseCase;
  final FetchTopicsUseCase _fetchTopicsUseCase;

  CreatePostBloc({
    required this._createPostUseCase,
    required this._fetchTopicsUseCase,
  }) : super(const CreatePostState()) {
    on<PostBodyChanged>(_onPostBodyChanged);
    on<MoodSelected>(_onMoodSelected);
    on<CreatePostSubmitted>(_onSubmitted);
    on<FetchTopics>(_onFetchTopics);
    on<TopicSelected>(_onTopicSelected);
    add(const FetchTopics());
  }

  /// Mirrors the latest composed text into state so the action button can
  /// validate it. Clears any stale error from a previous failed attempt.
  void _onPostBodyChanged(
    PostBodyChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(postBody: event.body, errorMessage: null));
  }

  /// Updates the selected mood; ignored when the mood is unchanged.
  void _onMoodSelected(MoodSelected event, Emitter<CreatePostState> emit) {
    if (event.mood == state.selectedMood) return;
    emit(state.copyWith(selectedMood: event.mood));
  }

  void _onTopicSelected(TopicSelected event, Emitter<CreatePostState> emit) {
    if (event.topic == state.selectedTopic) return;
    emit(state.copyWith(selectedTopic: event.topic));
  }

  /// Validates and sends the post to the backend, emitting submitting →
  /// success/failure so the UI can react.
  Future<void> _onSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(
      state.copyWith(status: CreatePostStatus.submitting, errorMessage: null),
    );

    final result = await _createPostUseCase.call(
      CreatePostParams(
        postBody: state.postBody.trim(),
        // Text-only posts for now; media support will introduce other types.
        type: 'text',
        topicId: state.selectedTopic,
        // The API expects the lowercase mood key (e.g. "happy").
        mood: state.selectedMood?.name ?? '',
      ),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: CreatePostStatus.success,
            successMessage: data.message,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: CreatePostStatus.failure,
            errorMessage: failure,
          ),
        );
      },
    );
  }

  Future<void> _onFetchTopics(
    FetchTopics event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(state.copyWith(status: CreatePostStatus.loading, errorMessage: null));
    final result = await _fetchTopicsUseCase.call();

    result.when(
      success: (data) {
        emit(state.copyWith(topics: data, status: CreatePostStatus.initial));
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: CreatePostStatus.failure,
            errorMessage: failure,
          ),
        );
      },
    );
  }
}
