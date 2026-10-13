import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/suppliers/data/datasources/supplier_remote_data_source.dart';
import 'package:saydaliati/features/suppliers/data/dtos/supplier_dto.dart';
import 'package:saydaliati/features/suppliers/data/mappers/supplier_mapper.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/features/suppliers/domain/repositories/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  const SupplierRepositoryImpl(this._remote);

  final SupplierRemoteDataSource _remote;

  @override
  Future<Result<List<Supplier>>> getSuppliers() async {
    try {
      final raw = await _remote.list();
      return Result.success(
          raw.map((m) => SupplierDto.fromJson(m).toEntity()).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> create(
          {required String name, String contactPerson = '', String email = ''}) =>
      _guard(() => _remote.create(
          {'name': name, 'contactPerson': contactPerson, 'email': email}));

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    String contactPerson = '',
    String email = '',
  }) =>
      _guard(() => _remote.update(
          id, {'name': name, 'contactPerson': contactPerson, 'email': email}));

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
