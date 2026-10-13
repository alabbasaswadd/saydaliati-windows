import 'package:saydaliati/features/reports/data/dtos/purchases_summary_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_summary.dart';

extension PurchasesSummaryDtoMapper on PurchasesSummaryDto {
  PurchasesSummary toEntity() => PurchasesSummary(
        totalCost: (totalCost ?? 0).toDouble(),
        invoicesCount: invoicesCount ?? 0,
        topMedicines: (topMedicines ?? const [])
            .map((m) => PurchaseMedicineBucket(
                  medicineId: m.medicineId ?? '',
                  brandName: m.brandName ?? '',
                  quantity: (m.quantity ?? 0).toDouble(),
                  cost: (m.cost ?? 0).toDouble(),
                ))
            .toList(),
        invoices: (invoices ?? const [])
            .map((inv) => PurchaseInvoice(
                  invoiceNumber: inv.invoiceNumber ?? 0,
                  purchaseDate: inv.purchaseDate ?? DateTime(1970),
                  totalAmount: (inv.totalAmount ?? 0).toDouble(),
                  items: (inv.items ?? const [])
                      .map((it) => PurchaseInvoiceLine(
                            brandName: it.brandName ?? '',
                            quantity: (it.quantity ?? 0).toDouble(),
                            unitPrice: (it.unitPrice ?? 0).toDouble(),
                            subTotal: (it.subTotal ?? 0).toDouble(),
                          ))
                      .toList(),
                ))
            .toList(),
      );
}
