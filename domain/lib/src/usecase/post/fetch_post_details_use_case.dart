import 'package:common/common.dart';
import 'package:domain/src/repository/post_repository.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class FetchPostDetailsUseCase extends UseCase<PostDetailsEntity, String> {
  final PostRepository _repository;

  FetchPostDetailsUseCase(this._repository);

  @override
  Future<Result<PostDetailsEntity, Failure>> call(String postId) {
    return _repository.fetchPostDetails(postId);
  }
}
