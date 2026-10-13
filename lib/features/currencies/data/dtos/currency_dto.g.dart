// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyDto _$CurrencyDtoFromJson(Map<String, dynamic> json) => CurrencyDto(
  id: json['id'] as String?,
  code: json['code'] as String?,
  name: json['name'] as String?,
  symbol: json['symbol'] as String?,
  exchangeRate: json['exchangeRate'] as num?,
  isBaseCurrency: json['isBaseCurrency'] as bool?,
  isActive: json['isActive'] as bool?,
  rateUpdatedOn: json['rateUpdatedOn'] == null
      ? null
      : DateTime.parse(json['rateUpdatedOn'] as String),
);
