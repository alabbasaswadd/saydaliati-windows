import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/connectivity/connectivity_service.dart';
import 'package:saydaliati/core/providers/core_providers.dart';

part 'work_mode.g.dart';

/// How the app decides online vs. offline.
/// * [auto] — follow the real device connectivity (the default).
/// * [offline] — the user forced offline mode: never hit the network, serve from
///   the local cache and queue writes, even if a connection is available.
enum WorkMode { auto, offline }

const String _kWorkModeKey = 'work_mode';

/// The user-chosen work mode, persisted so it survives restarts. Starts in
/// [WorkMode.auto] and loads the saved value right after build.
@Riverpod(keepAlive: true)
class WorkModeController extends _$WorkModeController {
  @override
  WorkMode build() {
    _load();
    return WorkMode.auto;
  }

  Future<void> _load() async {
    final raw = await ref.read(keyValueStoreProvider).read(_kWorkModeKey);
    if (raw == WorkMode.offline.name) state = WorkMode.offline;
  }

  Future<void> setMode(WorkMode mode) async {
    state = mode;
    await ref.read(keyValueStoreProvider).write(_kWorkModeKey, mode.name);
  }

  Future<void> toggleOffline(bool offline) =>
      setMode(offline ? WorkMode.offline : WorkMode.auto);
}

/// The *effective* connectivity the whole app should act on: `false` when the
/// user forced offline mode, otherwise the real network status. Everything
/// offline-aware (write gate, sync engine, online-only views, refresh button)
/// reads THIS, never the raw [isOnlineProvider] directly.
@riverpod
bool effectiveOnline(Ref ref) {
  final mode = ref.watch(workModeControllerProvider);
  if (mode == WorkMode.offline) return false;
  return ref.watch(isOnlineProvider);
}
