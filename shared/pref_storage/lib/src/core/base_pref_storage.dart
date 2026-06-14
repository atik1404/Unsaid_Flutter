/// Contract for the unified app storage facade.
///
/// All operations are async because secured values are backed by the platform
/// keychain ([SecureDataSource]), which only exposes asynchronous access.
abstract class BasePrefStorage {
  Future<String> getString(String key);
  int getInt(String key);
  double getDouble(String key);
  bool getBoolean(String key);
  Future<void> write<T>(String key, T value);
  Future<void> delete(String key);
  Future<void> clear();
}
