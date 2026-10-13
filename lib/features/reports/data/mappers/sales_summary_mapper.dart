import 'package:saydaliati/features/reports/data/dtos/sales_summary_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_summary.dart';

extension SalesSummaryDtoMapper on SalesSummaryDto {
  SalesSummary toEntity() => SalesSummary(
        totalRevenue: (totalRevenue ?? 0).toDouble(),
        invoicesCount: invoicesCount ?? 0,
        costOfGoods: (costOfGoods ?? 0).toDouble(),
        grossProfit: (grossProfit ?? 0).toDouble(),
        byPaymentMethod: (byPaymentMethod ?? const [])
            .map((b) => PaymentMethodBucket(
                  paymentMethod: b.paymentMethod ?? 0,
                  count: b.count ?? 0,
                  total: (b.total ?? 0).toDouble(),
                ))
            .toList(),
        topMedicines: (topMedicines ?? const [])
            .map((m) => TopMedicineSales(
                  medicineId: m.medicineId ?? '',
                  brandName: m.brandName ?? '',
                  quantitySold: (m.quantitySold ?? 0).toDouble(),
                  revenue: (m.revenue ?? 0).toDouble(),
                ))
            .toList(),
      );
}
