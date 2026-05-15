import 'package:pref_storage/pref_storage.dart';
import 'package:pref_storage/src/storage/pref_storage.dart';
import 'package:pref_storage/src/storage/secure_storage.dart';

abstract class StorageRepository {
  Future<void> deleteAllData();

  /// Handles app lifecycle events for storage (fresh install detection,
  /// migrations, cleanup of corrupted data, etc.)
  Future<void> onAppStart();
}

class StorageRepoImpl implements StorageRepository {
  final PrefsDataSource _prefsDataSource;
  final SecureDataSource _secureDataSource;

  StorageRepoImpl(this._prefsDataSource, this._secureDataSource);

  @override
  Future<void> deleteAllData() async {
    await _prefsDataSource.clear();
    await _secureDataSource.deleteAll();
  }

  @override
  Future<void> onAppStart() async {
    await _handleFreshInstall();
  }

  Future<void> _handleFreshInstall() async {
    final hasLaunchedBefore = _prefsDataSource.getBool(PrefKey.isFirstLaunch) ?? false;

    if (!hasLaunchedBefore) {
      // Fresh install or reinstall → wipe leftover secure data
      // (handles iOS Keychain persistence across uninstalls)
      await _secureDataSource.deleteAll();
      await _prefsDataSource.setBool(PrefKey.isFirstLaunch, true);
    }
  }
}
