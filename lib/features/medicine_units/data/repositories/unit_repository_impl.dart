import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/medicine_units/data/datasources/unit_local_data_source.dart';
import 'package:saydaliati/features/medicine_units/data/datasources/unit_remote_data_source.dart';
import 'package:saydaliati/features/medicine_units/data/dtos/unit_dto.dart';
import 'package:saydaliati/features/medicine_units/data/mappers/unit_mapper.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';
import 'package:saydaliati/features/medicine_units/domain/repositories/unit_repository.dart';

class UnitRepositoryImpl implements UnitRepository {
  const UnitRepositoryImpl(this._remote, this._local);

  final UnitRemoteDataSource _remote;
  final UnitLocalDataSource _local;

  Unit _decode(Map<String, dynamic> m) => UnitDto.fromJson(m).toEntity();

  @override
  Future<Result<List<Unit>>> getUnits() async {
    try {
      final raw = await _remote.list();
      // رجوعٌ ناجح (200) بقائمة فارغة غالباً عطل مؤقت بالتوكن أو الخادم، لا
      // وحدات فُرِّغت فعلاً — فلا يُستبدَل به الكاش الصحيح إلا أن يكن فارغاً
      // أصلاً.
      if (raw.isEmpty) {
        final cached = await _local.getAll();
        if (cached.isNotEmpty) return Result.success(cached.map(_decode).toList());
      }
      await _local.replaceAll(raw);
      return Result.success(raw.map(_decode).toList());
    } catch (error) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) return Result.success(cached.map(_decode).toList());
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> create({required String name, String description = ''}) =>
      _guard(() => _remote.create({'name': name, 'description': description}));

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    String description = '',
  }) =>
      _guard(() => _remote
          .update(id, {'id': id, 'name': name, 'description': description}));

  @override
  Future<Result<void>> delete(String id) => _guard(() => _remote.delete(id));

  Future<Result<void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
