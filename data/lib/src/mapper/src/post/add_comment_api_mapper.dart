import 'package:data/src/dto/src/post/comment_dto.dart';
import 'package:entity/entity.dart';

extension AddCommentApiMapper on CommentDto {
  CommentEntity toEntity() {
    final comment = data;

    return comment.toEntity();
  }
}

extension CommentDataMapper on CommentData? {
  CommentEntity toEntity() => CommentEntity(
    commentId: this?.id ?? '',
    createdAt: this?.createdAt ?? '',
    postId: this?.postId ?? '',
    authorUserId: this?.authorUserId ?? '',
    parentCommentId: this?.parentCommentId,
    body: this?.body ?? '',
    visibility: this?.visibility ?? '',
    reactionCount: this?.reactionCount ?? 0,
    reportCount: this?.reportCount ?? 0,
    score: this?.score ?? 0,
    authorName:
        '${this?.author?.anonymousTag ?? ''}-${this?.author?.fullName ?? ''}',
    authorAvatar: this?.author?.avatarSeed?.toString() ?? '',
  );
}
