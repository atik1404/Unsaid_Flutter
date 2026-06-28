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
  Future<Result<PostPagerEntity, Failure>> fetchPosts(FetchPostsParams params) {
    return _restClient.get(
      '/posts',
      queryParameters: params.toJson(),
      parser: (data) => PostsDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<PostDetailsEntity, Failure>> fetchPostDetails(String postId) {
    return _restClient.get(
      '/posts/$postId',
      parser: (data) => PostDetailsDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<PostPagerEntity, Failure>> fetchMyPosts(FetchPostsParams params) {
    return _restClient.get(
      '/profile/posts',
      queryParameters: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => MyPostsDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<CommentEntity, Failure>> addComment(AddCommentParams params) async {
    return _restClient.post(
      '/posts/${params.postId}/comments',
      data: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => CommentDto.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Result<ReactionEntity, Failure>> addReact(AddReactParams params) async {
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
}
