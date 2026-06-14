import 'package:common/common.dart';
import 'package:domain/src/params/fetch_posts_params.dart';
import 'package:domain/src/repository/post_repository.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class FetchMyPostsUseCase extends UseCase<PostPagerEntity, FetchPostsParams> {
  final PostRepository _repository;

  FetchMyPostsUseCase(this._repository);

  @override
  Future<Result<PostPagerEntity, Failure>> call(FetchPostsParams params) {
    return _repository.fetchPosts(params);
  }
}
