import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// فوق `pharmacy-api/JournalEntry` — عرض/إنشاء/حذف السندات.
class VoucherRemoteDataSource {
  const VoucherRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(
      ApiEndpoints.journalEntries,
      queryParameters: {'limit': 200, 'offset': 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.journalEntries, data: body);

  Future<void> delete(String id) => _api.delete(ApiEndpoints.journalEntryById(id));
}
