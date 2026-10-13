import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/sales/domain/entities/create_sale_input.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';

/// Sales: create (offline-capable via the outbox) + read list/detail.
abstract interface class SaleRepository {
  /// Creates a sale. Works offline-first: online it POSTs immediately; if the
  /// network drops (or the device is offline) it queues the sale for later sync
  /// and reports success optimistically.
  Future<Result<bool>> createSale(CreateSaleInput input);

  Future<Result<List<Sale>>> getSales({
    int? limit,
    int? offset,
    String? fromIso,
    String? toIso,
    String? customerId,
    String? medicineId,
    String? currencyId,
    bool? isPrescription,
  });

  Future<Result<Sale>> getSale(String id);

  /// Updates an existing sale (online). Reverses old stock/journal then
  /// re-applies — the backend handles it atomically.
  Future<Result<bool>> updateSale(String id, CreateSaleInput input);

  /// Deletes a sale (online). The backend restores the deducted stock.
  Future<Result<bool>> deleteSale(String id);

  /// Deletes a still-queued (un-synced) offline sale from the outbox and adds its
  /// quantities back to the local stock cache.
  Future<Result<void>> deleteQueuedSale(String outboxId);

  /// Edits a still-queued (un-synced) offline sale: reverses the old quantities
  /// in the cache, applies the new ones, and replaces the queued request body.
  Future<Result<void>> updateQueuedSale(String outboxId, CreateSaleInput input);
}
