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
}
