import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:saydaliati/features/reports/data/dtos/expiry_report_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/inventory_report_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/medicine_report_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/profit_report_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/purchases_grid_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/purchases_summary_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/sales_grid_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/sales_summary_dto.dart';
import 'package:saydaliati/features/reports/data/dtos/stocktake_dto.dart';
import 'package:saydaliati/features/reports/data/mappers/expiry_report_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/inventory_report_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/medicine_report_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/profit_report_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/purchases_grid_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/purchases_summary_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/sales_grid_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/sales_summary_mapper.dart';
import 'package:saydaliati/features/reports/data/mappers/stocktake_mapper.dart';
import 'package:saydaliati/features/reports/domain/entities/expiry_report.dart';
import 'package:saydaliati/features/reports/domain/entities/inventory_report.dart';
import 'package:saydaliati/features/reports/domain/entities/medicine_report.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_grid.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_summary.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_grid.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_summary.dart';
import 'package:saydaliati/features/reports/domain/entities/stocktake.dart';
import 'package:saydaliati/features/reports/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._remote);

  final ReportRemoteDataSource _remote;

  @override
  Future<Result<MedicineReport>> getMedicineReport(String medicineId) async {
    try {
      final raw = await _remote.medicineReport(medicineId);
      return Result.success(MedicineReportDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<SalesSummary>> getSalesSummary(
      String startDate, String endDate) async {
    try {
      final raw = await _remote.salesSummary(startDate, endDate);
      return Result.success(SalesSummaryDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<ProfitReport>> getProfitReport(
      String startDate, String endDate, String? currencyId) async {
    try {
      final raw = await _remote.profitReport(startDate, endDate, currencyId);
      return Result.success(ProfitReportDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<List<SalesGridInvoice>>> getSalesGrid(
      String startDate, String endDate) async {
    try {
      final raw = await _remote.salesGrid(startDate, endDate);
      return Result.success([
        for (final e in raw) SalesGridInvoiceDto.fromJson(e).toEntity(),
      ]);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<List<PurchasesGridInvoice>>> getPurchasesGrid(
      String startDate, String endDate) async {
    try {
      final raw = await _remote.purchasesGrid(startDate, endDate);
      return Result.success([
        for (final e in raw) PurchasesGridInvoiceDto.fromJson(e).toEntity(),
      ]);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<ExpiryReport>> getExpiryReport(int daysWindow) async {
    try {
      final raw = await _remote.expiryReport(daysWindow);
      return Result.success(ExpiryReportDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<PurchasesSummary>> getPurchasesSummary(
      String startDate, String endDate) async {
    try {
      final raw = await _remote.purchasesSummary(startDate, endDate);
      return Result.success(PurchasesSummaryDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<InventoryReport>> getInventoryReport() async {
    try {
      final raw = await _remote.inventoryReport();
      return Result.success(InventoryReportDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<Stocktake>> getStocktake() async {
    try {
      final raw = await _remote.stocktake();
      return Result.success(StocktakeDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
