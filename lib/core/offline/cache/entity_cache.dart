import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// Generic read/write access to the [CacheEntries] table for one entity type and
/// tenant. Stores each item's wire JSON (via its `toJson`) and rebuilds it with
/// its `fromJson`, so a feature's local data source stays a thin wrapper. The
/// optional [nameOf]/[codeOf]/[parentOf] fill indexed columns for offline search.
class EntityCache<T> {
  const EntityCache({
    required this.db,
    required this.tenantId,
    required this.entityType,
    required this.fromJson,
    required this.toJson,
    required this.idOf,
    this.nameOf,
    this.codeOf,
    this.parentOf,
  });

  final AppDatabase db;
  final String tenantId;
  final String entityType;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final String Function(T) idOf;
  final String? Function(T)? nameOf;
  final String? Function(T)? codeOf;
  final String? Function(T)? parentOf;

  Expression<bool> get _scope =>
      db.cacheEntries.entityType.equals(entityType) &
      db.cacheEntries.tenantId.equals(tenantId);

  T _decode(CacheEntry row) =>
      fromJson(jsonDecode(row.payloadJson) as Map<String, dynamic>);

  Future<List<T>> getAll() async {
    final rows = await (db.select(db.cacheEntries)..where((_) => _scope)).get();
    return rows.map(_decode).toList();
  }

  /// Rows whose indexed [name] or [code] contains [term] (case-insensitive
  /// substring), optionally scoped to [parentId]. Filters at the SQL level so only
  /// the matching payloads are decoded. Requires [nameOf]/[codeOf] to have
  /// populated those columns.
  Future<List<T>> search(String term, {String? parentId, int? limit}) async {
    final like = '%${term.trim()}%';
    final q = db.select(db.cacheEntries)
      ..where((t) {
        var cond = _scope & (t.name.like(like) | t.code.like(like));
        if (parentId != null) cond = cond & t.parentId.equals(parentId);
        return cond;
      });
    if (limit != null) q.limit(limit);
    final rows = await q.get();
    return rows.map(_decode).toList();
  }

  /// A limited page of all cached rows (no filter) — for a browsable default
  /// list without decoding the whole table.
  Future<List<T>> page({int limit = 100, int offset = 0}) async {
    final q = db.select(db.cacheEntries)..where((_) => _scope);
    q.limit(limit, offset: offset);
    final rows = await q.get();
    return rows.map(_decode).toList();
  }

  /// Distinct non-empty [parentId] values with their row counts — offline
  /// grouping (e.g. catalog drugs grouped by manufacturer stored in parentId).
  Future<List<({String name, int count})>> groupByParent() async {
    final cnt = db.cacheEntries.id.count();
    final q = db.selectOnly(db.cacheEntries)
      ..addColumns([db.cacheEntries.parentId, cnt])
      ..where(_scope & db.cacheEntries.parentId.isNotNull())
      ..groupBy([db.cacheEntries.parentId]);
    final rows = await q.get();
    final out = <({String name, int count})>[];
    for (final r in rows) {
      final name = r.read(db.cacheEntries.parentId) ?? '';
      if (name.isEmpty) continue;
      out.add((name: name, count: r.read(cnt) ?? 0));
    }
    out.sort((a, b) => a.name.compareTo(b.name));
    return out;
  }

  /// All cached rows under one [parentId] (e.g. all drugs of a manufacturer).
  Future<List<T>> byParent(String parentId, {int? limit}) async {
    final q = db.select(db.cacheEntries)
      ..where((t) => _scope & t.parentId.equals(parentId));
    if (limit != null) q.limit(limit);
    final rows = await q.get();
    return rows.map(_decode).toList();
  }

  /// Number of cached rows for this type/tenant — a cheap "is the cache warm?"
  /// check that avoids decoding every payload.
  Future<int> count() async {
    final countExp = db.cacheEntries.id.count();
    final query = db.selectOnly(db.cacheEntries)
      ..addColumns([countExp])
      ..where(_scope);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<bool> get isEmpty async => (await count()) == 0;

  /// Count of cached rows whose indexed [code] is one of [codes] — filtered at
  /// the SQL level (the indexed `code` column), no payload decoded. For "how
  /// many of these do I already have" checks against a large mirror.
  Future<int> countByCodes(Iterable<String> codes) async {
    final list = codes.toList();
    if (list.isEmpty) return 0;
    final countExp = db.cacheEntries.id.count();
    final query = db.selectOnly(db.cacheEntries)
      ..addColumns([countExp])
      ..where(_scope & db.cacheEntries.code.isIn(list));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// When this type was last pulled from the server for this tenant (null = never).
  Future<DateTime?> lastPulledAt() async {
    final row = await (db.select(db.syncMetaEntries)
          ..where((t) => t.key.equals(entityType) & t.tenantId.equals(tenantId)))
        .getSingleOrNull();
    return row == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(row.lastPullAt);
  }

  /// Records "just refreshed from the server, now".
  Future<void> markPulled() async {
    await db.into(db.syncMetaEntries).insertOnConflictUpdate(
          SyncMetaEntriesCompanion.insert(
            key: entityType,
            tenantId: tenantId,
            lastPullAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  /// Inserts-or-replaces a single item (write-through after a create/update).
  Future<void> upsert(T item) => upsertAll([item]);

  /// Removes one cached row by id (write-through after a delete).
  Future<void> removeById(String id) async {
    await (db.delete(db.cacheEntries)
          ..where((t) => _scope & t.id.equals(id)))
        .go();
  }

  Future<T?> getById(String id) async {
    final row = await (db.select(db.cacheEntries)
          ..where((t) => _scope & t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _decode(row);
  }

  CacheEntriesCompanion _companion(T e, int now) => CacheEntriesCompanion.insert(
        entityType: entityType,
        id: idOf(e),
        tenantId: tenantId,
        name: Value(nameOf?.call(e)),
        code: Value(codeOf?.call(e)),
        parentId: Value(parentOf?.call(e)),
        payloadJson: jsonEncode(toJson(e)),
        syncedAt: now,
      );

  /// Replaces the whole cached set for this type/tenant (a full refresh). Use for
  /// endpoints that return the complete list.
  Future<void> replaceAll(List<T> items) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.transaction(() async {
      await (db.delete(db.cacheEntries)..where((_) => _scope)).go();
      await db.batch((b) {
        b.insertAll(db.cacheEntries, items.map((e) => _companion(e, now)));
      });
    });
  }

  /// Inserts-or-replaces the given items without deleting others. Use for paged
  /// endpoints so earlier pages aren't wiped.
  Future<void> upsertAll(List<T> items) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.batch((b) {
      b.insertAll(
        db.cacheEntries,
        items.map((e) => _companion(e, now)),
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
