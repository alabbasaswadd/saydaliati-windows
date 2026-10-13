// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The user-chosen work mode, persisted so it survives restarts. Starts in
/// [WorkMode.auto] and loads the saved value right after build.

@ProviderFor(WorkModeController)
final workModeControllerProvider = WorkModeControllerProvider._();

/// The user-chosen work mode, persisted so it survives restarts. Starts in
/// [WorkMode.auto] and loads the saved value right after build.
final class WorkModeControllerProvider
    extends $NotifierProvider<WorkModeController, WorkMode> {
  /// The user-chosen work mode, persisted so it survives restarts. Starts in
  /// [WorkMode.auto] and loads the saved value right after build.
  WorkModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workModeControllerHash();

  @$internal
  @override
  WorkModeController create() => WorkModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkMode>(value),
    );
  }
}

String _$workModeControllerHash() =>
    r'f13f730682cdd718d287dbbe8d814b29fecfec06';

/// The user-chosen work mode, persisted so it survives restarts. Starts in
/// [WorkMode.auto] and loads the saved value right after build.

abstract class _$WorkModeController extends $Notifier<WorkMode> {
  WorkMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WorkMode, WorkMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkMode, WorkMode>,
              WorkMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The *effective* connectivity the whole app should act on: `false` when the
/// user forced offline mode, otherwise the real network status. Everything
/// offline-aware (write gate, sync engine, online-only views, refresh button)
/// reads THIS, never the raw [isOnlineProvider] directly.

@ProviderFor(effectiveOnline)
final effectiveOnlineProvider = EffectiveOnlineProvider._();

/// The *effective* connectivity the whole app should act on: `false` when the
/// user forced offline mode, otherwise the real network status. Everything
/// offline-aware (write gate, sync engine, online-only views, refresh button)
/// reads THIS, never the raw [isOnlineProvider] directly.

final class EffectiveOnlineProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// The *effective* connectivity the whole app should act on: `false` when the
  /// user forced offline mode, otherwise the real network status. Everything
  /// offline-aware (write gate, sync engine, online-only views, refresh button)
  /// reads THIS, never the raw [isOnlineProvider] directly.
  EffectiveOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveOnlineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return effectiveOnline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$effectiveOnlineHash() => r'654569549ca3adfb534e8a7cc8bbe37715835138';
