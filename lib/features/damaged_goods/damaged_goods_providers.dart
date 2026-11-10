import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/damaged_goods/data/datasources/damaged_goods_remote_data_source.dart';
import 'package:saydaliati/features/damaged_goods/data/repositories/damaged_goods_repository_impl.dart';
import 'package:saydaliati/features/damaged_goods/domain/repositories/damaged_goods_repository.dart';

part 'damaged_goods_providers.g.dart';

@riverpod
DamagedGoodsRemoteDataSource damagedGoodsRemoteDataSource(Ref ref) =>
    DamagedGoodsRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
DamagedGoodsRepository damagedGoodsRepository(Ref ref) =>
    DamagedGoodsRepositoryImpl(ref.watch(damagedGoodsRemoteDataSourceProvider));
