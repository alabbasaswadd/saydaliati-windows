import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/debts/data/debt_remote_data_source.dart';
import 'package:saydaliati/features/debts/domain/party_debt.dart';

part 'debt_providers.g.dart';

/// تجميع ميزة الديون — متّصلة فقط: الرصيد قرار مالي، فلا يُقرأ من كاش قد
/// يكون أقدم من تسديدٍ جرى على جهاز آخر.
@riverpod
DebtRemoteDataSource debtRemoteDataSource(Ref ref) =>
    DebtRemoteDataSource(ref.watch(apiClientProvider));

/// ديون العملاء — المستحقّ لنا.
@riverpod
Future<List<PartyDebt>> customerDebts(Ref ref) async {
  final rows = await ref.watch(debtRemoteDataSourceProvider).receivables();
  return rows.map(PartyDebt.fromJson).toList();
}

/// ديون الموردين — المستحقّ علينا.
@riverpod
Future<List<PartyDebt>> supplierDebts(Ref ref) async {
  final rows = await ref.watch(debtRemoteDataSourceProvider).payables();
  return rows.map(PartyDebt.fromJson).toList();
}

/// تسديد دين. يُعيد المتبقّي كما حسبه الخادم.
@riverpod
Future<SettleDebtResult> Function(SettleDebtInput) settleDebt(Ref ref) {
  return (input) async {
    final json = await ref
        .read(debtRemoteDataSourceProvider)
        .settle(input.toJson());
    return SettleDebtResult.fromJson(json);
  };
}
