import 'package:common/common.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class FetchProfileUseCase extends UseCaseNoParams<ProfileEntity> {
  final AuthRepository _repository;

  FetchProfileUseCase(this._repository);

  @override
  Future<Result<ProfileEntity, Failure>> call() {
    return _repository.fetchProfile();
  }
}
