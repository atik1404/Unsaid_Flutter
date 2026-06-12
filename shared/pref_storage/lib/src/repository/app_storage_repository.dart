import 'package:pref_storage/src/common/pref_key.dart';
import 'package:pref_storage/src/storage/pref_storage.dart';

@Deprecated('Use app_storage_repository instead of directly using AppPrefStorage')
abstract class AppStorageRepository {
  String? getAppLanguage();
  Future<void> saveAppLanguage(String language);

  String? getAppTheme();
  Future<void> saveAppTheme(String theme);
}

class AppStorageRepoImpl implements AppStorageRepository {
  final PrefsDataSource _prefsDataSource;

  AppStorageRepoImpl(this._prefsDataSource);

  @override
  String? getAppLanguage() => _prefsDataSource.getString(PrefKey.appLanguage);

  @override
  Future<void> saveAppLanguage(String language) => _prefsDataSource.setString(PrefKey.appLanguage, language);

  @override
  String? getAppTheme() => _prefsDataSource.getString(PrefKey.appTheme);

  @override
  Future<void> saveAppTheme(String theme) => _prefsDataSource.setString(PrefKey.appTheme, theme);
}
