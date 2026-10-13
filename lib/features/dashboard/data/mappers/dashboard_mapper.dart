import 'package:saydaliati/features/dashboard/data/dtos/dashboard_dto.dart';
import 'package:saydaliati/features/dashboard/domain/entities/dashboard_summary.dart';

/// DTO → entity mapping for the dashboard. Coalesces nullable wire fields to
/// safe defaults so a partial response degrades gracefully instead of throwing.
extension DashboardDtoMapper on DashboardDto {
  DashboardSummary toEntity() => DashboardSummary(
        salesToday: (salesToday ?? 0).toDouble(),
        salesInvoicesToday: salesInvoicesToday ?? 0,
        purchasesThisMonth: (purchasesThisMonth ?? 0).toDouble(),
        lowStockCount: lowStock ?? lowStockList?.length ?? 0,
        lowStockList:
            (lowStockList ?? const []).map((e) => e.toEntity()).toList(),
        expiringCount: expiringMedicines ?? expiringList?.length ?? 0,
        expiringList:
            (expiringList ?? const []).map((e) => e.toEntity()).toList(),
        totalMedicines: totalMedicines ?? 0,
        totalCustomers: totalCustomers ?? 0,
        totalSuppliers: totalSuppliers ?? 0,
      );
}

extension LowStockItemDtoMapper on LowStockItemDto {
  LowStockItem toEntity() => LowStockItem(
        medicineId: medicineId ?? '',
        brandName: brandName ?? '',
        quantityAvailable: (quantityAvailable ?? 0).toDouble(),
      );
}

extension ExpiringItemDtoMapper on ExpiringItemDto {
  ExpiringItem toEntity() => ExpiringItem(
        id: id ?? '',
        brandName: brandName ?? '',
        expirationDate: expirationDate ?? DateTime.now(),
        daysLeft: daysLeft ?? 0,
      );
}
