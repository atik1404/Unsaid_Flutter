import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension PostDetailsApiMapper on PostDetailsDto {
  PostDetailsEntity toEntity() => PostDetailsEntity(
    id: id ?? '',
    createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    expiresAt: expiresAt != null ? DateTime.tryParse(expiresAt!) : null,
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
    authorName: author?.fullName ?? '',
    authorAvatar: author?.avatarSeed?.toString() ?? '',
    comments: comments?.map((c) => c.toEntity()).toList() ?? [],
  );
}

extension _CommentMapper on CommentDto {
  CommentEntity toEntity() => CommentEntity(
    id: id ?? '',
    createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    postId: postId ?? '',
    authorUserId: authorUserId ?? '',
    parentCommentId: parentCommentId,
    body: body ?? '',
    visibility: visibility ?? '',
    reactionCount: reactionCount ?? 0,
    reportCount: reportCount ?? 0,
    score: score ?? 0,
    authorName: author?.fullName ?? '',
    authorAvatar: author?.avatarSeed?.toString() ?? '',
  );
}
