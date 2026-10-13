import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/features/currencies/currency_providers.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency_rate_entry.dart';

part 'currencies_provider.g.dart';

/// The currency list as an [AsyncValue] (cache-first). Used by the POS currency
/// dropdown and, later, the currencies management screen.
@riverpod
Future<List<Currency>> currencies(Ref ref) async {
  final result = await ref.watch(currencyRepositoryProvider).getCurrencies();
  return result.fold((list) => list, (failure) => throw failure);
}

/// The base currency (or the first, or null if none) — the POS default.
@riverpod
Currency? baseCurrency(Ref ref) {
  final list = ref.watch(currenciesProvider).value ?? const [];
  if (list.isEmpty) return null;
  return list.where((c) => c.isBaseCurrency).firstOrNull ?? list.first;
}

/// Exchange-rate history for a currency (newest first).
@riverpod
Future<List<CurrencyRateEntry>> currencyRateHistory(
    Ref ref, String currencyId) async {
  final result =
      await ref.watch(currencyRepositoryProvider).getRateHistory(currencyId);
  return result.fold((list) => list, (failure) => throw failure);
}
