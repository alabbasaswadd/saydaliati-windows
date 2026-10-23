import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/purchases/domain/entities/create_purchase_input.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';

/// Purchases — create invoice + read list/detail. Online-only.
abstract interface class PurchaseRepository {
  Future<Result<void>> create(CreatePurchaseInput input);

  /// Edits an existing purchase invoice (online). The backend reverses the old
  /// stock then re-applies the new lines and recomputes the medicine cost.
  Future<Result<void>> update(String id, CreatePurchaseInput input);

  Future<Result<List<Purchase>>> getPurchases({int? limit, int? offset});
  Future<Result<Purchase>> getPurchase(String id);

  /// Deletes a purchase invoice (online). The backend reverses the stock it
  /// added (fails if some of it was already consumed) and its journal entry.
  Future<Result<void>> delete(String id);
}
