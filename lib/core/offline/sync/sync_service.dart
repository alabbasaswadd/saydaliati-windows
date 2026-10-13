import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/errors/exceptions.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/offline/outbox/offline_write_gate.dart';
import 'package:saydaliati/core/offline/sync/outbox_handlers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';

part 'sync_service.g.dart';

/// Drains the outbox to the server. State is `true` while a drain is in progress
/// (so the UI can show a spinner). Triggered by [DataSyncController] (startup +
/// reconnect, before it re-pulls the catalogs) and manually via [pushNow] — this
/// engine no longer self-triggers, so push-then-pull stays correctly ordered.
///
/// Endpoints per operation `kind` come from [outboxEndpointsProvider], which
/// features populate. This keeps the engine generic — it knows nothing about any
/// specific feature, only how to replay a queued POST.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  @override
  bool build() => false;

  /// Posts every syncable item in order. Items whose dependency is still queued
  /// are deferred to a later pass. Transient failures stay pending (retried
  /// next time); business/validation failures are marked failed for the user.
  Future<void> pushNow() async {
    // Guard set synchronously (before any await) so concurrent triggers
    // — reconnect + startup + manual — can't drain the same items in parallel.
    if (state) return;
    if (!ref.read(effectiveOnlineProvider)) return;
    state = true;

    final tenantId = ref.read(currentTenantKeyProvider);
    final outbox = ref.read(outboxRepositoryProvider);
    final api = ref.read(apiClientProvider);
    final endpoints = ref.read(outboxEndpointsProvider);

    try {
      final items = await outbox.syncable(tenantId);
      if (items.isEmpty) return;

      final unresolved = items.map((e) => e.id).toSet();
      for (final item in items) {
        // Defer an item that depends on one still waiting in the queue.
        if (item.dependsOn != null && unresolved.contains(item.dependsOn)) {
          continue;
        }
        final endpoint = endpoints[item.kind];
        if (endpoint == null) {
          await outbox.markFailed(item.id, error: 'نوع عملية غير معروف');
          continue;
        }
        await outbox.markSyncing(item.id);
        try {
          await api.post(
            endpoint,
            data: jsonDecode(item.payloadJson) as Map<String, dynamic>,
          );
          await outbox.remove(item.id);
          unresolved.remove(item.id);
        } catch (error) {
          if (isTransientError(error)) {
            await outbox.markPending(item.id); // leave for a later retry
          } else {
            final code = switch (error) {
              BusinessException(:final code) => code,
              ValidationException() => 'ValidationError',
              _ => null,
            };
            await outbox.markFailed(
              item.id,
              error: error is AppException ? error.message : error.toString(),
              code: code,
            );
          }
        }
      }
    } finally {
      state = false;
    }
  }
}

/// Reactive count of items waiting in the outbox for the current tenant. Drives
/// a "pending operations" badge; `0` (or loading) means nothing to show.
@riverpod
Stream<int> pendingOperationsCount(Ref ref) {
  final tenantId = ref.watch(currentTenantKeyProvider);
  final outbox = ref.watch(outboxRepositoryProvider);
  return outbox.watch(tenantId).map((rows) => rows.length);
}
