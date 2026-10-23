import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/manufacturers/data/datasources/manufacturer_local_data_source.dart';
import 'package:saydaliati/features/manufacturers/data/datasources/manufacturer_remote_data_source.dart';
import 'package:saydaliati/features/manufacturers/data/dtos/manufacturer_dto.dart';
import 'package:saydaliati/features/manufacturers/data/mappers/manufacturer_mapper.dart';
import 'package:saydaliati/features/manufacturers/domain/entities/manufacturer.dart';
import 'package:saydaliati/features/manufacturers/domain/repositories/manufacturer_repository.dart';

class ManufacturerRepositoryImpl implements ManufacturerRepository {
  const ManufacturerRepositoryImpl(this._remote, this._local);

  final ManufacturerRemoteDataSource _remote;
  final ManufacturerLocalDataSource _local;

  Manufacturer _decode(Map<String, dynamic> m) =>
      ManufacturerDto.fromJson(m).toEntity();

  @override
  Future<Result<List<Manufacturer>>> getManufacturers() async {
    try {
      final raw = await _remote.list();
      // رجوعٌ ناجح (200) بقائمة فارغة غالباً عطل مؤقت بالتوكن أو الخادم، لا
      // شركات فُرِّغت فعلاً — فلا يُستبدَل به الكاش الصحيح إلا أن يكن فارغاً
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
  Future<Result<void>> create({required String name, String location = ''}) =>
      _guard(() => _remote.create({'name': name, 'location': location}));

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    String location = '',
  }) =>
      _guard(() =>
          _remote.update(id, {'id': id, 'name': name, 'location': location}));

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
