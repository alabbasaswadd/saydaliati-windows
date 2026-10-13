import 'package:saydaliati/features/currencies/data/dtos/currency_dto.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';

extension CurrencyDtoMapper on CurrencyDto {
  Currency toEntity() => Currency(
        id: id ?? '',
        code: code ?? '',
        name: name ?? '',
        symbol: symbol ?? '',
        exchangeRate: (exchangeRate ?? 1).toDouble(),
        isBaseCurrency: isBaseCurrency ?? false,
        isActive: isActive ?? true,
        rateUpdatedOn: rateUpdatedOn,
      );
}
