import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/expenses/data/datasources/expense_category_remote_data_source.dart';
import 'package:saydaliati/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:saydaliati/features/expenses/data/repositories/expense_category_repository_impl.dart';
import 'package:saydaliati/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';
import 'package:saydaliati/features/expenses/domain/repositories/expense_category_repository.dart';
import 'package:saydaliati/features/expenses/domain/repositories/expense_repository.dart';

part 'expense_providers.g.dart';

/// Composition root for the expenses feature — online-only (see
/// [ExpenseRepository] doc), بلا outbox ولا تخزين محلي.

@riverpod
ExpenseCategoryRemoteDataSource expenseCategoryRemoteDataSource(Ref ref) =>
    ExpenseCategoryRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
ExpenseCategoryRepository expenseCategoryRepository(Ref ref) =>
    ExpenseCategoryRepositoryImpl(ref.watch(expenseCategoryRemoteDataSourceProvider));

@riverpod
Future<List<ExpenseCategory>> expenseCategories(Ref ref) async {
  final result = await ref.watch(expenseCategoryRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}

@riverpod
ExpenseRemoteDataSource expenseRemoteDataSource(Ref ref) =>
    ExpenseRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
ExpenseRepository expenseRepository(Ref ref) =>
    ExpenseRepositoryImpl(ref.watch(expenseRemoteDataSourceProvider));

@riverpod
Future<List<Expense>> expensesList(Ref ref) async {
  final result = await ref.watch(expenseRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}
