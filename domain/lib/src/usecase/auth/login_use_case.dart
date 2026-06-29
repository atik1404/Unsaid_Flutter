import 'package:common/common.dart';
import 'package:domain/src/params/auth/login_params.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Result<LoginEntity, Failure>> call(LoginParams params) async {
    final result = await _repository.login(params);

    return result;
  }
}
