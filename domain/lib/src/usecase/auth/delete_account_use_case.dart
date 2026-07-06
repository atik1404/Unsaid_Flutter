import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';

/// Permanently deletes the authenticated user's account.
///
/// Takes the churn feedback the user provided ([DeleteAccountParams]) and
/// returns the server success message (a plain [String]) on success.
final class DeleteAccountUseCase extends UseCase<String, DeleteAccountParams> {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  @override
  Future<Result<String, Failure>> call(DeleteAccountParams params) {
    return _repository.deleteAccount(params);
  }
}
