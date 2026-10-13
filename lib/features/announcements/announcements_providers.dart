import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/announcements/data/announcement_remote_data_source.dart';
import 'package:saydaliati/features/announcements/domain/announcement.dart';

part 'announcements_providers.g.dart';

@riverpod
AnnouncementRemoteDataSource announcementRemoteDataSource(Ref ref) =>
    AnnouncementRemoteDataSource(ref.watch(apiClientProvider));

/// Fetches the pending announcements once (on app open) and acknowledges them as
/// they're shown. Not kept alive — it's a transient, fire-once flow driven by the
/// shell; failures are swallowed so they never block the app.
@riverpod
class PendingAnnouncements extends _$PendingAnnouncements {
  @override
  Future<List<Announcement>> build() async {
    final raw = await ref.read(announcementRemoteDataSourceProvider).pending();
    return ((raw['items'] as List?) ?? const [])
        .map((e) => Announcement.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// Mark one as seen on the server (best-effort) and drop it from the list.
  Future<void> acknowledge(String id) async {
    try {
      await ref.read(announcementRemoteDataSourceProvider).acknowledge(id);
    } catch (_) {
      // Best-effort: even if the ack call fails, don't re-show it this session.
    }
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData(current.where((a) => a.id != id).toList());
    }
  }
}
