import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pref_storage/src/common/pref_storage_exception.dart';

class SecureDataSource {
  final FlutterSecureStorage _storage;

  const SecureDataSource(this._storage);

  static const _androidOptions = AndroidOptions();

  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    } catch (e) {
      throw PrefStorageException('Failed to write secure value for $key', e);
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    } catch (e) {
      await delete(key);
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    } catch (e) {
      throw PrefStorageException('Failed to delete secure value for $key', e);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    } catch (e) {
      throw PrefStorageException('Failed to delete all secure values', e);
    }
  }
}
