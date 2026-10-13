// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single [AppDatabase] instance for the app. Kept alive for the whole
/// session and closed on dispose.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The single [AppDatabase] instance for the app. Kept alive for the whole
/// session and closed on dispose.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The single [AppDatabase] instance for the app. Kept alive for the whole
  /// session and closed on dispose.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

/// The write queue (unposted creates), backed by [appDatabase].

@ProviderFor(outboxRepository)
final outboxRepositoryProvider = OutboxRepositoryProvider._();

/// The write queue (unposted creates), backed by [appDatabase].

final class OutboxRepositoryProvider
    extends
        $FunctionalProvider<
          OutboxRepository,
          OutboxRepository,
          OutboxRepository
        >
    with $Provider<OutboxRepository> {
  /// The write queue (unposted creates), backed by [appDatabase].
  OutboxRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outboxRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outboxRepositoryHash();

  @$internal
  @override
  $ProviderElement<OutboxRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OutboxRepository create(Ref ref) {
    return outboxRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OutboxRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OutboxRepository>(value),
    );
  }
}

String _$outboxRepositoryHash() => r'98d01c71c978510dd1d5b0e62b0abf891531f5ca';

/// The tenant key used to scope every local row. Read from the current session.
/// Falls back to a stable placeholder before login so the database is always
/// usable; per-tenant rows never leak across accounts.

@ProviderFor(currentTenantKey)
final currentTenantKeyProvider = CurrentTenantKeyProvider._();

/// The tenant key used to scope every local row. Read from the current session.
/// Falls back to a stable placeholder before login so the database is always
/// usable; per-tenant rows never leak across accounts.

final class CurrentTenantKeyProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The tenant key used to scope every local row. Read from the current session.
  /// Falls back to a stable placeholder before login so the database is always
  /// usable; per-tenant rows never leak across accounts.
  CurrentTenantKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTenantKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTenantKeyHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentTenantKey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentTenantKeyHash() => r'4c25672bf827456cf5879d04a8d0b9e800056441';
