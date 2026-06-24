sealed class PostDetailsEvent {
  const PostDetailsEvent();
}

final class FetchPostDetailsEvent extends PostDetailsEvent {
  final String postId;
  const FetchPostDetailsEvent(this.postId);
}

final class PostNewCommentEvent extends PostDetailsEvent {
  final String postId;
  final String comment;
  const PostNewCommentEvent({required this.postId, required this.comment});
}
