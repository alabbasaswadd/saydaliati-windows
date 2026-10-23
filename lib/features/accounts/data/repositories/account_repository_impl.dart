import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/accounts/data/datasources/account_local_data_source.dart';
import 'package:saydaliati/features/accounts/data/datasources/account_remote_data_source.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/domain/repositories/account_repository.dart';

/// دليل الحسابات: **الخادم ما دام متاحاً، والنسخة المحلّية عند تعذُّره.**
///
/// كان القراءة من الخادم وحده، فانقطاعُ الشبكة يُفرِغ قائمة الحسابات: لا
/// سند قبضٍ ولا دفعٍ ولا فاتورةٍ آجلة — والصيدلية تعمل بلا إنترنت كثيراً.
///
/// والخادم يبقى المرجع متى أجاب: الأرصدة تتغيّر مع كل حركة، فنسخةٌ محلّية
/// تُقدَّم على إجابةٍ حيّة تعرض رصيداً قديماً. والكتابة (إنشاء/تعديل/حذف)
/// تبقى متّصلةً وحدها — حسابٌ يُنشَأ محلياً يُنتج رمزاً يصطدم بما يُنشئه
/// جهازٌ آخر.
class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl(this.remote, this.local);

  final AccountRemoteDataSource remote;
  final AccountLocalDataSource local;

  @override
  Future<Result<List<Account>>> getAll() async {
    try {
      final raw = await remote.list();
      // رجوعٌ ناجح (200) بقائمة فارغة ليس بالضرورة أن دليل الحسابات فُرِّغ
      // فعلاً — غالباً عطل مؤقت بالتوكن أو الخادم. لا تُستبدَل به النسخة
      // المحلّية الصحيحة إلا أن تكن فارغة أصلاً (أول تشغيل)، وإلا امتُحي دليل
      // سليم فتُعطَّل شاشات السندات والفواتير الآجلة بلا اتصال — وتُعاد
      // النسخة المحلّية نفسها بدل قائمة فارغة لا تصف شيئاً حقيقياً.
      if (raw.isEmpty) {
        final cached = await local.getAll();
        if (cached.isNotEmpty) {
          return Result.success(cached.map(_accountFromJson).toList());
        }
      }
      await local.replaceAll(raw);
      return Result.success(raw.map(_accountFromJson).toList());
    } catch (error) {
      final cached = await local.getAll();
      if (cached.isNotEmpty) {
        return Result.success(cached.map(_accountFromJson).toList());
      }
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> create(AccountInput input) async {
    try {
      await remote.create(input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> update(String id, AccountInput input) async {
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

  /// كشف الحساب يبقى متّصلاً: رصيدٌ متراكمٌ يحسبه الخادم من قيوده، وكشفٌ
  /// قديمٌ معروضٌ على أنه الحالي أسوأ من رسالة «لا اتصال».
  @override
  Future<Result<AccountStatement>> getStatement(
    String accountId, {
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final raw = await remote.statement(accountId, from: from, to: to);
      return Result.success(_statementFromJson(raw));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> setOpeningBalance(
    String accountId, {
    required double amount,
    DateTime? date,
    String? note,
  }) async {
    try {
      await remote.setOpeningBalance(accountId, amount: amount, date: date, note: note);
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  Account _accountFromJson(Map<String, dynamic> j) => Account(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        code: (j['code'] ?? '').toString(),
        parentId: j['parentId'] as String?,
        accountType: AccountType.fromWire(((j['accountType'] ?? 1) as num).toInt()),
        isActive: j['isActive'] == true,
        currentBalance: ((j['currentBalance'] ?? 0) as num).toDouble(),
        isSystem: j['isSystem'] == true,
        currencyId: j['currencyId'] as String?,
        currencyCode: j['currencyCode'] as String?,
        currentBalanceForeign: ((j['currentBalanceForeign'] ?? 0) as num).toDouble(),
      );

  AccountStatement _statementFromJson(Map<String, dynamic> j) {
    final entries = (j['entries'] as List?) ?? const [];
    return AccountStatement(
      accountId: (j['accountId'] ?? '').toString(),
      accountCode: (j['accountCode'] ?? '').toString(),
      accountName: (j['accountName'] ?? '').toString(),
      openingBalance: ((j['openingBalance'] ?? 0) as num).toDouble(),
      closingBalance: ((j['closingBalance'] ?? 0) as num).toDouble(),
      baseCurrencyCode: j['baseCurrencyCode'] as String?,
      accountCurrencyCode: j['accountCurrencyCode'] as String?,
      entries: entries
          .whereType<Map<String, dynamic>>()
          .map(_lineFromJson)
          .toList(),
    );
  }

  AccountStatementLine _lineFromJson(Map<String, dynamic> j) => AccountStatementLine(
        journalEntryId: (j['journalEntryId'] ?? '').toString(),
        date: DateTime.tryParse('${j['date']}') ?? DateTime(1970),
        description: (j['description'] ?? '').toString(),
        debit: ((j['debit'] ?? 0) as num).toDouble(),
        credit: ((j['credit'] ?? 0) as num).toDouble(),
        runningBalance: ((j['runningBalance'] ?? 0) as num).toDouble(),
        currencyCode: j['currencyCode'] as String?,
        originalDebit: ((j['originalDebit'] ?? 0) as num).toDouble(),
        originalCredit: ((j['originalCredit'] ?? 0) as num).toDouble(),
      );
}
