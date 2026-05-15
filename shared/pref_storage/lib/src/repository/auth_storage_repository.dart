import 'package:pref_storage/src/common/pref_key.dart';
import 'package:pref_storage/src/storage/secure_storage.dart';

abstract class AuthStorageRepository {
  Future<String> getAuthToken();
  Future<void> saveAuthToken(String token);

  Future<String> getRefreshToken();
  Future<void> saveRefreshToken(String token);

  Future<bool> getFirstLaunch();
  Future<void> saveFirstLaunch(bool value);

  Future<bool> getLoginStatus();
}

class AuthStorageRepoImpl implements AuthStorageRepository {
  final SecureDataSource _secureDataSource;

  AuthStorageRepoImpl(this._secureDataSource);

  @override
  Future<String> getAuthToken() => _secureDataSource.read(PrefKey.accessToken).then((value) => value ?? '');

  @override
  Future<bool> getFirstLaunch() => _secureDataSource.read(PrefKey.isFirstLaunch).then((value) => value == 'true');

  @override
  Future<String> getRefreshToken() => _secureDataSource.read(PrefKey.refreshToken).then((value) => value ?? '');

  @override
  Future<void> saveAuthToken(String token) => _secureDataSource.write(PrefKey.accessToken, token);

  @override
  Future<void> saveFirstLaunch(bool value) => _secureDataSource.write(PrefKey.isFirstLaunch, value.toString());

  @override
  Future<void> saveRefreshToken(String token) => _secureDataSource.write(PrefKey.refreshToken, token);

  @override
  Future<bool> getLoginStatus() {
    final accessTokenFuture = _secureDataSource.read(PrefKey.accessToken).then((value) => value ?? '');
    final refreshTokenFuture = _secureDataSource.read(PrefKey.refreshToken).then((value) => value ?? '');

    return Future.wait([accessTokenFuture, refreshTokenFuture]).then((tokens) {
      final accessToken = tokens[0];
      final refreshToken = tokens[1];
      return accessToken.isNotEmpty && refreshToken.isNotEmpty;
    });
  }
}
