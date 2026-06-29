import 'package:json_annotation/json_annotation.dart';

part 'add_comment_params.g.dart';

@JsonSerializable(
  createFactory: false,
)
final class AddCommentParams {
  @JsonKey(name: 'comment_body')
  final String commentBody;
  @JsonKey(name: 'post_id', includeToJson: false)
  final String postId;
  const AddCommentParams({required this.commentBody, required this.postId});

  Map<String, dynamic> toJson() => _$AddCommentParamsToJson(this);
}
