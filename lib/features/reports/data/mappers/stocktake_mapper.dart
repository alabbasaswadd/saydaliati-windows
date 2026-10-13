import 'package:saydaliati/features/reports/data/dtos/stocktake_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/stocktake.dart';

extension StocktakeDtoMapper on StocktakeDto {
  Stocktake toEntity() => Stocktake(
        totalCostValue: (totalCostValue ?? 0).toDouble(),
        medicinesCount: medicinesCount ?? 0,
        items: (items ?? const [])
            .map((it) => StocktakeItem(
                  medicineId: it.medicineId ?? '',
                  brandName: it.brandName ?? '',
                  onHandQuantity: (it.onHandQuantity ?? 0).toDouble(),
                  purchaseCost: (it.purchaseCost ?? 0).toDouble(),
                  costValue: (it.costValue ?? 0).toDouble(),
                  units: (it.units ?? const [])
                      .map((u) => StocktakeUnit(
                            unitName: u.unitName ?? '',
                            conversionFactor: (u.conversionFactor ?? 1).toDouble(),
                            isBaseUnit: u.isBaseUnit ?? false,
                            costPrice: (u.costPrice ?? 0).toDouble(),
                            salePrice: (u.salePrice ?? 0).toDouble(),
                          ))
                      .toList(),
                ))
            .toList(),
      );
}
