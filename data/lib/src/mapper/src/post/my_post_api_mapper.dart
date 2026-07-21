import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension MyPostApiMapper on MyPostsDto {
  PostPagerEntity toEntity() {
    return PostPagerEntity(
      posts: (posts ?? [])
          .map(
            (post) => PostEntity(
              id: post.id ?? '',
              createdAt:
                  DateTime.tryParse(post.createdAt ?? '') ?? DateTime.now(),
              authorUserId: post.authorUserId ?? '',
              topicId: post.topicId ?? '',
              type: post.type ?? '',
              mood: post.mood ?? '',
              body: post.body ?? '',
              visibility: post.visibility ?? '',
              isLocked: post.isLocked ?? false,
              isReacted: post.isReacted ?? false,
              reactionCount: post.reactionCount ?? 0,
              commentCount: post.commentCount ?? 0,
              reportCount: post.reportCount ?? 0,
              score: post.score ?? 0,
              authorName:
                  '${post.author?.anonymousTag ?? ''}-${post.author?.fullName ?? ''}',
              authorAvatar: post.author?.avatarSeed.toString() ?? '',
            ),
          )
          .toList(),
      hasReachedMax: false,
    );
  }
}
