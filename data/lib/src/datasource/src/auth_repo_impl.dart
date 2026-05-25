import 'package:common/common.dart';
import 'package:data/src/client/client.dart';
import 'package:data/src/dto/dto.dart';
import 'package:data/src/mapper/mapper.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';
import 'package:pref_storage/pref_storage.dart';

final class AuthRepoImpl implements AuthRepository {
  final RestClient _client;
  final AuthStorageRepository _authStorage;
  final UserStorageRepository _userStorage;

  const AuthRepoImpl(this._client, this._authStorage, this._userStorage);

  @override
  Future<Result<ProfileEntity, Failure>> fetchProfile() async {
    final result = await _client.get(
      '/profile',
      options: AuthOptions.authenticated(),
      parser: (data) => ProfileDto.fromJson(data).toEntity(),
    );
    if (result is SuccessResult<ProfileEntity, Failure>) {
      await _userStorage.saveUserName(result.data.name);
      await _userStorage.saveUserEmail(result.data.email);
    }
    return result;
  }

  @override
  Future<Result<LoginEntity, Failure>> login(LoginParams params) async {
    final result = await _client.post(
      '/auth/login',
      data: params.toJson(),
      parser: (data) => LoginDto.fromJson(data).toEntity(),
    );

    if (result is SuccessResult<LoginEntity, Failure>) {
      await Future.wait([
        _authStorage.saveAuthToken(result.data.accessToken),
        _authStorage.saveRefreshToken(result.data.refreshToken),
      ]);
    }

    return result;
  }
}
