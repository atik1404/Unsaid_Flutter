import 'package:pref_storage/src/common/pref_key.dart';
import 'package:pref_storage/src/storage/pref_storage.dart';

abstract class UserRepository {
  String? getUserName();
  Future<void> saveUserName(String name);

  String? getUserEmail();
  Future<void> saveUserEmail(String email);

  String? getUserProfilePicture();
  Future<void> saveUserProfilePicture(String profilePicture);

  String? getUserPhoneNumber();
  Future<void> saveUserPhoneNumber(String phoneNumber);

  String? getUserId();
  Future<void> saveUserId(String userId);

  String? getUserDateOfBirth();
  Future<void> saveUserDateOfBirth(String dateOfBirth);
}

class UserRepositoryImpl implements UserRepository {
  final PrefsDataSource _prefsDataSource;
  UserRepositoryImpl(this._prefsDataSource);

  @override
  String? getUserDateOfBirth() => _prefsDataSource.getString(PrefKey.dateOfBirth);

  @override
  String? getUserEmail() => _prefsDataSource.getString(PrefKey.email);

  @override
  String? getUserId() => _prefsDataSource.getString(PrefKey.userId);

  @override
  String? getUserName() => _prefsDataSource.getString(PrefKey.fullName);

  @override
  String? getUserPhoneNumber() => _prefsDataSource.getString(PrefKey.phoneNumber);

  @override
  String? getUserProfilePicture() => _prefsDataSource.getString(PrefKey.profilePicture);

  @override
  Future<void> saveUserDateOfBirth(String dateOfBirth) => _prefsDataSource.setString(PrefKey.dateOfBirth, dateOfBirth);

  @override
  Future<void> saveUserEmail(String email) => _prefsDataSource.setString(PrefKey.email, email);

  @override
  Future<void> saveUserId(String userId) => _prefsDataSource.setString(PrefKey.userId, userId);

  @override
  Future<void> saveUserName(String name) => _prefsDataSource.setString(PrefKey.fullName, name);

  @override
  Future<void> saveUserPhoneNumber(String phoneNumber) => _prefsDataSource.setString(PrefKey.phoneNumber, phoneNumber);

  @override
  Future<void> saveUserProfilePicture(String profilePicture) => _prefsDataSource.setString(PrefKey.profilePicture, profilePicture);
}
