import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/damaged_goods/domain/entities/create_damaged_goods_input.dart';

abstract class DamagedGoodsRepository {
  Future<Result<bool>> create(CreateDamagedGoodsInput input);
}
