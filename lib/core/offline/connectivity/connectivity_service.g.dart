// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the device currently has a network connection. This is a coarse
/// signal (an interface is up), not a guarantee the API is reachable — the sync
/// engine still treats network errors as "stay pending". Emits the current value
/// immediately, then on every connectivity change.

@ProviderFor(onlineStatus)
final onlineStatusProvider = OnlineStatusProvider._();

/// Whether the device currently has a network connection. This is a coarse
/// signal (an interface is up), not a guarantee the API is reachable — the sync
/// engine still treats network errors as "stay pending". Emits the current value
/// immediately, then on every connectivity change.

final class OnlineStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Whether the device currently has a network connection. This is a coarse
  /// signal (an interface is up), not a guarantee the API is reachable — the sync
  /// engine still treats network errors as "stay pending". Emits the current value
  /// immediately, then on every connectivity change.
  OnlineStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onlineStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onlineStatusHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return onlineStatus(ref);
  }
}

String _$onlineStatusHash() => r'8e84cd31165db830835c6567418aefcfe535364c';

/// A synchronous best-effort read of the latest known online status (defaults to
/// online while the first value is still resolving), for callers that can't await.

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// A synchronous best-effort read of the latest known online status (defaults to
/// online while the first value is still resolving), for callers that can't await.

final class IsOnlineProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// A synchronous best-effort read of the latest known online status (defaults to
  /// online while the first value is still resolving), for callers that can't await.
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOnline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOnlineHash() => r'0a43a5b8213e036c5c3e1d57cbdc3e8baa279d88';
