import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/medicines/data/datasources/medicine_local_data_source.dart';
import 'package:saydaliati/features/medicines/data/datasources/medicine_remote_data_source.dart';
import 'package:saydaliati/features/medicines/data/dtos/medicine_dto.dart';
import 'package:saydaliati/features/medicines/data/mappers/medicine_mapper.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine_input.dart';
import 'package:saydaliati/features/medicines/domain/repositories/medicine_repository.dart';

/// Cache-first medicine catalog: refresh from the server when online; fall back
/// to the on-device cache otherwise. Writes are online-only.
class MedicineRepositoryImpl implements MedicineRepository {
  const MedicineRepositoryImpl(this._remote, this._local);

  final MedicineRemoteDataSource _remote;
  final MedicineLocalDataSource _local;

  Medicine _decode(Map<String, dynamic> m) => MedicineDto.fromJson(m).toEntity();

  /// Alphabetical by the displayed (Arabic-first) name so the UI order is stable
  /// regardless of whether the list came from the server or the local cache.
  List<Medicine> _decodeSorted(List<Map<String, dynamic>> raw) {
    final list = raw.map(_decode).toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
    return list;
  }

  @override
  Future<Result<List<Medicine>>> getCatalog() async {
    try {
      final raw = await _remote.list();
      await _local.replaceAll(raw);
      return Result.success(_decodeSorted(raw));
    } catch (error) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) {
        return Result.success(_decodeSorted(cached));
      }
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<List<Medicine>> cachedCatalog() async {
    final cached = await _local.getAll();
    return _decodeSorted(cached);
  }

  @override
  Future<List<Medicine>> searchOnline(String name) async {
    final raw = await _remote.list(name: name, limit: 50);
    // Write found items through the cache so they're available offline next time.
    for (final m in raw) {
      await _local.upsertRaw(m);
    }
    return _decodeSorted(raw);
  }

  @override
  Future<Medicine?> fetchOne(String id) async {
    try {
      final raw = await _remote.getById(id);
      await _local.upsertRaw(raw); // write-through so the cache stays correct
      return _decode(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result<String>> create(CreateMedicineInput input) async {
    try {
      final id = await _remote.create(input.toJson());
      return Result.success(id);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> update(String id, CreateMedicineInput input) =>
      _guard(() async {
        await _remote.update(id, input.toUpdateJson(id));
        await _refreshLocal(id); // write-through so offline cache isn't stale
      });

  @override
  Future<Result<void>> updatePrices(String id, Map<String, double> prices) =>
      _guard(() async {
        await _remote.updatePrices(id, prices);
        await _refreshLocal(id); // write-through so offline cache isn't stale
      });

  @override
  Future<Result<void>> delete(String id) => _guard(() async {
        await _remote.delete(id);
        await _local.removeById(id); // drop from cache so it won't show offline
      });

  /// Best-effort: re-pull one medicine from the server into the local cache
  /// after a mutation so the offline copy (and its indexed columns) stay correct.
  Future<void> _refreshLocal(String id) async {
    try {
      final raw = await _remote.getById(id);
      await _local.upsertRaw(raw);
    } catch (_) {/* network hiccup — next full sync will correct it */}
  }

  @override
  Future<Result<Medicine>> assignBarcode(String id, String barcode) async {
    try {
      final updated = await _remote.setBarcode(id, barcode);
      // Write-through: refresh this medicine in the cache with the server copy
      // (keeps the indexed barcode column correct for offline scanning).
      await _local.upsertRaw(updated);
      return Result.success(_decode(updated));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<void> cacheBarcodeLocally(String id, String barcode) =>
      _local.fillBarcode(id, barcode);

  Future<Result<void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
