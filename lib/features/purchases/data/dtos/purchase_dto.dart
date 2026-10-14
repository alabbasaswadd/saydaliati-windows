import 'package:json_annotation/json_annotation.dart';

part 'purchase_dto.g.dart';

@JsonSerializable(createToJson: false)
class PurchaseDto {
  const PurchaseDto({
    this.id,
    this.invoiceNumber,
    this.purchaseDate,
    this.totalAmount,
    this.paymentAccountId,
    this.items,
  });

  final String? id;
  final int? invoiceNumber;
  final DateTime? purchaseDate;
  final num? totalAmount;
  final String? paymentAccountId;
  final List<PurchaseItemDto>? items;

  factory PurchaseDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseItemDto {
  const PurchaseItemDto({
    this.medicineId,
    this.unitId,
    this.unitPrice,
    this.quantity,
    this.subTotal,
    this.expiryDate,
    this.medicine,
    this.unit,
  });

  final String? medicineId;
  final String? unitId;
  final num? unitPrice;
  final num? quantity;
  final num? subTotal;
  final DateTime? expiryDate;
  final PurchaseMedicineDto? medicine;
  final PurchaseUnitDto? unit;

  factory PurchaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseMedicineDto {
  const PurchaseMedicineDto({this.brandName, this.genericName});

  final String? brandName;
  final String? genericName;

  factory PurchaseMedicineDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseMedicineDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseUnitDto {
  const PurchaseUnitDto({this.name});

  final String? name;

  factory PurchaseUnitDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseUnitDtoFromJson(json);
}
