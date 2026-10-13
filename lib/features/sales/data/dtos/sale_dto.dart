import 'package:json_annotation/json_annotation.dart';

part 'sale_dto.g.dart';

/// Wire model for `pharmacy-api/Sale` responses.
@JsonSerializable(createToJson: false)
class SaleDto {
  const SaleDto({
    this.id,
    this.invoiceNumber,
    this.customerId,
    this.saleDate,
    this.totalAmount,
    this.paymentMethod,
    this.currency,
    this.originalCurrencyId,
    this.exchangeRate,
    this.isPrescription,
    this.items,
  });

  final String? id;
  final int? invoiceNumber;
  final String? customerId;
  final DateTime? saleDate;
  final num? totalAmount;
  final int? paymentMethod;
  final SaleCurrencyDto? currency;
  final String? originalCurrencyId;
  final num? exchangeRate;
  final bool? isPrescription;
  final List<SaleItemDto>? items;

  factory SaleDto.fromJson(Map<String, dynamic> json) =>
      _$SaleDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SaleCurrencyDto {
  const SaleCurrencyDto({this.code, this.symbol});

  final String? code;
  final String? symbol;

  factory SaleCurrencyDto.fromJson(Map<String, dynamic> json) =>
      _$SaleCurrencyDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SaleItemDto {
  const SaleItemDto({
    this.medicineId,
    this.unitId,
    this.individual,
    this.quantity,
    this.subTotal,
    this.unitCost,
    this.medicine,
    this.unit,
  });

  final String? medicineId;
  final String? unitId;
  final num? individual;
  final num? quantity;
  final num? subTotal;
  final num? unitCost;
  final SaleMedicineDto? medicine;
  final SaleUnitDto? unit;

  factory SaleItemDto.fromJson(Map<String, dynamic> json) =>
      _$SaleItemDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SaleMedicineDto {
  const SaleMedicineDto({this.brandName, this.genericName});

  final String? brandName;
  final String? genericName;

  factory SaleMedicineDto.fromJson(Map<String, dynamic> json) =>
      _$SaleMedicineDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SaleUnitDto {
  const SaleUnitDto({this.name});

  final String? name;

  factory SaleUnitDto.fromJson(Map<String, dynamic> json) =>
      _$SaleUnitDtoFromJson(json);
}
