import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';

/// دليل الحسابات: اتصال مباشر دوماً (بلا outbox) — بيانات مرجعية قليلة
/// التغيّر، بلا حاجة لتعقيد التخزين المحلي.
abstract interface class AccountRepository {
  Future<Result<List<Account>>> getAll();

  Future<Result<bool>> create(AccountInput input);

  Future<Result<bool>> update(String id, AccountInput input);

  Future<Result<bool>> delete(String id);

  Future<Result<AccountStatement>> getStatement(
    String accountId, {
    DateTime? from,
    DateTime? to,
  });

  /// رصيد افتتاحي لصندوق عملة — سند قيد مزدوج (مدين الصندوق، دائن رأس
  /// المال) بعملة الصندوق نفسها حصراً؛ الخادم يرفض الحسابات بلا عملة.
  Future<Result<bool>> setOpeningBalance(
    String accountId, {
    required double amount,
    DateTime? date,
    String? note,
  });
}
