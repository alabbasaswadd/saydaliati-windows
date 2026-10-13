import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/categories/data/datasources/category_local_data_source.dart';
import 'package:saydaliati/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:saydaliati/features/categories/data/dtos/category_dto.dart';
import 'package:saydaliati/features/categories/data/mappers/category_mapper.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';
import 'package:saydaliati/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remote, this._local);

  final CategoryRemoteDataSource _remote;
  final CategoryLocalDataSource _local;

  Category _decode(Map<String, dynamic> m) => CategoryDto.fromJson(m).toEntity();

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final raw = await _remote.list();
      await _local.replaceAll(raw);
      return Result.success(raw.map(_decode).toList());
    } catch (error) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) return Result.success(cached.map(_decode).toList());
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> create({
    required String categoryName,
    String description = '',
  }) =>
      _guard(() => _remote.create({
            'categoryName': categoryName,
            'description': description,
          }));

  @override
  Future<Result<void>> update({
    required String id,
    required String categoryName,
    String description = '',
  }) =>
      _guard(() => _remote.update(id, {
            'id': id,
            'categoryName': categoryName,
            'description': description,
          }));

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
