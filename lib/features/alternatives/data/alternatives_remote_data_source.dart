import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Fetches a medicine's alternatives (same active ingredient) from the backend.
/// Returns raw medicine JSON (same shape as the medicines list) — reuse the
/// medicine DTO/mapper to decode.
class AlternativesRemoteDataSource {
  const AlternativesRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> forMedicine(String medicineId) async {
    final data = await _api.get(ApiEndpoints.medicineAlternatives(medicineId));
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
