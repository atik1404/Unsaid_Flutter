import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

abstract class PostRepository {
  Future<Result<PostPagerEntity, Failure>> fetchPosts(FetchPostsParams params);

  Future<Result<PostPagerEntity, Failure>> fetchMyPosts(FetchPostsParams params);

  Future<Result<PostDetailsEntity, Failure>> fetchPostDetails(String postId);

  Future<Result<CommentEntity, Failure>> addComment(AddCommentParams params);

  Future<Result<ReactionEntity, Failure>> addReact(AddReactParams params);
}
