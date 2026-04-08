import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  SharedPrefManager(this._prefs);

  final SharedPreferences _prefs;

  // ── Write ──────────────────────────────────────────────────────────────────

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  // ── Read ───────────────────────────────────────────────────────────────────

  String? getString(String key) => _prefs.getString(key);

  int? getInt(String key) => _prefs.getInt(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  bool? getBool(String key) => _prefs.getBool(key);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // ── Existence ──────────────────────────────────────────────────────────────

  bool containsKey(String key) => _prefs.containsKey(key);

  Set<String> get keys => _prefs.getKeys();

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();
}
