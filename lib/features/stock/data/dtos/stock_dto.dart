import 'package:json_annotation/json_annotation.dart';

part 'stock_dto.g.dart';

@JsonSerializable(createToJson: false)
class StockDto {
  const StockDto({
    this.id,
    this.medicineId,
    this.quantityAvailable,
    this.purchasePrice,
    this.sellingPrice,
    this.expiryDate,
    this.dateReceived,
    this.medicine,
  });

  final String? id;
  final String? medicineId;
  final num? quantityAvailable;
  final num? purchasePrice;
  final num? sellingPrice;
  final DateTime? expiryDate;
  final DateTime? dateReceived;
  final StockMedicineDto? medicine;

  factory StockDto.fromJson(Map<String, dynamic> json) =>
      _$StockDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class StockMedicineDto {
  const StockMedicineDto({this.brandName, this.genericName});

  final String? brandName;
  final String? genericName;

  factory StockMedicineDto.fromJson(Map<String, dynamic> json) =>
      _$StockMedicineDtoFromJson(json);
}
