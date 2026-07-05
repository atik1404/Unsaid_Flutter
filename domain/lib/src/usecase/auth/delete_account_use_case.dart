import 'package:common/common.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/usecase/base_usecase.dart';

/// Permanently deletes the authenticated user's account.
///
/// Returns the server success message (a plain [String]) on success.
final class DeleteAccountUseCase extends UseCaseNoParams<String> {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  @override
  Future<Result<String, Failure>> call() {
    return _repository.deleteAccount();
  }
}
