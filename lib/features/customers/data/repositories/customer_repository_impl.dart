import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:saydaliati/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:saydaliati/features/customers/data/dtos/customer_dto.dart';
import 'package:saydaliati/features/customers/data/mappers/customer_mapper.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/features/customers/domain/repositories/customer_repository.dart';

/// Cache-first customers: refresh from the server when online (and warm the
/// local cache); fall back to the on-device cache otherwise. Writes are
/// online-only.
class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._remote, this._local);

  final CustomerRemoteDataSource _remote;
  final CustomerLocalDataSource _local;

  @override
  Future<Result<List<Customer>>> getCustomers() async {
    try {
      final raw = await _remote.list();
      await _local.replaceAll(raw);
      return Result.success(
          raw.map((m) => CustomerDto.fromJson(m).toEntity()).toList());
    } catch (error) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) {
        return Result.success(
            cached.map((m) => CustomerDto.fromJson(m).toEntity()).toList());
      }
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> create({
    required String firstName,
    String lastName = '',
    String phone = '',
    String address = '',
  }) =>
      _guard(() => _remote.create({
            'firstName': firstName,
            'lastName': lastName,
            'phone': phone,
            'address': address,
          }));

  @override
  Future<Result<void>> update({
    required String id,
    required String firstName,
    String lastName = '',
    String phone = '',
    String address = '',
  }) =>
      _guard(() => _remote.update(id, {
            'firstName': firstName,
            'lastName': lastName,
            'phone': phone,
            'address': address,
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
