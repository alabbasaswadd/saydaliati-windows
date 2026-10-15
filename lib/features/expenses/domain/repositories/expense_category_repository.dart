import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';

abstract interface class ExpenseCategoryRepository {
  Future<Result<List<ExpenseCategory>>> getAll();

  /// [accountId] اختياري: تصنيف مربوط بحساب يُنشئ قيداً محاسبياً لمصاريفه
  /// فيحرّك رصيد الصندوق؛ غير المربوط يبقى تتبّعاً بحتاً.
  Future<Result<bool>> create({
    required String name,
    String? parentId,
    String? accountId,
  });

  Future<Result<bool>> update({
    required String id,
    required String name,
    String? parentId,
    required bool isActive,
    String? accountId,
  });

  Future<Result<bool>> delete(String id);
}
