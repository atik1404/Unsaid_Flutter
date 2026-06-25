import 'package:data/src/dto/dto.dart';
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
    comments: comments?.map((c) => c.toEntity()).toList() ?? [],
  );
}

extension _CommentMapper on CommentDto {
  CommentEntity toEntity() => CommentEntity(
    commentId: id ?? '',
    createdAt: createdAt ?? '',
    postId: postId ?? '',
    authorUserId: authorUserId ?? '',
    parentCommentId: parentCommentId,
    body: body ?? '',
    visibility: visibility ?? '',
    reactionCount: reactionCount ?? 0,
    reportCount: reportCount ?? 0,
    score: score ?? 0,
    authorName: '${author?.anonymousTag ?? ''}-${author?.fullName ?? ''}',
    authorAvatar: author?.avatarSeed?.toString() ?? '',
  );
}
