import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  factory SharedPrefManager() => _instance;
  SharedPrefManager._internal();
  static final SharedPrefManager _instance = SharedPrefManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Write ──────────────────────────────────────────────────────────────────
  Future<bool> setString(String key, String value) =>
      _prefs?.setString(key, value) ?? Future.value(false);

  Future<bool> setInt(String key, int value) =>
      _prefs?.setInt(key, value) ?? Future.value(false);

  Future<bool> setDouble(String key, double value) =>
      _prefs?.setDouble(key, value) ?? Future.value(false);

  Future<bool> setBool(String key, {required bool value}) =>
      _prefs?.setBool(key, value) ?? Future.value(false);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs?.setStringList(key, value) ?? Future.value(false);

  // ── Read ───────────────────────────────────────────────────────────────────
  String getString(String key) => _prefs?.getString(key) ?? '';

  int getInt(String key) => _prefs?.getInt(key) ?? 0;

  double getDouble(String key) => _prefs?.getDouble(key) ?? 0.0;

  bool getBool(String key) => _prefs?.getBool(key) ?? false;

  List<String> getStringList(String key) => _prefs?.getStringList(key) ?? [];

  // ── Existence ──────────────────────────────────────────────────────────────
  bool containsKey(String key) => _prefs?.containsKey(key) ?? false;

  Set<String> get keys => _prefs?.getKeys() ?? {};

  // ── Delete ─────────────────────────────────────────────────────────────────
  Future<bool> remove(String key) => _prefs?.remove(key) ?? Future.value(false);

  Future<bool> clear() => _prefs?.clear() ?? Future.value(false);
}
