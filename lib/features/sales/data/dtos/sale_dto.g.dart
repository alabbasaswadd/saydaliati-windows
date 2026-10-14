// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleDto _$SaleDtoFromJson(Map<String, dynamic> json) => SaleDto(
  id: json['id'] as String?,
  invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
  customerId: json['customerId'] as String?,
  saleDate: json['saleDate'] == null
      ? null
      : DateTime.parse(json['saleDate'] as String),
  totalAmount: json['totalAmount'] as num?,
  paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
  currency: json['currency'] == null
      ? null
      : SaleCurrencyDto.fromJson(json['currency'] as Map<String, dynamic>),
  originalCurrencyId: json['originalCurrencyId'] as String?,
  exchangeRate: json['exchangeRate'] as num?,
  isPrescription: json['isPrescription'] as bool?,
  paymentAccountId: json['paymentAccountId'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => SaleItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

SaleCurrencyDto _$SaleCurrencyDtoFromJson(Map<String, dynamic> json) =>
    SaleCurrencyDto(
      code: json['code'] as String?,
      symbol: json['symbol'] as String?,
    );

SaleItemDto _$SaleItemDtoFromJson(Map<String, dynamic> json) => SaleItemDto(
  medicineId: json['medicineId'] as String?,
  unitId: json['unitId'] as String?,
  individual: json['individual'] as num?,
  quantity: json['quantity'] as num?,
  subTotal: json['subTotal'] as num?,
  unitCost: json['unitCost'] as num?,
  medicine: json['medicine'] == null
      ? null
      : SaleMedicineDto.fromJson(json['medicine'] as Map<String, dynamic>),
  unit: json['unit'] == null
      ? null
      : SaleUnitDto.fromJson(json['unit'] as Map<String, dynamic>),
);

SaleMedicineDto _$SaleMedicineDtoFromJson(Map<String, dynamic> json) =>
    SaleMedicineDto(
      brandName: json['brandName'] as String?,
      genericName: json['genericName'] as String?,
    );

SaleUnitDto _$SaleUnitDtoFromJson(Map<String, dynamic> json) =>
    SaleUnitDto(name: json['name'] as String?);
