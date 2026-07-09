import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';

/// Updates the authenticated user's editable profile fields.
///
/// Returns the server success message (a plain [String]) on success.
final class UpdateProfileUseCase extends UseCase<String, UpdateProfileParams> {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Result<String, Failure>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params);
  }
}
