import 'package:data/src/dto/dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_dto.g.dart';

@JsonSerializable(createToJson: false)
class CommentDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;
  final CommentData? data;

  const CommentDto({this.statusCode, this.message, this.data});

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CommentData {
  final String? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'post_id')
  final String? postId;
  @JsonKey(name: 'author_user_id')
  final String? authorUserId;
  @JsonKey(name: 'parent_comment_id')
  final String? parentCommentId;
  final String? body;
  final String? visibility;
  @JsonKey(name: 'reaction_count')
  final int? reactionCount;
  @JsonKey(name: 'report_count')
  final int? reportCount;
  final int? score;
  final PostAuthorDto? author;

  const CommentData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.postId,
    this.authorUserId,
    this.parentCommentId,
    this.body,
    this.visibility,
    this.reactionCount,
    this.reportCount,
    this.score,
    this.author,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) => _$CommentDataFromJson(json);
}
