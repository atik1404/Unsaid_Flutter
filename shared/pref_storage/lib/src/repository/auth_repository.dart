import 'package:pref_storage/src/common/pref_key.dart';
import 'package:pref_storage/src/storage/secure_storage.dart';

abstract class AuthRepository {
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);

  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);

  Future<bool?> getFirstLaunch();
  Future<void> saveFirstLaunch(bool value);
}

class AuthRepositoryImpl implements AuthRepository {
  final SecureDataSource _secureDataSource;

  AuthRepositoryImpl(this._secureDataSource);

  @override
  Future<String?> getAuthToken() => _secureDataSource.read(PrefKey.accessToken);

  @override
  Future<bool?> getFirstLaunch() => _secureDataSource.read(PrefKey.isFirstLaunch).then((value) => value == 'true');

  @override
  Future<String?> getRefreshToken() => _secureDataSource.read(PrefKey.refreshToken);

  @override
  Future<void> saveAuthToken(String token) => _secureDataSource.write(PrefKey.accessToken, token);

  @override
  Future<void> saveFirstLaunch(bool value) => _secureDataSource.write(PrefKey.isFirstLaunch, value.toString());

  @override
  Future<void> saveRefreshToken(String token) => _secureDataSource.write(PrefKey.refreshToken, token);
}
