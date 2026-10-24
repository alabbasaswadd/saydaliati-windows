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
  salesTrend: (json['salesTrend'] as List<dynamic>?)
      ?.map((e) => SalesTrendPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  topMedicines: (json['topMedicines'] as List<dynamic>?)
      ?.map((e) => DashboardTopMedicineDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalStockValue: json['totalStockValue'] as num?,
  totalPayables: json['totalPayables'] as num?,
  topPayables: (json['topPayables'] as List<dynamic>?)
      ?.map((e) => DashboardPayableDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

DashboardProfitDto _$DashboardProfitDtoFromJson(Map<String, dynamic> json) =>
    DashboardProfitDto(
      revenue: json['revenue'] as num?,
      cost: json['cost'] as num?,
      profit: json['profit'] as num?,
    );

SalesTrendPointDto _$SalesTrendPointDtoFromJson(Map<String, dynamic> json) =>
    SalesTrendPointDto(
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      totalAmount: json['totalAmount'] as num?,
    );

DashboardTopMedicineDto _$DashboardTopMedicineDtoFromJson(
  Map<String, dynamic> json,
) => DashboardTopMedicineDto(
  medicineId: json['medicineId'] as String?,
  brandName: json['brandName'] as String?,
  revenue: json['revenue'] as num?,
);

DashboardPayableDto _$DashboardPayableDtoFromJson(Map<String, dynamic> json) =>
    DashboardPayableDto(
      partyId: json['partyId'] as String?,
      partyName: json['partyName'] as String?,
      balance: json['balance'] as num?,
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
