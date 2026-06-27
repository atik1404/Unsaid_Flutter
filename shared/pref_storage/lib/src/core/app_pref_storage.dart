import 'package:pref_storage/pref_storage.dart';
import 'package:pref_storage/src/core/base_pref_storage.dart';
import 'package:pref_storage/src/storage/pref_storage.dart';
import 'package:pref_storage/src/storage/secure_storage.dart';

/// Single entry point for reading/writing app storage.
///
/// Keys listed in [PrefKey.securedKey] are routed to the encrypted
/// [SecureDataSource]; everything else goes to [PrefsDataSource].
///
/// Note: secured values are always stored as [String], because the platform
/// keychain only supports string values. Use [String]-typed values for
/// secured keys.
final class AppPrefStorage extends BasePrefStorage {
  final PrefsDataSource _prefs;
  final SecureDataSource _secure;

  AppPrefStorage(this._prefs, this._secure);

  @override
  Future<void> write<T>(String key, T value) {
    if (_isSecured(key)) {
      return _secure.write(key, value.toString());
    }
    return _prefs.set<T>(key, value);
  }

  @override
  Future<void> delete(String key) {
    return _isSecured(key) ? _secure.delete(key) : _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    //fetch app language and app theme before clear storage
    final appLanguage = await getString(PrefKey.appLanguage);
    final appTheme = await getString(PrefKey.appTheme);
    //clear storage
    await _prefs.clear();
    await _secure.deleteAll();
    //set app language and app theme
    await write(PrefKey.appLanguage, appLanguage);
    await write(PrefKey.appTheme, appTheme);
  }

  bool _isSecured(String key) => PrefKey.securedKey.contains(key);

  @override
  bool getBoolean(String key) {
    return _prefs.get<bool>(key) ?? false;
  }

  @override
  double getDouble(String key) {
    return _prefs.get<double>(key) ?? 0.0;
  }

  @override
  int getInt(String key) {
    return _prefs.get<int>(key) ?? 0;
  }

  @override
  Future<String> getString(String key) async {
    if (_isSecured(key)) {
      final value = await _secure.read(key);
      return value ?? '';
    }
    return _prefs.get<String>(key) ?? '';
  }
}
