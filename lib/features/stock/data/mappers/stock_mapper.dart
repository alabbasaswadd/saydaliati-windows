import 'package:saydaliati/features/stock/data/dtos/stock_dto.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';

extension StockDtoMapper on StockDto {
  Stock toEntity() => Stock(
        id: id ?? '',
        medicineId: medicineId ?? '',
        medicineName: medicine?.brandName ?? medicine?.genericName ?? '',
        quantityAvailable: (quantityAvailable ?? 0).toDouble(),
        purchasePrice: (purchasePrice ?? 0).toDouble(),
        sellingPrice: (sellingPrice ?? 0).toDouble(),
        expiryDate: expiryDate,
        dateReceived: dateReceived,
      );
}
