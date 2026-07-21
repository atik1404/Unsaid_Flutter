import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class FetchPostsUseCase
    extends UseCase<PostPagerEntity, FetchPostsParams> {
  final PostRepository _repository;

  FetchPostsUseCase(this._repository);

  @override
  Future<Result<PostPagerEntity, Failure>> call(FetchPostsParams params) {
    return _repository.fetchPosts(params);
  }
}
