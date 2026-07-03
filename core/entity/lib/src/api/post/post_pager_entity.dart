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

  PostEntity copyWith({
    String? id,
    DateTime? createdAt,
    String? authorUserId,
    String? topicId,
    String? type,
    String? mood,
    String? body,
    String? visibility,
    bool? isLocked,
    bool? isReacted,
    int? reactionCount,
    int? commentCount,
    int? reportCount,
    int? score,
    String? authorName,
    String? authorAvatar,
  }) {
    return PostEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      authorUserId: authorUserId ?? this.authorUserId,
      topicId: topicId ?? this.topicId,
      type: type ?? this.type,
      mood: mood ?? this.mood,
      body: body ?? this.body,
      visibility: visibility ?? this.visibility,
      isLocked: isLocked ?? this.isLocked,
      isReacted: isReacted ?? this.isReacted,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
      reportCount: reportCount ?? this.reportCount,
      score: score ?? this.score,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
    );
  }
}
