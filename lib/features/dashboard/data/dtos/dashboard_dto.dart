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

  factory DashboardDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardDtoFromJson(json);
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
