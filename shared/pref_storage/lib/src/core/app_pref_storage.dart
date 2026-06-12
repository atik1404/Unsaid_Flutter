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
  Future<T?> read<T>(String key) async {
    if (_isSecured(key)) {
      return await _secure.read(key) as T?;
    }
    return _prefs.get<T>(key);
  }

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
    await _prefs.clear();
    await _secure.deleteAll();
  }

  bool _isSecured(String key) => PrefKey.securedKey.contains(key);
}
