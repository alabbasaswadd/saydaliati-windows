import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Talks to the backend announcement endpoints. Returns unwrapped payloads and
/// throws clean `AppException`s (envelope + Dio handling live in [ApiClient]).
class AnnouncementRemoteDataSource {
  const AnnouncementRemoteDataSource(this._api);

  final ApiClient _api;

  /// Pending (not-yet-seen) announcements for this pharmacy → `{ items: [...] }`.
  Future<Map<String, dynamic>> pending() async {
    final data = await _api.get(ApiEndpoints.announcementsPending);
    return (data as Map).cast<String, dynamic>();
  }

  /// Mark one as seen so it never shows again.
  Future<void> acknowledge(String id) =>
      _api.post(ApiEndpoints.announcementAck(id));
}
