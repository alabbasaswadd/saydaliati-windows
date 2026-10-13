import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/categories/data/datasources/category_local_data_source.dart';
import 'package:saydaliati/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:saydaliati/features/categories/data/repositories/category_repository_impl.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';
import 'package:saydaliati/features/categories/domain/repositories/category_repository.dart';

part 'category_providers.g.dart';

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) =>
    CategoryRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
CategoryLocalDataSource categoryLocalDataSource(Ref ref) =>
    CategoryLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
CategoryRepository categoryRepository(Ref ref) => CategoryRepositoryImpl(
      ref.watch(categoryRemoteDataSourceProvider),
      ref.watch(categoryLocalDataSourceProvider),
    );

/// The category list as an [AsyncValue] (cache-first).
@riverpod
Future<List<Category>> categories(Ref ref) async {
  final result = await ref.watch(categoryRepositoryProvider).getCategories();
  return result.fold((list) => list, (failure) => throw failure);
}
