import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/expenses/data/datasources/expense_category_remote_data_source.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';
import 'package:saydaliati/features/expenses/domain/repositories/expense_category_repository.dart';

class ExpenseCategoryRepositoryImpl implements ExpenseCategoryRepository {
  const ExpenseCategoryRepositoryImpl(this.remote);

  final ExpenseCategoryRemoteDataSource remote;

  @override
  Future<Result<List<ExpenseCategory>>> getAll() async {
    try {
      final raw = await remote.list();
      return Result.success(raw.map(_fromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> create({
    required String name,
    String? parentId,
    String? accountId,
  }) async {
    try {
      await remote.create({
        'name': name,
        'parentId': parentId,
        'accountId': accountId,
      });
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> update({
    required String id,
    required String name,
    String? parentId,
    required bool isActive,
    String? accountId,
  }) async {
    try {
      await remote.update(id, {
        'name': name,
        'parentId': parentId,
        'isActive': isActive,
        'accountId': accountId,
      });
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

  ExpenseCategory _fromJson(Map<String, dynamic> j) => ExpenseCategory(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        parentId: (j['parentId'] as String?),
        isSystem: j['isSystem'] == true,
        isActive: j['isActive'] == true,
        accountId: j['accountId'] as String?,
        accountName: j['accountName'] as String?,
      );
}
