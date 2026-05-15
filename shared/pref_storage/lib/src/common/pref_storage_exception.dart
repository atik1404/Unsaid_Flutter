class PrefStorageException implements Exception {
  final String message;
  final dynamic originalError;

  PrefStorageException(this.message, [this.originalError]);

  @override
  String toString() => 'PrefStorageException: $message';
}
