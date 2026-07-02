/// Domain entity representing a single topic (community/category) that a post
/// can belong to.
///
/// This is the framework-agnostic model consumed by the domain and
/// presentation layers. It is produced by mapping a `TopicDto` and therefore
/// never carries nullable transport concerns — every field has a safe default
/// applied during mapping.
final class TopicEntity {
  /// Unique identifier of the topic.
  final String id;

  /// Human readable display name (e.g. "Anxiety").
  final String name;

  /// URL/route friendly identifier (e.g. "anxiety").
  final String slug;

  /// Short description explaining what the topic is about.
  final String description;

  /// Whether the topic is flagged as "not safe for work".
  final bool isNsfw;

  /// Whether the topic is private (restricted visibility).
  final bool isPrivate;

  /// When the topic was created.
  final DateTime createdAt;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.isNsfw,
    required this.isPrivate,
    required this.createdAt,
  });
}
