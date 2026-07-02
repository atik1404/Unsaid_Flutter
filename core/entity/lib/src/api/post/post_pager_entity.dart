final class PostPagerEntity {
  final List<PostEntity> posts;
  final bool hasReachedMax;

  const PostPagerEntity({
    required this.posts,
    required this.hasReachedMax,
  });
}

final class PostEntity {
  final String id;
  final DateTime createdAt;
  final String authorUserId;
  final String topicId;
  final String type;
  final String mood;
  final String body;
  final String visibility;
  final bool isLocked;
  final bool isReacted;
  final int reactionCount;
  final int commentCount;
  final int reportCount;
  final int score;
  final String authorName;
  final String authorAvatar;

  const PostEntity({
    required this.id,
    required this.createdAt,
    required this.authorUserId,
    required this.topicId,
    required this.type,
    required this.mood,
    required this.body,
    required this.visibility,
    required this.isLocked,
    required this.isReacted,
    required this.reactionCount,
    required this.commentCount,
    required this.reportCount,
    required this.score,
    required this.authorName,
    required this.authorAvatar,
  });
}
