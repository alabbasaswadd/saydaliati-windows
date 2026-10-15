/// نوع الحساب بدليل الحسابات — يطابق `AccountTypeEnum` بالباك.
enum AccountType {
  asset(1, 'أصل'),
  liability(2, 'خصم'),
  equity(3, 'حقوق ملكية'),
  revenue(4, 'إيراد'),
  expense(5, 'مصروف'),
  contraAsset(6, 'مقابل أصل');

  const AccountType(this.wire, this.label);

  final int wire;
  final String label;

  static AccountType fromWire(int wire) => AccountType.values.firstWhere(
        (e) => e.wire == wire,
        orElse: () => AccountType.asset,
      );
}

/// حساب من دليل الحسابات.
class Account {
  const Account({
    required this.id,
    required this.name,
    required this.code,
    this.parentId,
    required this.accountType,
    required this.isActive,
    required this.currentBalance,
    required this.isSystem,
    this.currencyId,
    this.currencyCode,
    this.currentBalanceForeign = 0,
  });

  final String id;
  final String name;
  final String code;
  final String? parentId;
  final AccountType accountType;
  final bool isActive;

  /// الرصيد بالعملة الأساسية دوماً.
  final double currentBalance;

  /// الرصيد بعملة الحساب نفسه (currencyCode) — معنىً فقط إن كان [currencyId]
  /// غير null؛ صفر لبقية الحسابات.
  final double currentBalanceForeign;

  /// حساب أساسي من دليل الحسابات المبذور — لا يمكن حذفه من الواجهة.
  final bool isSystem;

  /// عملة هذا الحساب (أساساً لحسابات الصندوق) — null لبقية الحسابات.
  final String? currencyId;

  /// كود عملة الحساب (مثل USD) — للعرض فقط، null إن لم تكن له عملة.
  final String? currencyCode;
}

/// حمولة إنشاء/تعديل حساب.
class AccountInput {
  const AccountInput({
    required this.name,
    required this.code,
    this.parentId,
    required this.accountType,
    this.isActive = true,
    this.currentBalance = 0,
    this.currencyId,
  });

  final String name;
  final String code;
  final String? parentId;
  final AccountType accountType;
  final bool isActive;
  final double currentBalance;
  final String? currencyId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'parentId': parentId,
        'accountType': accountType.wire,
        'isActive': isActive,
        'currentBalance': currentBalance,
        'currencyId': currencyId,
      };
}

/// سطر كشف حساب واحد مع الرصيد المتراكم حتى هذا السطر.
class AccountStatementLine {
  const AccountStatementLine({
    required this.journalEntryId,
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.currencyCode,
    this.originalDebit = 0,
    this.originalCredit = 0,
  });

  final String journalEntryId;
  final DateTime date;
  final String description;
  final double debit;
  final double credit;
  final double runningBalance;

  /// العملة التي أُدخل بها السند — [debit]/[credit] بالأساسية على أي حال.
  final String? currencyCode;

  /// المبلغ بعملة الحساب نفسه — صفر لحساب بلا عملة خاصة.
  final double originalDebit;
  final double originalCredit;
}

/// كشف حساب كامل: الرصيد الافتتاحي/الختامي + السطور.
class AccountStatement {
  const AccountStatement({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.openingBalance,
    required this.closingBalance,
    required this.entries,
    this.baseCurrencyCode,
    this.accountCurrencyCode,
  });

  final String accountId;
  final String accountCode;
  final String accountName;
  final double openingBalance;
  final double closingBalance;
  final List<AccountStatementLine> entries;

  /// وحدة قياس الأرصدة والمدين والدائن في هذا الكشف.
  final String? baseCurrencyCode;

  /// عملة الحساب الخاصة (صناديق العملات) — null لبقية الحسابات.
  final String? accountCurrencyCode;
}
