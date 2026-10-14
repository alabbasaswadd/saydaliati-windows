import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/accounts/data/datasources/account_remote_data_source.dart';
import 'package:saydaliati/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/domain/repositories/account_repository.dart';

part 'account_providers.g.dart';

/// Composition root for دليل الحسابات — online-only (see [AccountRepository] doc).

@riverpod
AccountRemoteDataSource accountRemoteDataSource(Ref ref) =>
    AccountRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
AccountRepository accountRepository(Ref ref) =>
    AccountRepositoryImpl(ref.watch(accountRemoteDataSourceProvider));

@riverpod
Future<List<Account>> accountsList(Ref ref) async {
  final result = await ref.watch(accountRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}

@riverpod
Future<AccountStatement> accountStatement(
  Ref ref,
  String accountId, {
  DateTime? from,
  DateTime? to,
}) async {
  final result = await ref
      .watch(accountRepositoryProvider)
      .getStatement(accountId, from: from, to: to);
  return result.fold((s) => s, (failure) => throw failure);
}
