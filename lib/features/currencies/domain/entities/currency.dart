import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';

/// A currency the pharmacy prices/sells in. Pure domain model.
@freezed
abstract class Currency with _$Currency {
  const factory Currency({
    required String id,
    required String code,
    required String name,
    required String symbol,
    required double exchangeRate,
    required bool isBaseCurrency,
    required bool isActive,
    DateTime? rateUpdatedOn,
  }) = _Currency;
}
