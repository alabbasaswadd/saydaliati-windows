// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDto _$DashboardDtoFromJson(Map<String, dynamic> json) => DashboardDto(
  salesToday: json['salesToday'] as num?,
  salesInvoicesToday: (json['salesInvoicesToday'] as num?)?.toInt(),
  purchasesThisMonth: json['purchasesThisMonth'] as num?,
  lowStock: (json['lowStock'] as num?)?.toInt(),
  lowStockList: (json['lowStockList'] as List<dynamic>?)
      ?.map((e) => LowStockItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  expiringMedicines: (json['expiringMedicines'] as num?)?.toInt(),
  expiringList: (json['expiringList'] as List<dynamic>?)
      ?.map((e) => ExpiringItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalMedicines: (json['totalMedicines'] as num?)?.toInt(),
  totalCustomers: (json['totalCustomers'] as num?)?.toInt(),
  totalSuppliers: (json['totalSuppliers'] as num?)?.toInt(),
);

LowStockItemDto _$LowStockItemDtoFromJson(Map<String, dynamic> json) =>
    LowStockItemDto(
      medicineId: json['medicineId'] as String?,
      brandName: json['brandName'] as String?,
      quantityAvailable: json['quantityAvailable'] as num?,
    );

ExpiringItemDto _$ExpiringItemDtoFromJson(Map<String, dynamic> json) =>
    ExpiringItemDto(
      id: json['id'] as String?,
      brandName: json['brandName'] as String?,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      daysLeft: (json['daysLeft'] as num?)?.toInt(),
    );
