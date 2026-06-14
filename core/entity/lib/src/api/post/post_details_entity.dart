final class PostDetailsEntity {
  final String id;
  final DateTime createdAt;
  final String authorUserId;
  final String topicId;
  final String type;
  final String mood;
  final String body;
  final String visibility;
  final bool isLocked;
  final int reactionCount;
  final int commentCount;
  final int reportCount;
  final int score;
  final String authorName;
  final String authorAvatar;
  final List<CommentEntity> comments;

  const PostDetailsEntity({
    required this.id,
    required this.createdAt,
    required this.authorUserId,
    required this.topicId,
    required this.type,
    required this.mood,
    required this.body,
    required this.visibility,
    required this.isLocked,
    required this.reactionCount,
    required this.commentCount,
    required this.reportCount,
    required this.score,
    required this.authorName,
    required this.authorAvatar,
    required this.comments,
  });
}

final class CommentEntity {
  final String id;
  final DateTime createdAt;
  final String postId;
  final String authorUserId;
  final String? parentCommentId;
  final String body;
  final String visibility;
  final int reactionCount;
  final int reportCount;
  final int score;
  final String authorName;
  final String authorAvatar;

  const CommentEntity({
    required this.id,
    required this.createdAt,
    required this.postId,
    required this.authorUserId,
    this.parentCommentId,
    required this.body,
    required this.visibility,
    required this.reactionCount,
    required this.reportCount,
    required this.score,
    required this.authorName,
    required this.authorAvatar,
  });
}
