import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';
import 'package:saydaliati/core/offline/outbox/outbox_repository.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/session/session_state.dart';

part 'offline_providers.g.dart';

/// The single [AppDatabase] instance for the app. Kept alive for the whole
/// session and closed on dispose.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

/// The write queue (unposted creates), backed by [appDatabase].
@Riverpod(keepAlive: true)
OutboxRepository outboxRepository(Ref ref) =>
    OutboxRepository(ref.watch(appDatabaseProvider));

/// The tenant key used to scope every local row. Read from the current session.
/// Falls back to a stable placeholder before login so the database is always
/// usable; per-tenant rows never leak across accounts.
@riverpod
String currentTenantKey(Ref ref) {
  final session = ref.watch(sessionControllerProvider).value;
  return switch (session) {
    Authenticated(:final tenantId) => tenantId ?? 'default',
    _ => 'default',
  };
}
