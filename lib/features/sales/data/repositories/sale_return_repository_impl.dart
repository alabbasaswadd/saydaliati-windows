import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/sales/data/datasources/sale_return_remote_data_source.dart';
import 'package:saydaliati/features/sales/domain/entities/sale_return.dart';
import 'package:saydaliati/features/sales/domain/repositories/sale_return_repository.dart';

class SaleReturnRepositoryImpl implements SaleReturnRepository {
  const SaleReturnRepositoryImpl(this.remote);

  final SaleReturnRemoteDataSource remote;

  @override
  Future<Result<List<SaleReturnableLine>>> getReturnableLines(String saleId) async {
    try {
      final raw = await remote.returnableLines(saleId);
      return Result.success(raw.map(_lineFromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> createReturn(CreateSaleReturnInput input) async {
    try {
      await remote.create(input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<List<SaleReturnSummary>>> getReturns({int? limit, int? offset}) async {
    try {
      final raw = await remote.list(limit: limit, offset: offset);
      return Result.success(raw.map(_summaryFromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  SaleReturnableLine _lineFromJson(Map<String, dynamic> j) => SaleReturnableLine(
        saleItemId: (j['saleItemId'] ?? '').toString(),
        medicineId: (j['medicineId'] ?? '').toString(),
        medicineName: (j['medicineName'] ?? '').toString(),
        unitId: (j['unitId'] ?? '').toString(),
        unitName: (j['unitName'] ?? '').toString(),
        unitPrice: ((j['unitPrice'] ?? 0) as num).toDouble(),
        originalQuantity: ((j['originalQuantity'] ?? 0) as num).toDouble(),
        returnedQuantity: ((j['returnedQuantity'] ?? 0) as num).toDouble(),
        remainingQuantity: ((j['remainingQuantity'] ?? 0) as num).toDouble(),
      );

  SaleReturnSummary _summaryFromJson(Map<String, dynamic> j) {
    final items = (j['items'] as List?) ?? const [];
    return SaleReturnSummary(
      id: (j['id'] ?? '').toString(),
      saleId: (j['saleId'] ?? '').toString(),
      saleInvoiceNumber: ((j['saleInvoiceNumber'] ?? 0) as num).toInt(),
      returnDate: DateTime.tryParse('${j['returnDate']}') ?? DateTime(1970),
      totalAmount: ((j['totalAmount'] ?? 0) as num).toDouble(),
      itemsCount: items.length,
      reason: (j['reason'] as String?)?.trim().isEmpty ?? true ? null : j['reason'] as String?,
    );
  }
}
