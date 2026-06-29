import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class AddReactUseCase extends UseCase<ReactionEntity, AddReactParams> {
  final PostRepository _repository;

  AddReactUseCase(this._repository);

  @override
  Future<Result<ReactionEntity, Failure>> call(AddReactParams params) async {
    final result = await _repository.addReact(params);

    return result;
  }
}
