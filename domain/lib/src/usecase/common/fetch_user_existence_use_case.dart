import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class FetchUserExistenceUseCase extends UseCase<CommonApiEntity, UserParams> {
  final AuthRepository _repository;

  FetchUserExistenceUseCase(this._repository);

  @override
  Future<Result<CommonApiEntity, Failure>> call(UserParams params) async {
    final result = await _repository.checkUserExistence(params);
    return result;
  }
}
