import 'package:json_annotation/json_annotation.dart';

part 'create_post_params.g.dart';

/// Request body for `POST /posts`.
///
/// Serialized to the snake_case shape expected by the backend:
/// `post_body`, `type`, `mood`, `topic_id`.
@JsonSerializable(
  createFactory: false,
)
final class CreatePostParams {
  @JsonKey(name: 'post_body')
  final String postBody;
  final String type;
  final String mood;

  /// Optional topic the post belongs to. Omitted from the payload when null so
  /// the post can be created without a topic until a topic picker exists.
  @JsonKey(name: 'topic_id', includeIfNull: false)
  final String? topicId;

  const CreatePostParams({
    required this.postBody,
    required this.type,
    required this.mood,
    this.topicId,
  });

  Map<String, dynamic> toJson() => _$CreatePostParamsToJson(this);
}
