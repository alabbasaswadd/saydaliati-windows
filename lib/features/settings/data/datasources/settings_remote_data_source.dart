import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Reads/writes key-value settings via `pharmacy-api/Setting`.
class SettingsRemoteDataSource {
  const SettingsRemoteDataSource(this._api);

  final ApiClient _api;

  /// The raw string value for [key], or null if the row has no value.
  /// A missing key surfaces as a `NotFoundException` (handled by the repository).
  Future<String?> getValue(String key) async {
    final data = await _api.get(ApiEndpoints.settingByKey(key));
    if (data is Map) return data['value'] as String?;
    return null;
  }

  Future<void> setValue(String key, String value) =>
      _api.post(ApiEndpoints.settings, data: {'key': key, 'value': value});
}
