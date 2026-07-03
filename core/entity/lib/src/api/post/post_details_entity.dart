final class PostDetailsEntity {
  final String postId;
  final String createdAt;
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
  final bool isReacted;
  final List<CommentEntity> comments;

  const PostDetailsEntity({
    required this.postId,
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
    required this.isReacted,
    required this.comments,
  });

  PostDetailsEntity copyWith({
    String? postId,
    String? createdAt,
    String? authorUserId,
    String? topicId,
    String? type,
    String? mood,
    String? body,
    String? visibility,
    bool? isLocked,
    int? reactionCount,
    int? commentCount,
    int? reportCount,
    int? score,
    String? authorName,
    String? authorAvatar,
    bool? isReacted,
    List<CommentEntity>? comments,
  }) {
    return PostDetailsEntity(
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      authorUserId: authorUserId ?? this.authorUserId,
      topicId: topicId ?? this.topicId,
      type: type ?? this.type,
      mood: mood ?? this.mood,
      body: body ?? this.body,
      visibility: visibility ?? this.visibility,
      isLocked: isLocked ?? this.isLocked,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
      reportCount: reportCount ?? this.reportCount,
      score: score ?? this.score,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      isReacted: isReacted ?? this.isReacted,
      comments: comments ?? this.comments,
    );
  }
}

final class CommentEntity {
  final String commentId;
  final String createdAt;
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
    required this.commentId,
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
