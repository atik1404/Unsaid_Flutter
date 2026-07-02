part of 'create_post_bloc.dart';

/// Base type for all Create Post intents.
sealed class CreatePostEvent {
  const CreatePostEvent();
}

/// Fired as the user edits the post body.
final class PostBodyChanged extends CreatePostEvent {
  final String body;
  const PostBodyChanged(this.body);
}

/// Fired when the user picks a mood pill.
final class MoodSelected extends CreatePostEvent {
  final MoodType mood;
  const MoodSelected(this.mood);
}

final class TopicSelected extends CreatePostEvent {
  final String topic;
  const TopicSelected(this.topic);
}

/// Fired when the user taps the "Post" action to publish the draft.
final class CreatePostSubmitted extends CreatePostEvent {
  const CreatePostSubmitted();
}

final class FetchTopics extends CreatePostEvent {
  const FetchTopics();
}
