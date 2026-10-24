// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single orchestrator for keeping the local cache in sync with the server.
///
/// [syncAll] FIRST pushes queued writes (e.g. offline sales) so the server
/// applies them, THEN re-pulls the catalogs (currencies, medicines + prices,
/// customers, stock quantities, categories, units) into the local cache — so the
/// cache is corrected from the server right after invoices are posted.
///
/// Runs automatically at startup and whenever connectivity (or the manual work
/// mode) returns to online, and can be triggered manually from Settings.

@ProviderFor(DataSyncController)
final dataSyncControllerProvider = DataSyncControllerProvider._();

/// The single orchestrator for keeping the local cache in sync with the server.
///
/// [syncAll] FIRST pushes queued writes (e.g. offline sales) so the server
/// applies them, THEN re-pulls the catalogs (currencies, medicines + prices,
/// customers, stock quantities, categories, units) into the local cache — so the
/// cache is corrected from the server right after invoices are posted.
///
/// Runs automatically at startup and whenever connectivity (or the manual work
/// mode) returns to online, and can be triggered manually from Settings.
final class DataSyncControllerProvider
    extends $NotifierProvider<DataSyncController, SyncProgress> {
  /// The single orchestrator for keeping the local cache in sync with the server.
  ///
  /// [syncAll] FIRST pushes queued writes (e.g. offline sales) so the server
  /// applies them, THEN re-pulls the catalogs (currencies, medicines + prices,
  /// customers, stock quantities, categories, units) into the local cache — so the
  /// cache is corrected from the server right after invoices are posted.
  ///
  /// Runs automatically at startup and whenever connectivity (or the manual work
  /// mode) returns to online, and can be triggered manually from Settings.
  DataSyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataSyncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataSyncControllerHash();

  @$internal
  @override
  DataSyncController create() => DataSyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncProgress value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncProgress>(value),
    );
  }
}

String _$dataSyncControllerHash() =>
    r'af0d54880457af003731e1060d4bff35973a2f37';

/// The single orchestrator for keeping the local cache in sync with the server.
///
/// [syncAll] FIRST pushes queued writes (e.g. offline sales) so the server
/// applies them, THEN re-pulls the catalogs (currencies, medicines + prices,
/// customers, stock quantities, categories, units) into the local cache — so the
/// cache is corrected from the server right after invoices are posted.
///
/// Runs automatically at startup and whenever connectivity (or the manual work
/// mode) returns to online, and can be triggered manually from Settings.

abstract class _$DataSyncController extends $Notifier<SyncProgress> {
  SyncProgress build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncProgress, SyncProgress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncProgress, SyncProgress>,
              SyncProgress,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
