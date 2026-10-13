import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency_rate_entry.dart';

/// Read + manage currencies. Reads are cache-first (so the POS can price
/// offline); writes are online-only.
abstract interface class CurrencyRepository {
  Future<Result<List<Currency>>> getCurrencies();

  Future<Result<void>> create({
    required String code,
    required String name,
    required String symbol,
    required double exchangeRate,
    required bool isBaseCurrency,
    required bool isActive,
  });

  Future<Result<void>> update({
    required String id,
    required String code,
    required String name,
    required String symbol,
    required double exchangeRate,
    required bool isBaseCurrency,
    required bool isActive,
  });

  Future<Result<void>> delete(String id);

  Future<Result<void>> changeBase(String id, bool isBase);

  Future<Result<void>> setExchangeRate(String id, double rate);

  Future<Result<List<CurrencyRateEntry>>> getRateHistory(String id);
}
