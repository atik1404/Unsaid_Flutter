import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';

final class VerifyOtpUseCase extends UseCase<String, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Result<String, Failure>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(params);
  }
}
