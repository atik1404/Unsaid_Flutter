import 'package:json_annotation/json_annotation.dart';

part 'topics_dto.g.dart';

/// Transport model for the `GET /get_topics` response envelope.
///
/// The API wraps the payload in a `data` array:
/// ```json
/// { "data": [ { ...topic } ] }
/// ```
/// Only deserialization is required (`createToJson: false`) because topics are
/// read-only from the client's perspective.
@JsonSerializable(createToJson: false)
class TopicsDto {
  final List<TopicDto>? data;

  const TopicsDto({this.data});

  factory TopicsDto.fromJson(Map<String, dynamic> json) =>
      _$TopicsDtoFromJson(json);
}

/// Transport model for a single topic item as returned by the API.
///
/// All fields are nullable to defensively tolerate missing/renamed keys from
/// the backend; sane defaults are applied later in the mapper.
@JsonSerializable(createToJson: false)
class TopicDto {
  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  @JsonKey(name: 'is_nsfw')
  final bool? isNsfw;
  @JsonKey(name: 'is_private')
  final bool? isPrivate;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const TopicDto({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.isNsfw,
    this.isPrivate,
    this.createdAt,
  });

  factory TopicDto.fromJson(Map<String, dynamic> json) =>
      _$TopicDtoFromJson(json);
}
