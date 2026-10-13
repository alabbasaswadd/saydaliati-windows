// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The currency list as an [AsyncValue] (cache-first). Used by the POS currency
/// dropdown and, later, the currencies management screen.

@ProviderFor(currencies)
final currenciesProvider = CurrenciesProvider._();

/// The currency list as an [AsyncValue] (cache-first). Used by the POS currency
/// dropdown and, later, the currencies management screen.

final class CurrenciesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Currency>>,
          List<Currency>,
          FutureOr<List<Currency>>
        >
    with $FutureModifier<List<Currency>>, $FutureProvider<List<Currency>> {
  /// The currency list as an [AsyncValue] (cache-first). Used by the POS currency
  /// dropdown and, later, the currencies management screen.
  CurrenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currenciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currenciesHash();

  @$internal
  @override
  $FutureProviderElement<List<Currency>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Currency>> create(Ref ref) {
    return currencies(ref);
  }
}

String _$currenciesHash() => r'96837e5e13e0228975b328767685ff0f9a0295bd';

/// The base currency (or the first, or null if none) — the POS default.

@ProviderFor(baseCurrency)
final baseCurrencyProvider = BaseCurrencyProvider._();

/// The base currency (or the first, or null if none) — the POS default.

final class BaseCurrencyProvider
    extends $FunctionalProvider<Currency?, Currency?, Currency?>
    with $Provider<Currency?> {
  /// The base currency (or the first, or null if none) — the POS default.
  BaseCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'baseCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$baseCurrencyHash();

  @$internal
  @override
  $ProviderElement<Currency?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Currency? create(Ref ref) {
    return baseCurrency(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Currency? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Currency?>(value),
    );
  }
}

String _$baseCurrencyHash() => r'0ea11e425a89587fba3dc644709ccc41edd7884d';

/// Exchange-rate history for a currency (newest first).

@ProviderFor(currencyRateHistory)
final currencyRateHistoryProvider = CurrencyRateHistoryFamily._();

/// Exchange-rate history for a currency (newest first).

final class CurrencyRateHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CurrencyRateEntry>>,
          List<CurrencyRateEntry>,
          FutureOr<List<CurrencyRateEntry>>
        >
    with
        $FutureModifier<List<CurrencyRateEntry>>,
        $FutureProvider<List<CurrencyRateEntry>> {
  /// Exchange-rate history for a currency (newest first).
  CurrencyRateHistoryProvider._({
    required CurrencyRateHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'currencyRateHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currencyRateHistoryHash();

  @override
  String toString() {
    return r'currencyRateHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CurrencyRateEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CurrencyRateEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return currencyRateHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrencyRateHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currencyRateHistoryHash() =>
    r'4ecdc43824cc8651591300b1db4858042d460d51';

/// Exchange-rate history for a currency (newest first).

final class CurrencyRateHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CurrencyRateEntry>>, String> {
  CurrencyRateHistoryFamily._()
    : super(
        retry: null,
        name: r'currencyRateHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Exchange-rate history for a currency (newest first).

  CurrencyRateHistoryProvider call(String currencyId) =>
      CurrencyRateHistoryProvider._(argument: currencyId, from: this);

  @override
  String toString() => r'currencyRateHistoryProvider';
}
