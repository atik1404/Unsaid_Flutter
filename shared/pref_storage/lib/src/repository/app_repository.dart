import 'package:pref_storage/src/common/pref_key.dart';
import 'package:pref_storage/src/storage/pref_storage.dart';

abstract class AppRepository {
  String? getAppLanguage();
  Future<void> saveAppLanguage(String language);

  String? getAppTheme();
  Future<void> saveAppTheme(String theme);
}

class AppRepositoryImpl implements AppRepository {
  final PrefsDataSource _prefsDataSource;

  AppRepositoryImpl(this._prefsDataSource);

  @override
  String? getAppLanguage() => _prefsDataSource.getString(PrefKey.appLanguage);

  @override
  Future<void> saveAppLanguage(String language) => _prefsDataSource.setString(PrefKey.appLanguage, language);

  @override
  String? getAppTheme() => _prefsDataSource.getString(PrefKey.appTheme);

  @override
  Future<void> saveAppTheme(String theme) => _prefsDataSource.setString(PrefKey.appTheme, theme);
}