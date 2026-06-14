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

  String? getString(String key) => _prefs.getString(key);

  Future<void> setInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw PrefStorageException('Failed to save int for $key', e);
    }
  }

  int? getInt(String key) => _prefs.getInt(key);

  Future<void> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw PrefStorageException('Failed to save bool for $key', e);
    }
  }

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw PrefStorageException('Failed to save double for $key', e);
    }
  }

  double? getDouble(String key) => _prefs.getDouble(key);

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

/// Typed read/write helpers so callers can use a single generic API instead of
/// the per-type `getString`/`setInt`/... methods.
extension TypedPrefs on PrefsDataSource {
  T? get<T>(String key) {
    if (T == String) return getString(key) as T?;
    if (T == int) return getInt(key) as T?;
    if (T == bool) return getBool(key) as T?;
    if (T == double) return getDouble(key) as T?;
    throw UnsupportedError('Unsupported type: $T');
  }

  Future<void> set<T>(String key, T value) {
    if (value is String) return setString(key, value);
    if (value is int) return setInt(key, value);
    if (value is bool) return setBool(key, value);
    if (value is double) return setDouble(key, value);
    throw UnsupportedError('Unsupported type: ${value.runtimeType}');
  }
}
