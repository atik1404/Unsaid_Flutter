/// Contract for the unified app storage facade.
///
/// All operations are async because secured values are backed by the platform
/// keychain ([SecureDataSource]), which only exposes asynchronous access.
abstract class BasePrefStorage {
  Future<T?> read<T>(String key);
  Future<void> write<T>(String key, T value);
  Future<void> delete(String key);
  Future<void> clear();
}
