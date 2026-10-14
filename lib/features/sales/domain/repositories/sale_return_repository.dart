import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/sales/domain/entities/sale_return.dart';

/// Sale returns: online-only (no offline outbox) — a return reverses live
/// stock and the customer's debt, which must not be deferred/optimistic.
abstract interface class SaleReturnRepository {
  Future<Result<List<SaleReturnableLine>>> getReturnableLines(String saleId);

  Future<Result<bool>> createReturn(CreateSaleReturnInput input);

  Future<Result<List<SaleReturnSummary>>> getReturns({int? limit, int? offset});
}
