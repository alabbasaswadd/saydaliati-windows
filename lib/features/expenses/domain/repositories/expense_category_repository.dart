import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';

abstract interface class ExpenseCategoryRepository {
  Future<Result<List<ExpenseCategory>>> getAll();

  Future<Result<bool>> create({required String name, String? parentId});

  Future<Result<bool>> update({
    required String id,
    required String name,
    String? parentId,
    required bool isActive,
  });

  Future<Result<bool>> delete(String id);
}
