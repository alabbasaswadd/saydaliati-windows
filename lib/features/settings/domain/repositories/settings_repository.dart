import 'package:saydaliati/core/result/result.dart';

/// Key-value settings stored on the server (`pharmacy-api/Setting`).
abstract interface class SettingsRepository {
  /// The value for [key], or null if unset.
  Future<Result<String?>> getValue(String key);

  /// Creates/updates [key] with [value].
  Future<Result<void>> setValue(String key, String value);
}
