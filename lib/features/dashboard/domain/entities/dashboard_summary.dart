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
      );
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
