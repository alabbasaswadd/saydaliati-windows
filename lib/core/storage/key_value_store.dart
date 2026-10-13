/// Abstraction over secure key/value persistence (tokens, small secrets).
///
/// Feature and domain code depend on this interface, not on
/// `flutter_secure_storage`. That keeps the storage backend swappable and makes
/// auth/session logic testable with an in-memory fake.
abstract interface class KeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> clear();
}
