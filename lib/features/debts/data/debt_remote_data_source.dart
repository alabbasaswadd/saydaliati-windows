import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// ذمم الأطراف فوق `pharmacy-api/Ledger`.
class DebtRemoteDataSource {
  const DebtRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> receivables() => _list(
        ApiEndpoints.ledgerReceivables,
      );

  Future<List<Map<String, dynamic>>> payables() => _list(
        ApiEndpoints.ledgerPayables,
      );

  Future<Map<String, dynamic>> settle(Map<String, dynamic> body) async {
    final data = await _api.post(ApiEndpoints.ledgerSettle, data: body);
    return (data as Map).cast<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> _list(String path) async {
    final data = await _api.get(path);
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
