sealed class PostDetailsEvent {
  const PostDetailsEvent();
}

final class FetchPostDetailsEvent extends PostDetailsEvent {
  final String postId;
  const FetchPostDetailsEvent(this.postId);
}

final class AddCommentEvent extends PostDetailsEvent {
  final String comment;
  const AddCommentEvent({required this.comment});
}

final class AddReactEvent extends PostDetailsEvent {
  final String postId;
  const AddReactEvent({required this.postId});
}

final class RemoveReactEvent extends PostDetailsEvent {
  final String postId;
  const RemoveReactEvent({required this.postId});
}
