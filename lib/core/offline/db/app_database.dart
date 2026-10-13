import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// A generic cache row for reference/catalog data (products, categories, units,
/// suppliers, …). The full wire DTO is kept as JSON in [payloadJson] so we reuse
/// each feature's existing `fromJson/toJson`; [name]/[code]/[parentId] are
/// lightweight indexed columns for offline search and filtering without decoding
/// JSON. Everything is scoped by [tenantId].
class CacheEntries extends Table {
  /// The entity family (e.g. products, categories, units).
  TextColumn get entityType => text()();
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get name => text().nullable()();
  TextColumn get code => text().nullable()();
  TextColumn get parentId => text().nullable()();
  TextColumn get payloadJson => text()();
  IntColumn get syncedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {entityType, id, tenantId};
}

/// The write queue. Each row is one pending create/update the app will POST/PUT
/// when it is online. [id] is the client-generated entity GUID (so re-sending is
/// idempotent), and [payloadJson] is the exact request body to send.
class OutboxEntries extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();

  /// A label for the operation, e.g. createSale | updateProduct.
  TextColumn get kind => text()();
  TextColumn get payloadJson => text()();

  /// Another outbox id that must sync first (e.g. a sale targeting an offline
  /// product create).
  TextColumn get dependsOn => text().nullable()();

  /// pending | syncing | failed | done.
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  /// Business-error code from the API (match by code, never by text).
  TextColumn get serverErrorCode => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Bookkeeping for the last successful catalog pull, per type and tenant.
class SyncMetaEntries extends Table {
  /// The cached entity type (products, categories, …).
  TextColumn get key => text()();
  TextColumn get tenantId => text()();
  IntColumn get lastPullAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {key, tenantId};
}

@DriftDatabase(tables: [CacheEntries, OutboxEntries, SyncMetaEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 1;

  /// Opens (or creates) the on-device SQLite store. `drift_flutter` handles the
  /// platform-specific path and native libraries. On the web it needs the
  /// `web` options pointing at the drift worker + sqlite3 WASM assets, which
  /// ship in `web/` (served next to the app, relative to its base href).
  static QueryExecutor _open() => driftDatabase(
        name: 'saydaliati_offline',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );
}
