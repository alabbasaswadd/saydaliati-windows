// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drains the outbox to the server. State is `true` while a drain is in progress
/// (so the UI can show a spinner). Triggered by [DataSyncController] (startup +
/// reconnect, before it re-pulls the catalogs) and manually via [pushNow] — this
/// engine no longer self-triggers, so push-then-pull stays correctly ordered.
///
/// Endpoints per operation `kind` come from [outboxEndpointsProvider], which
/// features populate. This keeps the engine generic — it knows nothing about any
/// specific feature, only how to replay a queued POST.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Drains the outbox to the server. State is `true` while a drain is in progress
/// (so the UI can show a spinner). Triggered by [DataSyncController] (startup +
/// reconnect, before it re-pulls the catalogs) and manually via [pushNow] — this
/// engine no longer self-triggers, so push-then-pull stays correctly ordered.
///
/// Endpoints per operation `kind` come from [outboxEndpointsProvider], which
/// features populate. This keeps the engine generic — it knows nothing about any
/// specific feature, only how to replay a queued POST.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, bool> {
  /// Drains the outbox to the server. State is `true` while a drain is in progress
  /// (so the UI can show a spinner). Triggered by [DataSyncController] (startup +
  /// reconnect, before it re-pulls the catalogs) and manually via [pushNow] — this
  /// engine no longer self-triggers, so push-then-pull stays correctly ordered.
  ///
  /// Endpoints per operation `kind` come from [outboxEndpointsProvider], which
  /// features populate. This keeps the engine generic — it knows nothing about any
  /// specific feature, only how to replay a queued POST.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$syncControllerHash() => r'7af5b58eda82148abdc3c0eb1ea01776c7fd6e8c';

/// Drains the outbox to the server. State is `true` while a drain is in progress
/// (so the UI can show a spinner). Triggered by [DataSyncController] (startup +
/// reconnect, before it re-pulls the catalogs) and manually via [pushNow] — this
/// engine no longer self-triggers, so push-then-pull stays correctly ordered.
///
/// Endpoints per operation `kind` come from [outboxEndpointsProvider], which
/// features populate. This keeps the engine generic — it knows nothing about any
/// specific feature, only how to replay a queued POST.

abstract class _$SyncController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Reactive count of items waiting in the outbox for the current tenant. Drives
/// a "pending operations" badge; `0` (or loading) means nothing to show.

@ProviderFor(pendingOperationsCount)
final pendingOperationsCountProvider = PendingOperationsCountProvider._();

/// Reactive count of items waiting in the outbox for the current tenant. Drives
/// a "pending operations" badge; `0` (or loading) means nothing to show.

final class PendingOperationsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Reactive count of items waiting in the outbox for the current tenant. Drives
  /// a "pending operations" badge; `0` (or loading) means nothing to show.
  PendingOperationsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingOperationsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingOperationsCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return pendingOperationsCount(ref);
  }
}

String _$pendingOperationsCountHash() =>
    r'2eca23b0cc341a1a4e48709d72d2c10be8eba12d';
