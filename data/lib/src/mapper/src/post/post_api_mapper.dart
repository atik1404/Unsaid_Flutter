import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension PostApiMapper on PostsDto {
  PostPagerEntity toEntity() {
    final posts = data ?? [];
    final hasReachedMax = (meta?.pageNo ?? 0) >= (meta?.totalPages ?? 0);
    return PostPagerEntity(
      posts: posts
          .map(
            (post) => PostEntity(
              id: post.id ?? '',
              createdAt: DateTime.tryParse(post.createdAt ?? '') ?? DateTime.now(),
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
              authorName: '${post.author?.anonymousTag ?? ''}-${post.author?.fullName ?? ''}',
              authorAvatar: post.author?.avatarSeed.toString() ?? '',
            ),
          )
          .toList(),
      hasReachedMax: hasReachedMax,
    );
  }
}
