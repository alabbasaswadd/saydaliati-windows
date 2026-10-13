// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The sales invoices as an [AsyncValue] (online), with optional filters
/// (date range + customer + medicine + currency). No args → all invoices.

@ProviderFor(salesList)
final salesListProvider = SalesListFamily._();

/// The sales invoices as an [AsyncValue] (online), with optional filters
/// (date range + customer + medicine + currency). No args → all invoices.

final class SalesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Sale>>,
          List<Sale>,
          FutureOr<List<Sale>>
        >
    with $FutureModifier<List<Sale>>, $FutureProvider<List<Sale>> {
  /// The sales invoices as an [AsyncValue] (online), with optional filters
  /// (date range + customer + medicine + currency). No args → all invoices.
  SalesListProvider._({
    required SalesListFamily super.from,
    required ({
      String? fromIso,
      String? toIso,
      String? customerId,
      String? medicineId,
      String? currencyId,
      bool? isPrescription,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'salesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesListHash();

  @override
  String toString() {
    return r'salesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Sale>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Sale>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? fromIso,
              String? toIso,
              String? customerId,
              String? medicineId,
              String? currencyId,
              bool? isPrescription,
            });
    return salesList(
      ref,
      fromIso: argument.fromIso,
      toIso: argument.toIso,
      customerId: argument.customerId,
      medicineId: argument.medicineId,
      currencyId: argument.currencyId,
      isPrescription: argument.isPrescription,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesListHash() => r'd98cb6c1a94c970ef641a1960369f68fa35e484a';

/// The sales invoices as an [AsyncValue] (online), with optional filters
/// (date range + customer + medicine + currency). No args → all invoices.

final class SalesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Sale>>,
          ({
            String? fromIso,
            String? toIso,
            String? customerId,
            String? medicineId,
            String? currencyId,
            bool? isPrescription,
          })
        > {
  SalesListFamily._()
    : super(
        retry: null,
        name: r'salesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The sales invoices as an [AsyncValue] (online), with optional filters
  /// (date range + customer + medicine + currency). No args → all invoices.

  SalesListProvider call({
    String? fromIso,
    String? toIso,
    String? customerId,
    String? medicineId,
    String? currencyId,
    bool? isPrescription,
  }) => SalesListProvider._(
    argument: (
      fromIso: fromIso,
      toIso: toIso,
      customerId: customerId,
      medicineId: medicineId,
      currencyId: currencyId,
      isPrescription: isPrescription,
    ),
    from: this,
  );

  @override
  String toString() => r'salesListProvider';
}
