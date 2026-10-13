import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/purchases/data/datasources/purchase_remote_data_source.dart';
import 'package:saydaliati/features/purchases/data/dtos/purchase_dto.dart';
import 'package:saydaliati/features/purchases/data/mappers/purchase_mapper.dart';
import 'package:saydaliati/features/purchases/domain/entities/create_purchase_input.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/domain/repositories/purchase_repository.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  const PurchaseRepositoryImpl(this._remote);

  final PurchaseRemoteDataSource _remote;

  @override
  Future<Result<void>> create(CreatePurchaseInput input) async {
    try {
      await _remote.create(input.toJson());
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> update(String id, CreatePurchaseInput input) async {
    try {
      await _remote.update(id, input.toUpdateJson(id));
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<List<Purchase>>> getPurchases({int? limit, int? offset}) async {
    try {
      final raw = await _remote.list(limit: limit, offset: offset);
      return Result.success(
          raw.map((m) => PurchaseDto.fromJson(m).toEntity()).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<Purchase>> getPurchase(String id) async {
    try {
      final raw = await _remote.getById(id);
      return Result.success(PurchaseDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
