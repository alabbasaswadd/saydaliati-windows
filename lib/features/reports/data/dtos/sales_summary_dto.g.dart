// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesSummaryDto _$SalesSummaryDtoFromJson(Map<String, dynamic> json) =>
    SalesSummaryDto(
      totalRevenue: json['totalRevenue'] as num?,
      invoicesCount: (json['invoicesCount'] as num?)?.toInt(),
      costOfGoods: json['costOfGoods'] as num?,
      grossProfit: json['grossProfit'] as num?,
      byPaymentMethod: (json['byPaymentMethod'] as List<dynamic>?)
          ?.map(
            (e) => PaymentMethodBucketDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      topMedicines: (json['topMedicines'] as List<dynamic>?)
          ?.map((e) => TopMedicineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

PaymentMethodBucketDto _$PaymentMethodBucketDtoFromJson(
  Map<String, dynamic> json,
) => PaymentMethodBucketDto(
  paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
  count: (json['count'] as num?)?.toInt(),
  total: json['total'] as num?,
);

TopMedicineDto _$TopMedicineDtoFromJson(Map<String, dynamic> json) =>
    TopMedicineDto(
      medicineId: json['medicineId'] as String?,
      brandName: json['brandName'] as String?,
      quantitySold: json['quantitySold'] as num?,
      revenue: json['revenue'] as num?,
    );
