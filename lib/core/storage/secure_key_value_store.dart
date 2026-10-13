import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saydaliati/core/storage/key_value_store.dart';

/// [KeyValueStore] backed by platform secure storage (Keychain / Keystore).
///
/// A thin, real implementation — it holds no business logic and no network
/// concerns.
class SecureKeyValueStore implements KeyValueStore {
  const SecureKeyValueStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
