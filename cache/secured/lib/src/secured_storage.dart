import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  factory SecuredStorage() => _instance;

  SecuredStorage._internal();

  static final SecuredStorage _instance = SecuredStorage._internal();

  static const IOSOptions _iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: _iOSOptions,
  );

  Future<void> write({required String key, required String value}) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }

  Future<String> read({required String key}) => _storage
      .read(
        key: key,
      )
      .then((result) => result ?? '');

  Future<Map<String, String>> readAll() {
    return _storage.readAll().then((result) => result);
  }

  Future<bool> containsKey({required String key}) async {
    final result = await _storage.containsKey(
      key: key,
    );

    return result;
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(
      key: key,
    );
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
