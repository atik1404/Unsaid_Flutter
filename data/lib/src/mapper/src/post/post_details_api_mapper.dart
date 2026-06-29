import 'package:data/src/dto/dto.dart';
import 'package:data/src/mapper/src/post/add_comment_api_mapper.dart';
import 'package:entity/entity.dart';

extension PostDetailsApiMapper on PostDetailsDto {
  PostDetailsEntity toEntity() => PostDetailsEntity(
    postId: id ?? '',
    createdAt: createdAt ?? '',
    authorUserId: authorUserId ?? '',
    topicId: topicId ?? '',
    type: type ?? '',
    mood: mood ?? '',
    body: body ?? '',
    visibility: visibility ?? '',
    isLocked: isLocked ?? false,
    reactionCount: reactionCount ?? 0,
    commentCount: commentCount ?? 0,
    reportCount: reportCount ?? 0,
    score: score ?? 0,
    authorName: '${author?.anonymousTag ?? ''}-${author?.fullName ?? ''}',
    authorAvatar: author?.avatarSeed?.toString() ?? '',
    comments: comments?.map((comment) => comment.toEntity()).toList() ?? [],
  );
}
