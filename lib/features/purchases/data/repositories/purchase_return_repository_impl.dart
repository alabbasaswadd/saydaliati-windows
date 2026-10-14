import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/purchases/data/datasources/purchase_return_remote_data_source.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase_return.dart';
import 'package:saydaliati/features/purchases/domain/repositories/purchase_return_repository.dart';

class PurchaseReturnRepositoryImpl implements PurchaseReturnRepository {
  const PurchaseReturnRepositoryImpl(this.remote);

  final PurchaseReturnRemoteDataSource remote;

  @override
  Future<Result<List<PurchaseReturnableLine>>> getReturnableLines(String purchaseId) async {
    try {
      final raw = await remote.returnableLines(purchaseId);
      return Result.success(raw.map(_lineFromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> createReturn(CreatePurchaseReturnInput input) async {
    try {
      await remote.create(input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<List<PurchaseReturnSummary>>> getReturns({int? limit, int? offset}) async {
    try {
      final raw = await remote.list(limit: limit, offset: offset);
      return Result.success(raw.map(_summaryFromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  PurchaseReturnableLine _lineFromJson(Map<String, dynamic> j) => PurchaseReturnableLine(
        purchaseItemId: (j['purchaseItemId'] ?? '').toString(),
        medicineId: (j['medicineId'] ?? '').toString(),
        medicineName: (j['medicineName'] ?? '').toString(),
        unitId: (j['unitId'] ?? '').toString(),
        unitName: (j['unitName'] ?? '').toString(),
        unitPrice: ((j['unitPrice'] ?? 0) as num).toDouble(),
        originalQuantity: ((j['originalQuantity'] ?? 0) as num).toDouble(),
        returnedQuantity: ((j['returnedQuantity'] ?? 0) as num).toDouble(),
        remainingQuantity: ((j['remainingQuantity'] ?? 0) as num).toDouble(),
        availableInStock: ((j['availableInStock'] ?? 0) as num).toDouble(),
      );

  PurchaseReturnSummary _summaryFromJson(Map<String, dynamic> j) {
    final items = (j['items'] as List?) ?? const [];
    return PurchaseReturnSummary(
      id: (j['id'] ?? '').toString(),
      purchaseId: (j['purchaseId'] ?? '').toString(),
      purchaseInvoiceNumber: ((j['purchaseInvoiceNumber'] ?? 0) as num).toInt(),
      returnDate: DateTime.tryParse('${j['returnDate']}') ?? DateTime(1970),
      totalAmount: ((j['totalAmount'] ?? 0) as num).toDouble(),
      itemsCount: items.length,
      reason: (j['reason'] as String?)?.trim().isEmpty ?? true ? null : j['reason'] as String?,
    );
  }
}
