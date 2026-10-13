import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:saydaliati/features/reports/data/repositories/report_repository_impl.dart';
import 'package:saydaliati/features/reports/domain/entities/expiry_report.dart';
import 'package:saydaliati/features/reports/domain/entities/inventory_report.dart';
import 'package:saydaliati/features/reports/domain/entities/medicine_report.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_summary.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_summary.dart';
import 'package:saydaliati/features/reports/domain/entities/stocktake.dart';
import 'package:saydaliati/features/reports/domain/repositories/report_repository.dart';

part 'report_providers.g.dart';

@riverpod
ReportRemoteDataSource reportRemoteDataSource(Ref ref) =>
    ReportRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
ReportRepository reportRepository(Ref ref) =>
    ReportRepositoryImpl(ref.watch(reportRemoteDataSourceProvider));

/// The report for one medicine (keyed by id). Online.
@riverpod
Future<MedicineReport> medicineReport(Ref ref, String medicineId) async {
  final result =
      await ref.watch(reportRepositoryProvider).getMedicineReport(medicineId);
  return result.fold((report) => report, (failure) => throw failure);
}

/// Sales summary for a period (keyed by UTC ISO start/end). Online.
@riverpod
Future<SalesSummary> salesSummary(Ref ref, String startIso, String endIso) async {
  final result = await ref
      .watch(reportRepositoryProvider)
      .getSalesSummary(startIso, endIso);
  return result.fold((summary) => summary, (failure) => throw failure);
}

/// Profit report for a period + optional currency (keyed). Online.
@riverpod
Future<ProfitReport> profitReport(
    Ref ref, String startIso, String endIso, String? currencyId) async {
  final result = await ref
      .watch(reportRepositoryProvider)
      .getProfitReport(startIso, endIso, currencyId);
  return result.fold((report) => report, (failure) => throw failure);
}

/// Batch-level expiry report for a warning window (days). Online.
@riverpod
Future<ExpiryReport> expiryReport(Ref ref, int daysWindow) async {
  final result =
      await ref.watch(reportRepositoryProvider).getExpiryReport(daysWindow);
  return result.fold((report) => report, (failure) => throw failure);
}

/// Purchases summary for a period (keyed by UTC ISO start/end). Online.
@riverpod
Future<PurchasesSummary> purchasesSummary(
    Ref ref, String startIso, String endIso) async {
  final result = await ref
      .watch(reportRepositoryProvider)
      .getPurchasesSummary(startIso, endIso);
  return result.fold((summary) => summary, (failure) => throw failure);
}

/// Inventory report (stock value, quantities, low-stock). Online.
@riverpod
Future<InventoryReport> inventoryReport(Ref ref) async {
  final result = await ref.watch(reportRepositoryProvider).getInventoryReport();
  return result.fold((report) => report, (failure) => throw failure);
}

/// Stocktake: all medicines with per-unit cost/sale prices. Online.
@riverpod
Future<Stocktake> stocktake(Ref ref) async {
  final result = await ref.watch(reportRepositoryProvider).getStocktake();
  return result.fold((report) => report, (failure) => throw failure);
}
