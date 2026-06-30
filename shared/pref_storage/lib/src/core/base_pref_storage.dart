/// Contract for the unified app storage facade.
///
/// Plain values are backed by [SharedPreferences], which is read synchronously.
/// Only secured values are backed by the platform keychain ([SecureDataSource]),
/// which exposes asynchronous access — hence [getSecureString] returns a Future
/// while the other reads do not.
abstract class BasePrefStorage {
  /// Reads a plain (non-secured) string value synchronously.
  String getString(String key);

  /// Reads a secured string value (keychain-backed), hence asynchronous.
  Future<String> getSecureString(String key);

  int getInt(String key);
  double getDouble(String key);
  bool getBoolean(String key);
  Future<void> write<T>(String key, T value);
  Future<void> delete(String key);
  Future<void> clear();
}
