import 'package:common/common.dart';
import 'package:data/src/client/client.dart';
import 'package:data/src/dto/dto.dart';
import 'package:data/src/mapper/mapper.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';
import 'package:pref_storage/pref_storage.dart';

final class AuthRepoImpl implements AuthRepository {
  final RestClient _client;
  final AppPrefStorage _prefStorage;

  const AuthRepoImpl(this._client, this._prefStorage);

  @override
  Future<Result<LoginEntity, Failure>> login(LoginParams params) async {
    final result = await _client.post(
      '/auth/login',
      data: params.toJson(),
      parser: (data) => LoginDto.fromJson(data).toEntity(),
    );

    if (result is SuccessResult<LoginEntity, Failure>) {
      await Future.wait([
        _prefStorage.write(PrefKey.accessToken, result.data.accessToken),
        _prefStorage.write(PrefKey.refreshToken, result.data.refreshToken),
        _prefStorage.write(PrefKey.loginStatus, true),
      ]);
    }

    return result;
  }

  @override
  Future<Result<LoginEntity, Failure>> signup(SignupParams params) async {
    final result = await _client.post(
      '/auth/signup',
      data: params.toJson(),
      parser: (data) => SignupDto.fromJson(data).toEntity(),
    );

    if (result is SuccessResult<LoginEntity, Failure>) {
      await Future.wait([
        _prefStorage.write(PrefKey.accessToken, result.data.accessToken),
        _prefStorage.write(PrefKey.refreshToken, result.data.refreshToken),
        _prefStorage.write(PrefKey.loginStatus, true),
      ]);
    }

    return result;
  }

  @override
  Future<Result<SendOtpEntity, Failure>> sendOtp(String phoneNumber) {
    final result = _client.post(
      '/auth/send-otp',
      data: {'phone': phoneNumber},
      parser: (data) => SendOtpDto.fromJson(data).toEntity(),
    );

    return result;
  }

  @override
  Future<Result<String, Failure>> verifyOtp(VerifyOtpParams params) {
    final result = _client.post(
      '/auth/verify-otp',
      data: params.toJson(),
      parser: (data) => VerifyOtpDto.fromJson(data).toEntity(),
    );

    return result;
  }

  @override
  Future<Result<String, Failure>> changePassword(ChangePasswordParams params) {
    // Authenticated endpoint — the interceptor attaches the Bearer token.
    final result = _client.post(
      '/auth/change-password',
      data: params.toJson(),
      options: AuthOptions.authenticated(),
      parser: (data) => ChangePasswordDto.fromJson(data).toEntity(),
    );

    return result;
  }

  @override
  Future<Result<ProfileEntity, Failure>> fetchProfile() async {
    final result = await _client.get(
      '/profile',
      options: AuthOptions.authenticated(),
      parser: (data) => ProfileDto.fromJson(data).toEntity(),
    );
    if (result is SuccessResult<ProfileEntity, Failure>) {
      final identity = result.data.identity;

      await _prefStorage.write(PrefKey.anonymousName, identity.fullName);
      await _prefStorage.write(PrefKey.email, identity.email);
      await _prefStorage.write(PrefKey.phoneNumber, identity.phoneE164);
      await _prefStorage.write(PrefKey.profilePicture, result.data.avatarSeed.toString());
      await _prefStorage.write(PrefKey.userId, result.data.id);
      await _prefStorage.write(PrefKey.dateOfBirth, result.data.identity.dateOfBirth.toString());
    }
    return result;
  }

  @override
  Future<Result<String, Failure>> deleteAccount() {
    // Authenticated endpoint — the interceptor attaches the Bearer token.
    // Only the success message is surfaced to the domain layer.
    final result = _client.delete(
      '/profile',
      options: AuthOptions.authenticated(),
      parser: (data) => DeleteAccountDto.fromJson(data).toEntity(),
    );

    return result;
  }

  @override
  Future<Result<CommonApiEntity, Failure>> checkUserExistence(UserParams params) async {
    final result = await _client.post(
      '/auth/check-user',
      data: params.toJson(),
      parser: (data) => CommonDto.fromJson(data).toEntity(),
    );
    return result;
  }
}
