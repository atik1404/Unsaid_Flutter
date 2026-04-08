import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  SecuredStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _androidOptions = AndroidOptions.defaultOptions;

  static const _iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  Future<void> write({required String key, required String value}) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<String> read({required String key}) => _storage
      .read(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iOSOptions,
      )
      .then((result) => result ?? '');

  Future<Map<String, String>> readAll() {
    return _storage
        .readAll(
          aOptions: _androidOptions,
          iOptions: _iOSOptions,
        )
        .then((result) => result);
  }

  Future<bool> containsKey({required String key}) async {
    final result = await _storage.containsKey(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );

    return result;
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll(aOptions: _androidOptions, iOptions: _iOSOptions);
  }
}
