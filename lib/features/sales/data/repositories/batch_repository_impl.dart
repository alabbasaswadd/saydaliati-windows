import 'package:saydaliati/features/sales/data/datasources/batch_remote_data_source.dart';
import 'package:saydaliati/features/sales/domain/entities/medicine_batch.dart';
import 'package:saydaliati/features/stock/data/datasources/stock_local_data_source.dart';

/// Loads a medicine's available batches for the POS, offline-aware:
/// * online → fetch from the server and write them through to the local stock
///   cache (so later offline sessions have fresh quantities);
/// * offline (or on a network error) → read the cached batches.
class BatchRepository {
  const BatchRepository({
    required this.remote,
    required this.stockLocal,
    required this.isOnline,
  });

  final BatchRemoteDataSource remote;
  final StockLocalDataSource stockLocal;
  final bool Function() isOnline;

  Future<List<MedicineBatch>> forMedicine(
      String medicineId, String warehouseId) async {
    if (isOnline()) {
      try {
        final batches = await remote.forMedicine(medicineId, warehouseId);
        await stockLocal.replaceForMedicine(medicineId, [
          for (final b in batches)
            {
              'id': b.stockId,
              'medicineId': medicineId,
              'warehouseId': warehouseId,
              'quantityAvailable': b.quantityAvailable,
              'expiryDate': b.expiryDate?.toIso8601String(),
            },
        ]);
        return batches;
      } catch (_) {
        // fall through to the cache
      }
    }
    final cached = await stockLocal.cachedBatchesForMedicine(
      medicineId,
      warehouseId: warehouseId,
    );
    return cached
        .map((m) => MedicineBatch(
              stockId: (m['id'] ?? m['stockId'] ?? '').toString(),
              quantityAvailable: ((m['quantityAvailable'] ?? 0) as num).toDouble(),
              expiryDate: DateTime.tryParse('${m['expiryDate'] ?? ''}'),
            ))
        .toList();
  }
}
