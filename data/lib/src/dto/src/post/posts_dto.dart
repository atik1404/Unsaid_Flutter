import 'package:json_annotation/json_annotation.dart';

part 'posts_dto.g.dart';

@JsonSerializable(createToJson: false)
class PostsDto {
  final List<PostDto>? data;
  final PostMetaDto? meta;

  const PostsDto({this.data, this.meta});

  factory PostsDto.fromJson(Map<String, dynamic> json) =>
      _$PostsDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PostDto {
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
  @JsonKey(name: 'is_reacted')
  final bool? isReacted;
  @JsonKey(name: 'reaction_count')
  final int? reactionCount;
  @JsonKey(name: 'comment_count')
  final int? commentCount;
  @JsonKey(name: 'report_count')
  final int? reportCount;
  final int? score;
  final PostAuthorDto? author;

  const PostDto({
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
    this.isReacted,
    this.reactionCount,
    this.commentCount,
    this.reportCount,
    this.score,
    this.author,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PostAuthorDto {
  final String? id;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'avatar_seed')
  final int? avatarSeed;
  @JsonKey(name: 'anonymous_tag')
  final String? anonymousTag;

  const PostAuthorDto({
    this.id,
    this.fullName,
    this.avatarSeed,
    this.anonymousTag,
  });

  factory PostAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PostMetaDto {
  final int? total;
  @JsonKey(name: 'page_no')
  final int? pageNo;
  @JsonKey(name: 'page_size')
  final int? pageSize;
  @JsonKey(name: 'total_pages')
  final int? totalPages;

  const PostMetaDto({this.total, this.pageNo, this.pageSize, this.totalPages});

  factory PostMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PostMetaDtoFromJson(json);
}
