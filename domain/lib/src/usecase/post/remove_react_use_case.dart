import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class RemoveReactUseCase extends UseCase<ReactionEntity, String> {
  final PostRepository _repository;

  RemoveReactUseCase(this._repository);

  @override
  Future<Result<ReactionEntity, Failure>> call(String postId) async {
    final result = await _repository.removeReact(postId);

    return result;
  }
}
