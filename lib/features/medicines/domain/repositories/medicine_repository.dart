import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine_input.dart';

/// Read + manage the medicine catalog. Reads are cache-first (so the POS can
/// scan/search offline); writes are online-only.
abstract interface class MedicineRepository {
  /// The whole catalog (cache-first). Loaded into memory by the POS/list screens.
  Future<Result<List<Medicine>>> getCatalog();

  /// The on-device cached catalog only (no network). Empty on the very first run
  /// before any sync — used to decide whether to show the first-load screen.
  Future<List<Medicine>> cachedCatalog();

  /// Online search by name (server-side) — used as a fallback when the offline
  /// catalog has no match. Found items are written through the cache.
  Future<List<Medicine>> searchOnline(String name);

  /// Fetch ONE medicine from the server and write it through the local cache;
  /// returns it decoded (or null on failure). Lets callers refresh a single row
  /// after an edit/pricing instead of re-pulling the whole (now large) catalog.
  Future<Medicine?> fetchOne(String id);

  /// Creates a medicine; on success returns its new server id so the caller can
  /// fetch it and insert it into the cache/catalog without a full re-pull.
  Future<Result<String>> create(CreateMedicineInput input);
  Future<Result<void>> update(String id, CreateMedicineInput input);

  /// Quick pricing: update only the sale prices of a medicine's units
  /// ([prices] maps unitId → salePrice). Leaves all other fields intact.
  Future<Result<void>> updatePrices(String id, Map<String, double> prices);

  Future<Result<void>> delete(String id);

  /// Assigns a barcode to an existing medicine (e.g. a scanned-but-unknown code
  /// in a sale). On success the on-device cache is updated write-through so the
  /// medicine is immediately scannable, and the updated [Medicine] is returned.
  Future<Result<Medicine>> assignBarcode(String id, String barcode);

  /// Mirror a barcode that was set server-side (e.g. via a purchase invoice)
  /// into the local cache — fills only an empty barcode. Local-only, no network.
  Future<void> cacheBarcodeLocally(String id, String barcode);
}
