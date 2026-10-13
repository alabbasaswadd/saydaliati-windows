import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/currencies/data/datasources/currency_local_data_source.dart';
import 'package:saydaliati/features/currencies/data/datasources/currency_remote_data_source.dart';
import 'package:saydaliati/features/currencies/data/dtos/currency_dto.dart';
import 'package:saydaliati/features/currencies/data/mappers/currency_mapper.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency_rate_entry.dart';
import 'package:saydaliati/features/currencies/domain/repositories/currency_repository.dart';

/// Cache-first currencies: fetch + refresh the cache when online; fall back to
/// the cache on any failure. Writes are online-only.
class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._remote, this._local);

  final CurrencyRemoteDataSource _remote;
  final CurrencyLocalDataSource _local;

  Currency _decode(Map<String, dynamic> m) => CurrencyDto.fromJson(m).toEntity();

  @override
  Future<Result<List<Currency>>> getCurrencies() async {
    try {
      final raw = await _remote.list();
      await _local.replaceAll(raw);
      return Result.success(raw.map(_decode).toList());
    } catch (error) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) return Result.success(cached.map(_decode).toList());
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  Map<String, dynamic> _body({
    required String code,
    required String name,
    required String symbol,
    required double exchangeRate,
    required bool isBaseCurrency,
    required bool isActive,
  }) =>
      {
        'code': code,
        'name': name,
        'symbol': symbol,
        'exchangeRate': exchangeRate,
        'isBaseCurrency': isBaseCurrency,
        'isActive': isActive,
      };

  @override
  Future<Result<void>> create({
    required String code,
    required String name,
    required String symbol,
    required double exchangeRate,
    required bool isBaseCurrency,
    required bool isActive,
  }) =>
      _guard(() => _remote.create(_body(
            code: code,
            name: name,
            symbol: symbol,
            exchangeRate: exchangeRate,
            isBaseCurrency: isBaseCurrency,
            isActive: isActive,
          )));

  @override
  Future<Result<void>> update({
    required String id,
    required String code,
    required String name,
    required String symbol,
    required double exchangeRate,
    required bool isBaseCurrency,
    required bool isActive,
  }) =>
      _guard(() => _remote.update(id, {
            'id': id,
            ..._body(
              code: code,
              name: name,
              symbol: symbol,
              exchangeRate: exchangeRate,
              isBaseCurrency: isBaseCurrency,
              isActive: isActive,
            ),
          }));

  @override
  Future<Result<void>> delete(String id) => _guard(() => _remote.delete(id));

  @override
  Future<Result<void>> changeBase(String id, bool isBase) =>
      _guard(() => _remote.changeBase(id, isBase));

  @override
  Future<Result<void>> setExchangeRate(String id, double rate) =>
      _guard(() => _remote.setExchangeRate(id, rate));

  @override
  Future<Result<List<CurrencyRateEntry>>> getRateHistory(String id) async {
    try {
      final raw = await _remote.rateHistory(id);
      return Result.success(raw.map(CurrencyRateEntry.fromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  Future<Result<void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
