import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// Persistence for the write queue (the "unposted" items). Each row is one
/// pending create the app will POST when online. All operations are scoped by
/// tenant; the reactive [watch] feeds any "pending operations" UI.
class OutboxRepository {
  const OutboxRepository(this._db);

  final AppDatabase _db;

  int get _now => DateTime.now().millisecondsSinceEpoch;

  /// Adds (or replaces, by id) a pending operation.
  Future<void> enqueue({
    required String id,
    required String tenantId,
    required String kind,
    required Map<String, dynamic> payload,
    String? dependsOn,
  }) {
    return _db.into(_db.outboxEntries).insertOnConflictUpdate(
          OutboxEntriesCompanion.insert(
            id: id,
            tenantId: tenantId,
            kind: kind,
            payloadJson: jsonEncode(payload),
            dependsOn: Value(dependsOn),
            createdAt: _now,
            updatedAt: _now,
          ),
        );
  }

  /// All queue rows for a tenant, oldest first — reactive for the UI.
  Stream<List<OutboxEntry>> watch(String tenantId) {
    return (_db.select(_db.outboxEntries)
          ..where((t) => t.tenantId.equals(tenantId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// Items eligible to sync now, oldest first. Includes `syncing` so an item
  /// orphaned by a crash mid-sync is retried — safe because re-posting the same
  /// client id is idempotent.
  Future<List<OutboxEntry>> syncable(String tenantId) {
    return (_db.select(_db.outboxEntries)
          ..where((t) =>
              t.tenantId.equals(tenantId) &
              t.status.isIn(const ['pending', 'failed', 'syncing']))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  Future<int> pendingCount(String tenantId) async {
    final rows = await (_db.select(_db.outboxEntries)
          ..where((t) => t.tenantId.equals(tenantId)))
        .get();
    return rows.length;
  }

  Future<void> markSyncing(String id) =>
      _patch(id, const OutboxEntriesCompanion(status: Value('syncing')));

  /// Returns a failed item to pending for a later retry (or a manual one).
  Future<void> markPending(String id) => _patch(
        id,
        const OutboxEntriesCompanion(
          status: Value('pending'),
          lastError: Value(null),
          serverErrorCode: Value(null),
        ),
      );

  Future<void> markFailed(String id, {String? error, String? code}) async {
    final row = await _byId(id);
    await _patch(
      id,
      OutboxEntriesCompanion(
        status: const Value('failed'),
        attempts: Value((row?.attempts ?? 0) + 1),
        lastError: Value(error),
        serverErrorCode: Value(code),
      ),
    );
  }

  /// Edits the queued request body (used when correcting an item before sync).
  /// Resets the item to `pending` and clears any prior error, so a corrected
  /// item is retried automatically on the next drain.
  Future<void> updatePayload(String id, Map<String, dynamic> payload) => _patch(
        id,
        OutboxEntriesCompanion(
          payloadJson: Value(jsonEncode(payload)),
          status: const Value('pending'),
          lastError: const Value(null),
          serverErrorCode: const Value(null),
        ),
      );

  Future<void> remove(String id) =>
      (_db.delete(_db.outboxEntries)..where((t) => t.id.equals(id))).go();

  /// One queue row by id (for the detail/edit screen), or null if it's gone.
  Future<OutboxEntry?> find(String id) => _byId(id);

  Future<OutboxEntry?> _byId(String id) =>
      (_db.select(_db.outboxEntries)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> _patch(String id, OutboxEntriesCompanion patch) async {
    await (_db.update(_db.outboxEntries)..where((t) => t.id.equals(id)))
        .write(patch.copyWith(updatedAt: Value(_now)));
  }
}
