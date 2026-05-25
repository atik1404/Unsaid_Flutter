import 'package:common/common.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

final class PostRepoImpl implements PostRepository {
  final RestClient _restClient;

  const PostRepoImpl(this._restClient);
  
  @override
  Future<Result<List<PostEntity>, Failure>> fetchPosts() {
    // TODO: implement fetchPosts
    throw UnimplementedError();
  }

  // @override
  // Future<Result<List<PostEntity>, Failure>> fetchPosts() async {
  //   final result = await _restClient.get(
  //     '/posts',
  //     options: AuthOptions.authenticated(),
  //     parser: (data) => (data as List).map((e) => PostDto.fromJson(e).toEntity()).toList(),
  //   );
  //   return result;
  // }
}
