import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:pref_storage/src/storage/pref_storage.dart';
import 'package:pref_storage/src/storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefStorageDi {
  PrefStorageDi._();

  static Future<void> init(GetIt getIt) async {
    // External dependencies
    final prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();

    // Data sources
    getIt.registerLazySingleton<PrefsDataSource>(() => PrefsDataSource(prefs));
    getIt.registerLazySingleton<SecureDataSource>(() => SecureDataSource(secureStorage));
    getIt.registerLazySingleton<AppPrefStorage>(() => AppPrefStorage(getIt<PrefsDataSource>(), getIt<SecureDataSource>()));
  }
}
