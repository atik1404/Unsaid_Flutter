import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

/// Creates a new post by delegating to the [PostRepository].
final class CreatePostUseCase extends UseCase<CreatePostEntity, CreatePostParams> {
  final PostRepository _repository;

  CreatePostUseCase(this._repository);

  @override
  Future<Result<CreatePostEntity, Failure>> call(CreatePostParams params) async {
    final result = await _repository.createPost(params);

    return result;
  }
}
