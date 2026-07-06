import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

abstract class PostRepository {
  Future<Result<CreatePostEntity, Failure>> createPost(CreatePostParams params);

  Future<Result<PostPagerEntity, Failure>> fetchPosts(FetchPostsParams params);

  /// Fetches the list of available topics (`GET /get_topics`).
  Future<Result<List<TopicEntity>, Failure>> fetchTopics();

  Future<Result<PostPagerEntity, Failure>> fetchMyPosts(FetchPostsParams params);

  Future<Result<PostDetailsEntity, Failure>> fetchPostDetails(String postId);

  Future<Result<CommentEntity, Failure>> addComment(AddCommentParams params);

  Future<Result<ReactionEntity, Failure>> addReact(AddReactParams params);

  Future<Result<ReactionEntity, Failure>> removeReact(String postId);

  /// Permanently deletes all posts authored by the authenticated user
  /// (`DELETE /profile/posts`). Returns the server success message.
  Future<Result<String, Failure>> deleteAllPosts();
}
