import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/damaged_goods/data/datasources/damaged_goods_remote_data_source.dart';
import 'package:saydaliati/features/damaged_goods/domain/entities/create_damaged_goods_input.dart';
import 'package:saydaliati/features/damaged_goods/domain/repositories/damaged_goods_repository.dart';

class DamagedGoodsRepositoryImpl implements DamagedGoodsRepository {
  const DamagedGoodsRepositoryImpl(this._remote);

  final DamagedGoodsRemoteDataSource _remote;

  @override
  Future<Result<bool>> create(CreateDamagedGoodsInput input) async {
    try {
      await _remote.create(input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
