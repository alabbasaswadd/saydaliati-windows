import 'package:json_annotation/json_annotation.dart';

part 'currency_dto.g.dart';

/// Wire model for `pharmacy-api/Currency`.
@JsonSerializable(createToJson: false)
class CurrencyDto {
  const CurrencyDto({
    this.id,
    this.code,
    this.name,
    this.symbol,
    this.exchangeRate,
    this.isBaseCurrency,
    this.isActive,
    this.rateUpdatedOn,
  });

  final String? id;
  final String? code;
  final String? name;
  final String? symbol;
  final num? exchangeRate;
  final bool? isBaseCurrency;
  final bool? isActive;
  final DateTime? rateUpdatedOn;

  factory CurrencyDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDtoFromJson(json);
}
