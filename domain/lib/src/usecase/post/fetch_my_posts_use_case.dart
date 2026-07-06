import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class FetchMyPostsUseCase extends UseCase<PostPagerEntity, FetchPostsParams> {
  final PostRepository _repository;

  FetchMyPostsUseCase(this._repository);

  @override
  Future<Result<PostPagerEntity, Failure>> call(FetchPostsParams params) {
    return _repository.fetchMyPosts(params);
  }
}
