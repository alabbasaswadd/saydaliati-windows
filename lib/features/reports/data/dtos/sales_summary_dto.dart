import 'package:json_annotation/json_annotation.dart';

part 'sales_summary_dto.g.dart';

@JsonSerializable(createToJson: false)
class SalesSummaryDto {
  const SalesSummaryDto({
    this.totalRevenue,
    this.invoicesCount,
    this.costOfGoods,
    this.grossProfit,
    this.byPaymentMethod,
    this.topMedicines,
  });

  final num? totalRevenue;
  final int? invoicesCount;
  final num? costOfGoods;
  final num? grossProfit;
  final List<PaymentMethodBucketDto>? byPaymentMethod;
  final List<TopMedicineDto>? topMedicines;

  factory SalesSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$SalesSummaryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaymentMethodBucketDto {
  const PaymentMethodBucketDto({this.paymentMethod, this.count, this.total});

  final int? paymentMethod;
  final int? count;
  final num? total;

  factory PaymentMethodBucketDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodBucketDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class TopMedicineDto {
  const TopMedicineDto({
    this.medicineId,
    this.brandName,
    this.quantitySold,
    this.revenue,
  });

  final String? medicineId;
  final String? brandName;
  final num? quantitySold;
  final num? revenue;

  factory TopMedicineDto.fromJson(Map<String, dynamic> json) =>
      _$TopMedicineDtoFromJson(json);
}
