import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Whether the device currently has a network connection. This is a coarse
/// signal (an interface is up), not a guarantee the API is reachable — the sync
/// engine still treats network errors as "stay pending". Emits the current value
/// immediately, then on every connectivity change.
@Riverpod(keepAlive: true)
Stream<bool> onlineStatus(Ref ref) async* {
  final connectivity = Connectivity();
  bool isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  yield isOnline(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(isOnline);
}

/// A synchronous best-effort read of the latest known online status (defaults to
/// online while the first value is still resolving), for callers that can't await.
@riverpod
bool isOnline(Ref ref) => ref.watch(onlineStatusProvider).value ?? true;
