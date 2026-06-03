import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:domain/src/usecase/base_usecase.dart';
import 'package:entity/entity.dart';

final class SendOtpUseCase extends UseCase<SendOtpEntity, String> {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<Result<SendOtpEntity, Failure>> call(String phoneNumber) {
    return _repository.sendOtp(phoneNumber);
  }
}
