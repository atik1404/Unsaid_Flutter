import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

abstract class AuthRepository {
  Future<Result<LoginEntity, Failure>> login(LoginParams params);

  Future<Result<ProfileEntity, Failure>> fetchProfile();

  Future<Result<SendOtpEntity, Failure>> sendOtp(String phoneNumber);

  Future<Result<String, Failure>> verifyOtp(VerifyOtpParams params);

  Future<Result<CommonApiEntity, Failure>> checkUserExistence(UserParams params);
}
