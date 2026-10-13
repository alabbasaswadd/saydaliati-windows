import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/features/warehouses/domain/entities/warehouse.dart';

/// Reads warehouses from `pharmacy-api/Warehouse`.
///
/// The pharmacy operates a single (main) warehouse, so callers normally only
/// need [main]/[mainId] — no manual configuration is required anywhere in the
/// app.
class WarehouseRemoteDataSource {
  const WarehouseRemoteDataSource(this._api);

  final ApiClient _api;

  /// The main/default warehouse (id + name), or null if none exists yet.
  Future<Warehouse?> main() async {
    final data = await _api.get(ApiEndpoints.mainWarehouse);
    if (data is Map) {
      final id = data['id'] as String?;
      if (id == null || id.isEmpty) return null;
      return Warehouse(id: id, name: (data['name'] as String?) ?? '');
    }
    return null;
  }

  /// The id of the main/default warehouse, or null if none exists yet.
  Future<String?> mainId() async => (await main())?.id;
}
