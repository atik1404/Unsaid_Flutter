import 'package:common/common.dart';
import 'package:domain/src/params/auth/signup_params.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class SignupUseCase extends UseCase<LoginEntity, SignupParams> {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  @override
  Future<Result<LoginEntity, Failure>> call(SignupParams params) async {
    final result = await _repository.signup(params);

    return result;
  }
}
