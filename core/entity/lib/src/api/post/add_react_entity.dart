final class ReactionEntity {
  final String postId;
  final String react;
  final int reactionCount;

  const ReactionEntity({
    required this.postId,
    required this.react,
    required this.reactionCount,
  });
}
