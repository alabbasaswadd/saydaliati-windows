import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/core/session/session_state.dart';
import 'package:saydaliati/core/storage/key_value_store.dart';
import 'package:saydaliati/features/auth/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'session_controller.g.dart';

/// Fast, NON-sensitive mirror of "a session exists" kept in SharedPreferences.
/// The startup gate reads this (instant) instead of the Keystore-backed secure
/// storage, so the splash doesn't wait on the slow first secure-storage read.
const String _kHasSessionPref = 'has_session';

/// Owns the auth session: on startup it decides authenticated-or-not *fast*
/// (from [_kHasSessionPref]), then loads the real bearer token from secure
/// storage in the BACKGROUND. The network interceptor awaits [awaitToken] so
/// every authed request still carries the token; the UI never blocks on it.
///
/// The real token stays in secure storage (unchanged) — only the cheap
/// presence flag moved to SharedPreferences, so no one is logged out.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  /// Resolves to the real bearer token (or null). The UI gate does NOT await
  /// this; the interceptor does.
  Future<String?> _tokenLoad = Future.value(null);

  @override
  Future<SessionState> build() async {
    final store = ref.watch(keyValueStoreProvider);
    final prefs = await SharedPreferences.getInstance(); // fast, no Keystore

    var hasSession = prefs.getBool(_kHasSessionPref);

    // One-time migration for users who signed in before this flag existed:
    // consult secure storage ONCE, cache the flag, so future cold starts never
    // touch the Keystore on the splash path.
    if (hasSession == null) {
      final token = await store.read(StorageKeys.accessToken);
      hasSession = token != null && token.isNotEmpty;
      await prefs.setBool(_kHasSessionPref, hasSession);
      if (hasSession) {
        _tokenLoad = Future.value(token);
        // ignore: unawaited_futures — fills userId/tenantId off the gate.
        _hydrateIdentity(store, token);
        return SessionState.authenticated(token: token);
      }
      return const SessionState.unauthenticated();
    }

    if (!hasSession) {
      _tokenLoad = Future.value(null);
      return const SessionState.unauthenticated();
    }

    // Fast path: a session exists — proceed immediately. Load the real token in
    // the background; it's exposed via [awaitToken] and folded into state once
    // ready so [currentToken] becomes accurate.
    _tokenLoad = store.read(StorageKeys.accessToken);
    // ignore: unawaited_futures
    _hydrateIdentity(store, null);
    return const SessionState.authenticated(token: '');
  }

  /// Loads the real token (+ ids) off the critical path and updates the state.
  Future<void> _hydrateIdentity(KeyValueStore store, String? known) async {
    final token = known ?? await _tokenLoad;
    if (token == null || token.isEmpty) return;
    final userId = await store.read(StorageKeys.userId);
    final tenantId = await store.read(StorageKeys.tenantId);
    // Only update if still authenticated (avoid clobbering a concurrent logout).
    if (state.value is Authenticated) {
      state = AsyncData(SessionState.authenticated(
          token: token, userId: userId, tenantId: tenantId));
    }
  }

  /// The real bearer token once loaded — awaited by the interceptor so authed
  /// requests always carry it even on the first moments after a cold start.
  Future<String?> awaitToken() async {
    await future; // ensure build() finished (so _tokenLoad is assigned)
    return _tokenLoad;
  }

  /// Synchronous best-effort token (may be empty during the brief background
  /// load right after a cold start). Prefer [awaitToken] for requests.
  String? get currentToken => switch (state.value) {
        Authenticated(:final token) => token.isEmpty ? null : token,
        _ => null,
      };

  /// Persists a new session after a successful login/register.
  Future<void> establish({
    required String token,
    String? userId,
    String? tenantId,
  }) async {
    final store = ref.read(keyValueStoreProvider);
    await store.write(StorageKeys.accessToken, token);
    if (userId != null) await store.write(StorageKeys.userId, userId);
    if (tenantId != null) await store.write(StorageKeys.tenantId, tenantId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasSessionPref, true);
    _tokenLoad = Future.value(token);
    state = AsyncData(
      SessionState.authenticated(token: token, userId: userId, tenantId: tenantId),
    );
  }

  /// Ends the session — on explicit logout, or when the API signals 401.
  /// Clears persisted secrets.
  Future<void> clear() async {
    // Guard against redundant clears (e.g. several concurrent 401s).
    if (state.value is Unauthenticated) return;
    final store = ref.read(keyValueStoreProvider);
    await store.delete(StorageKeys.accessToken);
    await store.delete(StorageKeys.userId);
    await store.delete(StorageKeys.tenantId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasSessionPref, false);
    _tokenLoad = Future.value(null);

    // Drop the cached identity/role/permissions so a next login (possibly a
    // different account) never briefly sees the previous user's data.
    ref.invalidate(currentUserProvider);

    // On logout, wipe the per-tenant local cache (medicines, customers,
    // categories, units, currencies, stock…) and its sync timestamps — so no
    // data leaks across accounts and everything re-syncs fresh after the next
    // login. The GLOBAL catalog mirror (tenantId 'global') is deliberately
    // excluded: it is tenant-independent and meant to survive logout — wiping
    // it here forced a full ~22.5k-item re-download on every login, which is
    // what made the catalog look "stuck loading" right after registering.
    // The outbox (unsynced offline writes) is kept too, to avoid silently
    // dropping pending sales. Best-effort.
    try {
      final db = ref.read(appDatabaseProvider);
      await (db.delete(db.cacheEntries)
            ..where((t) => t.tenantId.equals('global').not()))
          .go();
      await (db.delete(db.syncMetaEntries)
            ..where((t) => t.tenantId.equals('global').not()))
          .go();
    } catch (_) {
      // never block logout on a cache-clear failure
    }

    state = const AsyncData(SessionState.unauthenticated());
  }
}
