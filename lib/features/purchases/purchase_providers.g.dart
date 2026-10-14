// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(purchaseRemoteDataSource)
final purchaseRemoteDataSourceProvider = PurchaseRemoteDataSourceProvider._();

final class PurchaseRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PurchaseRemoteDataSource,
          PurchaseRemoteDataSource,
          PurchaseRemoteDataSource
        >
    with $Provider<PurchaseRemoteDataSource> {
  PurchaseRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PurchaseRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseRemoteDataSource create(Ref ref) {
    return purchaseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseRemoteDataSource>(value),
    );
  }
}

String _$purchaseRemoteDataSourceHash() =>
    r'68f31441042ca599a03858cd4a854f10858ae6df';

@ProviderFor(purchaseRepository)
final purchaseRepositoryProvider = PurchaseRepositoryProvider._();

final class PurchaseRepositoryProvider
    extends
        $FunctionalProvider<
          PurchaseRepository,
          PurchaseRepository,
          PurchaseRepository
        >
    with $Provider<PurchaseRepository> {
  PurchaseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseRepositoryHash();

  @$internal
  @override
  $ProviderElement<PurchaseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseRepository create(Ref ref) {
    return purchaseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseRepository>(value),
    );
  }
}

String _$purchaseRepositoryHash() =>
    r'b5c8c7e1b348ca96ab141da1eac9fcc1ff9e7dae';

@ProviderFor(purchasesList)
final purchasesListProvider = PurchasesListProvider._();

final class PurchasesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Purchase>>,
          List<Purchase>,
          FutureOr<List<Purchase>>
        >
    with $FutureModifier<List<Purchase>>, $FutureProvider<List<Purchase>> {
  PurchasesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchasesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchasesListHash();

  @$internal
  @override
  $FutureProviderElement<List<Purchase>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Purchase>> create(Ref ref) {
    return purchasesList(ref);
  }
}

String _$purchasesListHash() => r'9eeeef18da03180a6936bb2b416260dee86e7096';

@ProviderFor(purchaseReturnRemoteDataSource)
final purchaseReturnRemoteDataSourceProvider =
    PurchaseReturnRemoteDataSourceProvider._();

final class PurchaseReturnRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PurchaseReturnRemoteDataSource,
          PurchaseReturnRemoteDataSource,
          PurchaseReturnRemoteDataSource
        >
    with $Provider<PurchaseReturnRemoteDataSource> {
  PurchaseReturnRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseReturnRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseReturnRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PurchaseReturnRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseReturnRemoteDataSource create(Ref ref) {
    return purchaseReturnRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseReturnRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseReturnRemoteDataSource>(
        value,
      ),
    );
  }
}

String _$purchaseReturnRemoteDataSourceHash() =>
    r'6cb34241776496b764e5977a534ed9bb51c3cab8';

/// Purchase returns — online-only (see PurchaseReturnRepository doc).

@ProviderFor(purchaseReturnRepository)
final purchaseReturnRepositoryProvider = PurchaseReturnRepositoryProvider._();

/// Purchase returns — online-only (see PurchaseReturnRepository doc).

final class PurchaseReturnRepositoryProvider
    extends
        $FunctionalProvider<
          PurchaseReturnRepository,
          PurchaseReturnRepository,
          PurchaseReturnRepository
        >
    with $Provider<PurchaseReturnRepository> {
  /// Purchase returns — online-only (see PurchaseReturnRepository doc).
  PurchaseReturnRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseReturnRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseReturnRepositoryHash();

  @$internal
  @override
  $ProviderElement<PurchaseReturnRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseReturnRepository create(Ref ref) {
    return purchaseReturnRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseReturnRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseReturnRepository>(value),
    );
  }
}

String _$purchaseReturnRepositoryHash() =>
    r'e0f8fcc7d7d92e53b1ad54bb08ae16b6b56932d4';

@ProviderFor(purchaseReturnableLines)
final purchaseReturnableLinesProvider = PurchaseReturnableLinesFamily._();

final class PurchaseReturnableLinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PurchaseReturnableLine>>,
          List<PurchaseReturnableLine>,
          FutureOr<List<PurchaseReturnableLine>>
        >
    with
        $FutureModifier<List<PurchaseReturnableLine>>,
        $FutureProvider<List<PurchaseReturnableLine>> {
  PurchaseReturnableLinesProvider._({
    required PurchaseReturnableLinesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'purchaseReturnableLinesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$purchaseReturnableLinesHash();

  @override
  String toString() {
    return r'purchaseReturnableLinesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PurchaseReturnableLine>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PurchaseReturnableLine>> create(Ref ref) {
    final argument = this.argument as String;
    return purchaseReturnableLines(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseReturnableLinesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$purchaseReturnableLinesHash() =>
    r'4aaecbc425f1ec253d39ded61d722c068e9dd2cc';

final class PurchaseReturnableLinesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<PurchaseReturnableLine>>,
          String
        > {
  PurchaseReturnableLinesFamily._()
    : super(
        retry: null,
        name: r'purchaseReturnableLinesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PurchaseReturnableLinesProvider call(String purchaseId) =>
      PurchaseReturnableLinesProvider._(argument: purchaseId, from: this);

  @override
  String toString() => r'purchaseReturnableLinesProvider';
}

/// Saved purchase return documents — drives the «مرتجع مشتريات» sidebar section.

@ProviderFor(purchaseReturnsList)
final purchaseReturnsListProvider = PurchaseReturnsListProvider._();

/// Saved purchase return documents — drives the «مرتجع مشتريات» sidebar section.

final class PurchaseReturnsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PurchaseReturnSummary>>,
          List<PurchaseReturnSummary>,
          FutureOr<List<PurchaseReturnSummary>>
        >
    with
        $FutureModifier<List<PurchaseReturnSummary>>,
        $FutureProvider<List<PurchaseReturnSummary>> {
  /// Saved purchase return documents — drives the «مرتجع مشتريات» sidebar section.
  PurchaseReturnsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseReturnsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseReturnsListHash();

  @$internal
  @override
  $FutureProviderElement<List<PurchaseReturnSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PurchaseReturnSummary>> create(Ref ref) {
    return purchaseReturnsList(ref);
  }
}

String _$purchaseReturnsListHash() =>
    r'ef4e9ee172ff6641c61dcf218cb8e9f745df8d5f';
