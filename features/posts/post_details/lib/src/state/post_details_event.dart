part of 'post_details_bloc.dart';

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

final class SubmitReactEvent extends PostDetailsEvent {
  const SubmitReactEvent();
}

final class _AddReactEvent extends PostDetailsEvent {
  const _AddReactEvent();
}

final class _RemoveReactEvent extends PostDetailsEvent {
  const _RemoveReactEvent();
}
