import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/reports/domain/entities/expiry_report.dart';
import 'package:saydaliati/features/reports/domain/entities/inventory_report.dart';
import 'package:saydaliati/features/reports/domain/entities/medicine_report.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_grid.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_summary.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_grid.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_summary.dart';
import 'package:saydaliati/features/reports/domain/entities/stocktake.dart';

abstract interface class ReportRepository {
  Future<Result<MedicineReport>> getMedicineReport(String medicineId);

  Future<Result<SalesSummary>> getSalesSummary(String startDate, String endDate);

  /// Sales tree-grid (invoice + line items + profit) for a period.
  Future<Result<List<SalesGridInvoice>>> getSalesGrid(
      String startDate, String endDate);

  /// Purchases tree-grid (invoice + line items) for a period.
  Future<Result<List<PurchasesGridInvoice>>> getPurchasesGrid(
      String startDate, String endDate);

  Future<Result<ProfitReport>> getProfitReport(
      String startDate, String endDate, String? currencyId);

  Future<Result<ExpiryReport>> getExpiryReport(int daysWindow);

  Future<Result<PurchasesSummary>> getPurchasesSummary(
      String startDate, String endDate);

  Future<Result<InventoryReport>> getInventoryReport();

  Future<Result<Stocktake>> getStocktake();
}
