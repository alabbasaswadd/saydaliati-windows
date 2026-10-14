import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense.dart';

/// المصاريف: اتصال مباشر دوماً (بلا outbox) — تسجيل مصروف ليس حرجاً للأداء
/// بخلاف نقطة البيع، ولا حاجة لتعقيد التخزين المحلي هنا.
abstract interface class ExpenseRepository {
  Future<Result<List<Expense>>> getAll({
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  });

  Future<Result<bool>> create(CreateExpenseInput input);

  Future<Result<bool>> update(String id, UpdateExpenseInput input);

  Future<Result<bool>> delete(String id);
}
