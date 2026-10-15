import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense.dart';
import 'package:saydaliati/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this.remote);

  final ExpenseRemoteDataSource remote;

  @override
  Future<Result<List<Expense>>> getAll({
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) async {
    try {
      final raw = await remote.list(
        categoryId: categoryId,
        from: from,
        to: to,
        limit: limit,
        offset: offset,
      );
      return Result.success(raw.map(_fromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> create(CreateExpenseInput input) async {
    try {
      await remote.create(input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> update(String id, UpdateExpenseInput input) async {
    try {
      await remote.update(id, input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> delete(String id) async {
    try {
      await remote.delete(id);
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  Expense _fromJson(Map<String, dynamic> j) => Expense(
        id: (j['id'] ?? '').toString(),
        number: ((j['number'] ?? 0) as num).toInt(),
        categoryId: (j['categoryId'] ?? '').toString(),
        categoryName: (j['categoryName'] ?? '').toString(),
        spentOn: DateTime.tryParse('${j['spentOn']}') ?? DateTime(1970),
        note: (j['note'] ?? '').toString(),
        amount: ((j['amount'] ?? 0) as num).toDouble(),
        baseAmount: ((j['baseAmount'] ?? 0) as num).toDouble(),
        currencyId: (j['currencyId'] ?? '').toString(),
        currencyCode: (j['currencyCode'] ?? '').toString(),
        journalEntryId: j['journalEntryId']?.toString(),
        paymentAccountId: (j['paymentAccountId'] ?? '').toString(),
        paymentAccountName: (j['paymentAccountName'] ?? '').toString(),
      );
}
