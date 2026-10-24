import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary.freezed.dart';

/// The home dashboard snapshot returned by `GET pharmacy-api/Dashboard`.
/// A pure domain model — no JSON, no Flutter.
@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required double salesToday,
    required int salesInvoicesToday,
    required double purchasesThisMonth,
    required int lowStockCount,
    required List<LowStockItem> lowStockList,
    required int expiringCount,
    required List<ExpiringItem> expiringList,
    required int totalMedicines,
    required int totalCustomers,
    required int totalSuppliers,
    required List<SalesTrendPoint> salesTrend,
    required List<DashboardTopMedicine> topMedicines,
    required double totalStockValue,
    required double totalPayables,
    required List<DashboardPayable> topPayables,
  }) = _DashboardSummary;

  /// An all-zero snapshot — a safe placeholder before the first load.
  factory DashboardSummary.empty() => const DashboardSummary(
        salesToday: 0,
        salesInvoicesToday: 0,
        purchasesThisMonth: 0,
        lowStockCount: 0,
        lowStockList: [],
        expiringCount: 0,
        expiringList: [],
        totalMedicines: 0,
        totalCustomers: 0,
        totalSuppliers: 0,
        salesTrend: [],
        topMedicines: [],
        totalStockValue: 0,
        totalPayables: 0,
        topPayables: [],
      );
}

/// Net profit for a chosen period (day/week/month/year) — `GET
/// pharmacy-api/Dashboard/profit?period=`. Already net of sale returns
/// (same logic as the Sales Summary report).
@freezed
abstract class DashboardProfit with _$DashboardProfit {
  const factory DashboardProfit({
    required double revenue,
    required double cost,
    required double profit,
  }) = _DashboardProfit;

  factory DashboardProfit.empty() =>
      const DashboardProfit(revenue: 0, cost: 0, profit: 0);
}

/// One day's total in the dashboard's 7-day sales-trend chart.
@freezed
abstract class SalesTrendPoint with _$SalesTrendPoint {
  const factory SalesTrendPoint({
    required DateTime date,
    required double totalAmount,
  }) = _SalesTrendPoint;
}

/// A top-selling medicine (by revenue) in the dashboard's ranking chart.
@freezed
abstract class DashboardTopMedicine with _$DashboardTopMedicine {
  const factory DashboardTopMedicine({
    required String medicineId,
    required String brandName,
    required double revenue,
  }) = _DashboardTopMedicine;
}

/// A supplier the pharmacy owes money to, in the dashboard's debts ranking.
@freezed
abstract class DashboardPayable with _$DashboardPayable {
  const factory DashboardPayable({
    required String supplierId,
    required String supplierName,
    required double balance,
  }) = _DashboardPayable;
}

/// A medicine running low on stock.
@freezed
abstract class LowStockItem with _$LowStockItem {
  const factory LowStockItem({
    required String medicineId,
    required String brandName,
    required double quantityAvailable,
  }) = _LowStockItem;
}

/// A medicine approaching its expiry date.
@freezed
abstract class ExpiringItem with _$ExpiringItem {
  const factory ExpiringItem({
    required String id,
    required String brandName,
    required DateTime expirationDate,
    required int daysLeft,
  }) = _ExpiringItem;
}
