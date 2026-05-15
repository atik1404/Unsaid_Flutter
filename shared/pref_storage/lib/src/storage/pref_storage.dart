import 'package:pref_storage/src/common/pref_storage_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsDataSource {
  final SharedPreferences _prefs;

  const PrefsDataSource(this._prefs);

  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw PrefStorageException('Failed to save string for $key', e);
    }
  }

  String? getString(String key) => _prefs.getString(key) ;

  Future<void> setInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw PrefStorageException('Failed to save int for $key', e);
    }
  }

  int? getInt(String key) => _prefs.getInt(key) ?? 0;

  Future<void> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw PrefStorageException('Failed to save bool for $key', e);
    }
  }

  bool? getBool(String key) => _prefs.getBool(key) ?? false;

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw PrefStorageException('Failed to remove value for $key', e);
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw PrefStorageException('Failed to clear preferences', e);
    }
  }
}
