// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportRemoteDataSource)
final reportRemoteDataSourceProvider = ReportRemoteDataSourceProvider._();

final class ReportRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ReportRemoteDataSource,
          ReportRemoteDataSource,
          ReportRemoteDataSource
        >
    with $Provider<ReportRemoteDataSource> {
  ReportRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReportRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportRemoteDataSource create(Ref ref) {
    return reportRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRemoteDataSource>(value),
    );
  }
}

String _$reportRemoteDataSourceHash() =>
    r'8646479e85e9f53f11d48cea0c4616aa7e1ae40f';

@ProviderFor(reportRepository)
final reportRepositoryProvider = ReportRepositoryProvider._();

final class ReportRepositoryProvider
    extends
        $FunctionalProvider<
          ReportRepository,
          ReportRepository,
          ReportRepository
        >
    with $Provider<ReportRepository> {
  ReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportRepository create(Ref ref) {
    return reportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRepository>(value),
    );
  }
}

String _$reportRepositoryHash() => r'dc22e0d86748f253712f7cc06b8448181a2b0c0d';

/// The report for one medicine (keyed by id). Online.

@ProviderFor(medicineReport)
final medicineReportProvider = MedicineReportFamily._();

/// The report for one medicine (keyed by id). Online.

final class MedicineReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<MedicineReport>,
          MedicineReport,
          FutureOr<MedicineReport>
        >
    with $FutureModifier<MedicineReport>, $FutureProvider<MedicineReport> {
  /// The report for one medicine (keyed by id). Online.
  MedicineReportProvider._({
    required MedicineReportFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicineReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicineReportHash();

  @override
  String toString() {
    return r'medicineReportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MedicineReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MedicineReport> create(Ref ref) {
    final argument = this.argument as String;
    return medicineReport(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicineReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicineReportHash() => r'b18fc83343eddccb18d1729d72a737939c17e5fa';

/// The report for one medicine (keyed by id). Online.

final class MedicineReportFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MedicineReport>, String> {
  MedicineReportFamily._()
    : super(
        retry: null,
        name: r'medicineReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The report for one medicine (keyed by id). Online.

  MedicineReportProvider call(String medicineId) =>
      MedicineReportProvider._(argument: medicineId, from: this);

  @override
  String toString() => r'medicineReportProvider';
}

/// Sales summary for a period (keyed by UTC ISO start/end). Online.

@ProviderFor(salesSummary)
final salesSummaryProvider = SalesSummaryFamily._();

/// Sales summary for a period (keyed by UTC ISO start/end). Online.

final class SalesSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SalesSummary>,
          SalesSummary,
          FutureOr<SalesSummary>
        >
    with $FutureModifier<SalesSummary>, $FutureProvider<SalesSummary> {
  /// Sales summary for a period (keyed by UTC ISO start/end). Online.
  SalesSummaryProvider._({
    required SalesSummaryFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'salesSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesSummaryHash();

  @override
  String toString() {
    return r'salesSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<SalesSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SalesSummary> create(Ref ref) {
    final argument = this.argument as (String, String);
    return salesSummary(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesSummaryHash() => r'bb8d5af6851faa284ad88b04bc7f8aa058e87c50';

/// Sales summary for a period (keyed by UTC ISO start/end). Online.

final class SalesSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SalesSummary>, (String, String)> {
  SalesSummaryFamily._()
    : super(
        retry: null,
        name: r'salesSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Sales summary for a period (keyed by UTC ISO start/end). Online.

  SalesSummaryProvider call(String startIso, String endIso) =>
      SalesSummaryProvider._(argument: (startIso, endIso), from: this);

  @override
  String toString() => r'salesSummaryProvider';
}

/// Profit report for a period + optional currency (keyed). Online.

@ProviderFor(profitReport)
final profitReportProvider = ProfitReportFamily._();

/// Profit report for a period + optional currency (keyed). Online.

final class ProfitReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfitReport>,
          ProfitReport,
          FutureOr<ProfitReport>
        >
    with $FutureModifier<ProfitReport>, $FutureProvider<ProfitReport> {
  /// Profit report for a period + optional currency (keyed). Online.
  ProfitReportProvider._({
    required ProfitReportFamily super.from,
    required (String, String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'profitReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profitReportHash();

  @override
  String toString() {
    return r'profitReportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ProfitReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfitReport> create(Ref ref) {
    final argument = this.argument as (String, String, String?);
    return profitReport(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfitReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profitReportHash() => r'771bd9faa2281c8d13f8e18824473295227b312b';

/// Profit report for a period + optional currency (keyed). Online.

final class ProfitReportFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ProfitReport>,
          (String, String, String?)
        > {
  ProfitReportFamily._()
    : super(
        retry: null,
        name: r'profitReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Profit report for a period + optional currency (keyed). Online.

  ProfitReportProvider call(
    String startIso,
    String endIso,
    String? currencyId,
  ) => ProfitReportProvider._(
    argument: (startIso, endIso, currencyId),
    from: this,
  );

  @override
  String toString() => r'profitReportProvider';
}

/// Batch-level expiry report for a warning window (days). Online.

@ProviderFor(expiryReport)
final expiryReportProvider = ExpiryReportFamily._();

/// Batch-level expiry report for a warning window (days). Online.

final class ExpiryReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<ExpiryReport>,
          ExpiryReport,
          FutureOr<ExpiryReport>
        >
    with $FutureModifier<ExpiryReport>, $FutureProvider<ExpiryReport> {
  /// Batch-level expiry report for a warning window (days). Online.
  ExpiryReportProvider._({
    required ExpiryReportFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'expiryReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expiryReportHash();

  @override
  String toString() {
    return r'expiryReportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ExpiryReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ExpiryReport> create(Ref ref) {
    final argument = this.argument as int;
    return expiryReport(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpiryReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expiryReportHash() => r'76abeb207891e5d7624795540f6e0a44a7cda5c9';

/// Batch-level expiry report for a warning window (days). Online.

final class ExpiryReportFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ExpiryReport>, int> {
  ExpiryReportFamily._()
    : super(
        retry: null,
        name: r'expiryReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Batch-level expiry report for a warning window (days). Online.

  ExpiryReportProvider call(int daysWindow) =>
      ExpiryReportProvider._(argument: daysWindow, from: this);

  @override
  String toString() => r'expiryReportProvider';
}

/// Purchases summary for a period (keyed by UTC ISO start/end). Online.

@ProviderFor(purchasesSummary)
final purchasesSummaryProvider = PurchasesSummaryFamily._();

/// Purchases summary for a period (keyed by UTC ISO start/end). Online.

final class PurchasesSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PurchasesSummary>,
          PurchasesSummary,
          FutureOr<PurchasesSummary>
        >
    with $FutureModifier<PurchasesSummary>, $FutureProvider<PurchasesSummary> {
  /// Purchases summary for a period (keyed by UTC ISO start/end). Online.
  PurchasesSummaryProvider._({
    required PurchasesSummaryFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'purchasesSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$purchasesSummaryHash();

  @override
  String toString() {
    return r'purchasesSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PurchasesSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PurchasesSummary> create(Ref ref) {
    final argument = this.argument as (String, String);
    return purchasesSummary(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchasesSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$purchasesSummaryHash() => r'b4c3e1e370ff4008e833e913fac57767b3b8bba5';

/// Purchases summary for a period (keyed by UTC ISO start/end). Online.

final class PurchasesSummaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PurchasesSummary>,
          (String, String)
        > {
  PurchasesSummaryFamily._()
    : super(
        retry: null,
        name: r'purchasesSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Purchases summary for a period (keyed by UTC ISO start/end). Online.

  PurchasesSummaryProvider call(String startIso, String endIso) =>
      PurchasesSummaryProvider._(argument: (startIso, endIso), from: this);

  @override
  String toString() => r'purchasesSummaryProvider';
}

/// Inventory report (stock value, quantities, low-stock). Online.

@ProviderFor(inventoryReport)
final inventoryReportProvider = InventoryReportProvider._();

/// Inventory report (stock value, quantities, low-stock). Online.

final class InventoryReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<InventoryReport>,
          InventoryReport,
          FutureOr<InventoryReport>
        >
    with $FutureModifier<InventoryReport>, $FutureProvider<InventoryReport> {
  /// Inventory report (stock value, quantities, low-stock). Online.
  InventoryReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryReportHash();

  @$internal
  @override
  $FutureProviderElement<InventoryReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InventoryReport> create(Ref ref) {
    return inventoryReport(ref);
  }
}

String _$inventoryReportHash() => r'8338ab84da0f34aaa719c762a1246772e775c013';

/// Stocktake: all medicines with per-unit cost/sale prices. Online.

@ProviderFor(stocktake)
final stocktakeProvider = StocktakeProvider._();

/// Stocktake: all medicines with per-unit cost/sale prices. Online.

final class StocktakeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Stocktake>,
          Stocktake,
          FutureOr<Stocktake>
        >
    with $FutureModifier<Stocktake>, $FutureProvider<Stocktake> {
  /// Stocktake: all medicines with per-unit cost/sale prices. Online.
  StocktakeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stocktakeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stocktakeHash();

  @$internal
  @override
  $FutureProviderElement<Stocktake> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Stocktake> create(Ref ref) {
    return stocktake(ref);
  }
}

String _$stocktakeHash() => r'364324a4daffa3b484bd2945dde913e7a8681f9c';
