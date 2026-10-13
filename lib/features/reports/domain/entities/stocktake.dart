import 'package:freezed_annotation/freezed_annotation.dart';

part 'stocktake.freezed.dart';

/// Stocktake report from `GET pharmacy-api/Report/stocktake`.
@freezed
abstract class Stocktake with _$Stocktake {
  const factory Stocktake({
    required double totalCostValue,
    required int medicinesCount,
    @Default(<StocktakeItem>[]) List<StocktakeItem> items,
  }) = _Stocktake;
}

@freezed
abstract class StocktakeItem with _$StocktakeItem {
  const factory StocktakeItem({
    required String medicineId,
    required String brandName,
    required double onHandQuantity,
    required double purchaseCost,
    required double costValue,
    @Default(<StocktakeUnit>[]) List<StocktakeUnit> units,
  }) = _StocktakeItem;
}

@freezed
abstract class StocktakeUnit with _$StocktakeUnit {
  const factory StocktakeUnit({
    required String unitName,
    required double conversionFactor,
    required bool isBaseUnit,
    required double costPrice,
    required double salePrice,
  }) = _StocktakeUnit;
}
