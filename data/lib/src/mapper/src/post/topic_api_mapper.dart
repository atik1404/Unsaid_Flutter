import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

/// Maps the `TopicsDto` transport model into a list of domain [TopicEntity]s.
///
/// This is the single boundary where nullable transport values are collapsed
/// into non-null domain values, keeping the rest of the app free of null
/// checks. Any absent field falls back to a safe default.
extension TopicApiMapper on TopicsDto {
  List<TopicEntity> toEntities() {
    final topics = data ?? [];
    return topics
        .map(
          (topic) => TopicEntity(
            id: topic.id ?? '',
            name: topic.name ?? '',
            slug: topic.slug ?? '',
            description: topic.description ?? '',
            isNsfw: topic.isNsfw ?? false,
            isPrivate: topic.isPrivate ?? false,
            createdAt:
                DateTime.tryParse(topic.createdAt ?? '') ?? DateTime.now(),
          ),
        )
        .toList();
  }
}
