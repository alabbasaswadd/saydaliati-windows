import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

class ReportRemoteDataSource {
  const ReportRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> medicineReport(String medicineId) async {
    final data = await _api.get(ApiEndpoints.medicineReport(medicineId));
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> salesSummary(
      String startDate, String endDate) async {
    final data = await _api.get(
      ApiEndpoints.salesSummary,
      queryParameters: {'startDate': startDate, 'endDate': endDate},
    );
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> profitReport(
      String startDate, String endDate, String? currencyId) async {
    final data = await _api.get(
      ApiEndpoints.profitReport,
      queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
        if (currencyId != null && currencyId.isNotEmpty) 'currencyId': currencyId,
      },
    );
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> expiryReport(int daysWindow) async {
    final data = await _api.get(
      ApiEndpoints.expiryReport,
      queryParameters: {'daysWindow': daysWindow},
    );
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> purchasesSummary(
      String startDate, String endDate) async {
    final data = await _api.get(
      ApiEndpoints.purchasesSummary,
      queryParameters: {'startDate': startDate, 'endDate': endDate},
    );
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> inventoryReport() async {
    final data = await _api.get(ApiEndpoints.inventoryReport);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> stocktake() async {
    final data = await _api.get(ApiEndpoints.stocktakeReport);
    return (data as Map).cast<String, dynamic>();
  }
}
