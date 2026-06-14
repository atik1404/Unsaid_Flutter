import 'package:data/src/dto/src/post/posts_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_details_dto.g.dart';

@JsonSerializable(createToJson: false)
class PostDetailsDto {
  final String? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;
  @JsonKey(name: 'author_user_id')
  final String? authorUserId;
  @JsonKey(name: 'topic_id')
  final String? topicId;
  final String? type;
  final String? mood;
  final String? body;
  final String? visibility;
  @JsonKey(name: 'is_locked')
  final bool? isLocked;
  @JsonKey(name: 'reaction_count')
  final int? reactionCount;
  @JsonKey(name: 'comment_count')
  final int? commentCount;
  @JsonKey(name: 'report_count')
  final int? reportCount;
  final int? score;
  final PostAuthorDto? author;
  final List<CommentDto>? comments;

  const PostDetailsDto({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.authorUserId,
    this.topicId,
    this.type,
    this.mood,
    this.body,
    this.visibility,
    this.isLocked,
    this.reactionCount,
    this.commentCount,
    this.reportCount,
    this.score,
    this.author,
    this.comments,
  });

  factory PostDetailsDto.fromJson(Map<String, dynamic> json) => _$PostDetailsDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CommentDto {
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

  const CommentDto({
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

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);
}
