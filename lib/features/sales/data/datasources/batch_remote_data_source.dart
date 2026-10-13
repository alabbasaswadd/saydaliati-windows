import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/features/sales/domain/entities/medicine_batch.dart';

/// Reads available stock batches for a medicine (to pick the expiry in the POS).
class BatchRemoteDataSource {
  const BatchRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<MedicineBatch>> forMedicine(
      String medicineId, String warehouseId) async {
    final data = await _api.get(
      ApiEndpoints.medicineBatches(medicineId),
      queryParameters: {'warehouseId': warehouseId},
    );
    final list = (data as List?) ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(MedicineBatch.fromJson)
        .toList();
  }
}
