// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// تجميع ميزة الديون — متّصلة فقط: الرصيد قرار مالي، فلا يُقرأ من كاش قد
/// يكون أقدم من تسديدٍ جرى على جهاز آخر.

@ProviderFor(debtRemoteDataSource)
final debtRemoteDataSourceProvider = DebtRemoteDataSourceProvider._();

/// تجميع ميزة الديون — متّصلة فقط: الرصيد قرار مالي، فلا يُقرأ من كاش قد
/// يكون أقدم من تسديدٍ جرى على جهاز آخر.

final class DebtRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          DebtRemoteDataSource,
          DebtRemoteDataSource,
          DebtRemoteDataSource
        >
    with $Provider<DebtRemoteDataSource> {
  /// تجميع ميزة الديون — متّصلة فقط: الرصيد قرار مالي، فلا يُقرأ من كاش قد
  /// يكون أقدم من تسديدٍ جرى على جهاز آخر.
  DebtRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DebtRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DebtRemoteDataSource create(Ref ref) {
    return debtRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebtRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebtRemoteDataSource>(value),
    );
  }
}

String _$debtRemoteDataSourceHash() =>
    r'ec07560786c80f0ab6715bc8319fab26e0a5714d';

/// ديون العملاء — المستحقّ لنا.

@ProviderFor(customerDebts)
final customerDebtsProvider = CustomerDebtsProvider._();

/// ديون العملاء — المستحقّ لنا.

final class CustomerDebtsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PartyDebt>>,
          List<PartyDebt>,
          FutureOr<List<PartyDebt>>
        >
    with $FutureModifier<List<PartyDebt>>, $FutureProvider<List<PartyDebt>> {
  /// ديون العملاء — المستحقّ لنا.
  CustomerDebtsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerDebtsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerDebtsHash();

  @$internal
  @override
  $FutureProviderElement<List<PartyDebt>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PartyDebt>> create(Ref ref) {
    return customerDebts(ref);
  }
}

String _$customerDebtsHash() => r'7383db451ff4eff2ecf36c91da5367affbe67ba7';

/// ديون الموردين — المستحقّ علينا.

@ProviderFor(supplierDebts)
final supplierDebtsProvider = SupplierDebtsProvider._();

/// ديون الموردين — المستحقّ علينا.

final class SupplierDebtsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PartyDebt>>,
          List<PartyDebt>,
          FutureOr<List<PartyDebt>>
        >
    with $FutureModifier<List<PartyDebt>>, $FutureProvider<List<PartyDebt>> {
  /// ديون الموردين — المستحقّ علينا.
  SupplierDebtsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supplierDebtsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supplierDebtsHash();

  @$internal
  @override
  $FutureProviderElement<List<PartyDebt>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PartyDebt>> create(Ref ref) {
    return supplierDebts(ref);
  }
}

String _$supplierDebtsHash() => r'9a2745ac64a5f07b4d36f4593b378103d0d93674';

/// تسديد دين. يُعيد المتبقّي كما حسبه الخادم.

@ProviderFor(settleDebt)
final settleDebtProvider = SettleDebtProvider._();

/// تسديد دين. يُعيد المتبقّي كما حسبه الخادم.

final class SettleDebtProvider
    extends
        $FunctionalProvider<
          Future<SettleDebtResult> Function(SettleDebtInput),
          Future<SettleDebtResult> Function(SettleDebtInput),
          Future<SettleDebtResult> Function(SettleDebtInput)
        >
    with $Provider<Future<SettleDebtResult> Function(SettleDebtInput)> {
  /// تسديد دين. يُعيد المتبقّي كما حسبه الخادم.
  SettleDebtProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settleDebtProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settleDebtHash();

  @$internal
  @override
  $ProviderElement<Future<SettleDebtResult> Function(SettleDebtInput)>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<SettleDebtResult> Function(SettleDebtInput) create(Ref ref) {
    return settleDebt(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<SettleDebtResult> Function(SettleDebtInput) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<SettleDebtResult> Function(SettleDebtInput)
          >(value),
    );
  }
}

String _$settleDebtHash() => r'2c5bda584756d3fa0fe6c406ab2072718bee0270';
