import 'package:common/common.dart';
import 'package:data/src/client/client.dart';
import 'package:data/src/dto/dto.dart';
import 'package:data/src/mapper/mapper.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

final class PostRepoImpl implements PostRepository {
  final RestClient _restClient;

  const PostRepoImpl(this._restClient);

  @override
  Future<Result<CreatePostEntity, Failure>> createPost(
    CreatePostParams params,
  ) {
    return _restClient.post(
      '/posts',
      data: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => CreatePostDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<PostPagerEntity, Failure>> fetchPosts(FetchPostsParams params) {
    return _restClient.get(
      '/posts',
      queryParameters: params.toJson(),
      options: AuthOptions.optional(),
      parser: (data) => PostsDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<List<TopicEntity>, Failure>> fetchTopics() {
    return _restClient.get(
      '/topics/get_topics',
      options: AuthOptions.authenticated(),
      parser: (data) => TopicsDto.fromJson(data).toEntities(),
    );
  }

  @override
  Future<Result<PostDetailsEntity, Failure>> fetchPostDetails(String postId) {
    return _restClient.get(
      '/posts/$postId',
      options: AuthOptions.optional(),
      parser: (data) => PostDetailsDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<PostPagerEntity, Failure>> fetchMyPosts(
    FetchPostsParams params,
  ) {
    return _restClient.get(
      '/profile/posts',
      queryParameters: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => MyPostsDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<CommentEntity, Failure>> addComment(
    AddCommentParams params,
  ) async {
    return _restClient.post(
      '/posts/${params.postId}/comments',
      data: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => CommentDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<ReactionEntity, Failure>> addReact(
    AddReactParams params,
  ) async {
    return _restClient.post(
      '/posts/${params.postId}/reactions',
      data: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => PostReactSubmitDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<ReactionEntity, Failure>> removeReact(String postId) {
    return _restClient.post(
      '/posts/$postId/reactions',
      options: AuthOptions.authenticated(),
      parser: (data) => PostReactSubmitDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<String, Failure>> deleteAllPosts() {
    // Authenticated endpoint — the interceptor attaches the Bearer token.
    // Only the success message is surfaced to the domain layer.
    return _restClient.delete(
      '/profile/posts',
      options: AuthOptions.authenticated(),
      parser: (data) => DeleteResponseDto.fromJson(data).toEntity(),
    );
  }
}
