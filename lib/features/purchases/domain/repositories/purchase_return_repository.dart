import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase_return.dart';

/// Purchase returns: online-only (no offline outbox) — a return reverses live
/// stock and our debt to the supplier, which must not be deferred/optimistic.
abstract interface class PurchaseReturnRepository {
  Future<Result<List<PurchaseReturnableLine>>> getReturnableLines(String purchaseId);

  Future<Result<bool>> createReturn(CreatePurchaseReturnInput input);

  Future<Result<List<PurchaseReturnSummary>>> getReturns({int? limit, int? offset});
}
