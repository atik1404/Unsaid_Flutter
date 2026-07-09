import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

abstract class AuthRepository {
  Future<Result<LoginEntity, Failure>> login(LoginParams params);

  Future<Result<LoginEntity, Failure>> signup(SignupParams params);

  Future<Result<SendOtpEntity, Failure>> sendOtp(String phoneNumber);

  Future<Result<String, Failure>> verifyOtp(VerifyOtpParams params);

  Future<Result<String, Failure>> changePassword(ChangePasswordParams params);

  Future<Result<ProfileEntity, Failure>> fetchProfile();

  /// Updates the authenticated user's editable profile fields.
  /// Returns the server success message on success.
  Future<Result<String, Failure>> updateProfile(UpdateProfileParams params);

  /// Permanently deletes the authenticated user's account.
  /// [params] carries the churn reason the user selected.
  /// Returns the server success message on success.
  Future<Result<String, Failure>> deleteAccount(DeleteAccountParams params);

  Future<Result<CommonApiEntity, Failure>> checkUserExistence(UserParams params);
}
