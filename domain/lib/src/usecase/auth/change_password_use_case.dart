import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';

/// Changes the authenticated user's password.
///
/// Returns the server success message (a plain [String]) on success.
final class ChangePasswordUseCase extends UseCase<String, ChangePasswordParams> {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<Result<String, Failure>> call(ChangePasswordParams params) {
    return _repository.changePassword(params);
  }
}
