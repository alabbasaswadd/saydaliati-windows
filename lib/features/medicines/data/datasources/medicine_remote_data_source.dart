import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Reads/writes medicines. `GET pharmacy-api/Medicine?name=&limit=&offset=`
/// requires a `name` query param (pass '' for all).
class MedicineRemoteDataSource {
  const MedicineRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list({
    String name = '',
    int? limit,
    int? offset,
  }) async {
    final data = await _api.get(
      ApiEndpoints.medicines,
      queryParameters: {
        'name': name,
        'limit': limit ?? 1000,
        'offset': offset ?? 0,
      },
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  /// A single medicine by id (used to refresh one row after an edit/pricing
  /// instead of re-pulling the whole catalog).
  Future<Map<String, dynamic>> getById(String id) async {
    final data = await _api.get(ApiEndpoints.medicineById(id));
    return (data as Map).cast<String, dynamic>();
  }

  /// Creates a medicine and returns its new server id (from the `{ id }` payload).
  Future<String> create(Map<String, dynamic> body) async {
    final data = await _api.post(ApiEndpoints.medicines, data: body);
    return data is Map ? (data['id']?.toString() ?? '') : '';
  }

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.medicineById(id), data: body);

  /// Quick pricing: update only the sale prices of a medicine's units.
  /// [prices] maps unitId → salePrice.
  Future<void> updatePrices(String id, Map<String, double> prices) => _api.put(
        ApiEndpoints.medicinePrices(id),
        data: {
          'prices': [
            for (final e in prices.entries)
              {'unitId': e.key, 'salePrice': e.value},
          ],
        },
      );

  Future<void> delete(String id) => _api.delete(ApiEndpoints.medicineById(id));

  /// Syncs the pharmacy's own medicine prices from the global catalog (only the
  /// medicines that have auto-sync enabled). Returns the summary map
  /// `{ total, updated, skippedDisabled, noMatch }`.
  Future<Map<String, dynamic>> syncPrices() async {
    final data = await _api.post(ApiEndpoints.medicineSyncPrices);
    return data is Map ? data.cast<String, dynamic>() : <String, dynamic>{};
  }

  /// Enables/disables auto-price-sync for a single medicine.
  Future<void> setAutoPriceSync(String id, bool enabled) =>
      _api.post(ApiEndpoints.medicineAutoPriceSync(id), data: {'enabled': enabled});

  /// Assigns a barcode to an existing medicine; returns the updated medicine JSON.
  Future<Map<String, dynamic>> setBarcode(String id, String barcode) async {
    final data = await _api.post(
      ApiEndpoints.medicineBarcode(id),
      data: {'barcode': barcode},
    );
    return (data as Map).cast<String, dynamic>();
  }
}
