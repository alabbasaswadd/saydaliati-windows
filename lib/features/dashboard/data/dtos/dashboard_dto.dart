import 'package:json_annotation/json_annotation.dart';

part 'dashboard_dto.g.dart';

/// Wire model for `GET pharmacy-api/Dashboard` (`data` payload). All fields are
/// nullable so a sparse/partial server response never throws — the mapper
/// coalesces to safe defaults.
@JsonSerializable(createToJson: false)
class DashboardDto {
  const DashboardDto({
    this.salesToday,
    this.salesInvoicesToday,
    this.purchasesThisMonth,
    this.lowStock,
    this.lowStockList,
    this.expiringMedicines,
    this.expiringList,
    this.totalMedicines,
    this.totalCustomers,
    this.totalSuppliers,
    this.salesTrend,
    this.topMedicines,
    this.totalStockValue,
    this.totalPayables,
    this.topPayables,
  });

  final num? salesToday;
  final int? salesInvoicesToday;
  final num? purchasesThisMonth;
  final int? lowStock;
  final List<LowStockItemDto>? lowStockList;
  final int? expiringMedicines;
  final List<ExpiringItemDto>? expiringList;
  final int? totalMedicines;
  final int? totalCustomers;
  final int? totalSuppliers;
  final List<SalesTrendPointDto>? salesTrend;
  final List<DashboardTopMedicineDto>? topMedicines;
  final num? totalStockValue;
  final num? totalPayables;
  final List<DashboardPayableDto>? topPayables;

  factory DashboardDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardDtoFromJson(json);
}

/// Wire model for `GET pharmacy-api/Dashboard/profit`.
@JsonSerializable(createToJson: false)
class DashboardProfitDto {
  const DashboardProfitDto({this.revenue, this.cost, this.profit});

  final num? revenue;
  final num? cost;
  final num? profit;

  factory DashboardProfitDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardProfitDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SalesTrendPointDto {
  const SalesTrendPointDto({this.date, this.totalAmount});

  final DateTime? date;
  final num? totalAmount;

  factory SalesTrendPointDto.fromJson(Map<String, dynamic> json) =>
      _$SalesTrendPointDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class DashboardTopMedicineDto {
  const DashboardTopMedicineDto({this.medicineId, this.brandName, this.revenue});

  final String? medicineId;
  final String? brandName;
  final num? revenue;

  factory DashboardTopMedicineDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardTopMedicineDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class DashboardPayableDto {
  const DashboardPayableDto({this.partyId, this.partyName, this.balance});

  final String? partyId;
  final String? partyName;
  final num? balance;

  factory DashboardPayableDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardPayableDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class LowStockItemDto {
  const LowStockItemDto({
    this.medicineId,
    this.brandName,
    this.quantityAvailable,
  });

  final String? medicineId;
  final String? brandName;
  final num? quantityAvailable;

  factory LowStockItemDto.fromJson(Map<String, dynamic> json) =>
      _$LowStockItemDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ExpiringItemDto {
  const ExpiringItemDto({
    this.id,
    this.brandName,
    this.expirationDate,
    this.daysLeft,
  });

  final String? id;
  final String? brandName;
  final DateTime? expirationDate;
  final int? daysLeft;

  factory ExpiringItemDto.fromJson(Map<String, dynamic> json) =>
      _$ExpiringItemDtoFromJson(json);
}
