import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';

/// Read + manage categories. Reads are cache-first; writes are online-only.
abstract interface class CategoryRepository {
  Future<Result<List<Category>>> getCategories();
  Future<Result<void>> create({required String categoryName, String description});
  Future<Result<void>> update({
    required String id,
    required String categoryName,
    String description,
  });
  Future<Result<void>> delete(String id);
}
