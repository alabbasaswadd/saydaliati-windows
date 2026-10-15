/// سجلّ مصروف محفوظ.
///
/// [amount] بعملة المصروف نفسها ([currencyCode]) — هو ما كتبه المستخدم بلا أي
/// تحويل، وهو ما يُعرَض في الشاشة. [baseAmount] مقابله بالعملة الأساسية،
/// مُجمَّد منذ الحفظ، للتقارير الموحَّدة والقيد المحاسبي.
///
/// [journalEntryId] غير فارغ يعني أن تصنيفه مربوط بحساب فأثّر على الأرصدة
/// (نقص الصندوق/البنك، وزاد حساب المصروف).
class Expense {
  const Expense({
    required this.id,
    required this.number,
    required this.categoryId,
    required this.categoryName,
    required this.spentOn,
    required this.note,
    required this.amount,
    required this.currencyCode,
    required this.paymentAccountId,
    required this.paymentAccountName,
    this.baseAmount = 0,
    this.currencyId = '',
    this.journalEntryId,
  });

  final String id;
  final int number;
  final String categoryId;
  final String categoryName;
  final DateTime spentOn;
  final String note;
  final double amount;
  final double baseAmount;
  final String currencyId;
  final String currencyCode;
  final String paymentAccountId;
  final String paymentAccountName;
  final String? journalEntryId;

  /// هل أثّر هذا المصروف على الحسابات فعلاً؟
  bool get isPosted => journalEntryId != null && journalEntryId!.isNotEmpty;
}

/// حمولة `POST pharmacy-api/Expense`.
///
/// [amount] **بعملة [currencyId] كما كتبه المستخدم** — لا تحويل في الواجهة.
/// الخادم يشتقّ المقابل بالعملة الأساسية مرّة واحدة ويجمّده.
class CreateExpenseInput {
  const CreateExpenseInput({
    required this.categoryId,
    required this.spentOn,
    required this.note,
    required this.amount,
    required this.currencyId,
    required this.paymentAccountId,
    this.originalCurrencyId,
    this.exchangeRate = 1,
  });

  final String categoryId;
  final DateTime spentOn;
  final String note;
  final double amount;
  final String currencyId;
  final String paymentAccountId;
  final String? originalCurrencyId;
  final double exchangeRate;

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'spentOn': spentOn.toIso8601String(),
        'note': note,
        'amount': amount,
        'currencyId': currencyId.isEmpty
            ? '00000000-0000-0000-0000-000000000000'
            : currencyId,
        'originalCurrencyId': originalCurrencyId,
        'exchangeRate': exchangeRate <= 0 ? 1 : exchangeRate,
        'paymentAccountId': paymentAccountId,
      };
}

/// حمولة `PUT pharmacy-api/Expense/{id}` — نفس منطق [CreateExpenseInput]،
/// وتقبل تغيير العملة (المبلغ محفوظ بها الآن).
class UpdateExpenseInput {
  const UpdateExpenseInput({
    required this.categoryId,
    required this.spentOn,
    required this.note,
    required this.amount,
    required this.currencyId,
    required this.paymentAccountId,
    this.originalCurrencyId,
    this.exchangeRate = 1,
  });

  final String categoryId;
  final DateTime spentOn;
  final String note;
  final double amount;
  final String currencyId;
  final String paymentAccountId;
  final String? originalCurrencyId;
  final double exchangeRate;

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'spentOn': spentOn.toIso8601String(),
        'note': note,
        'amount': amount,
        'currencyId': currencyId.isEmpty
            ? '00000000-0000-0000-0000-000000000000'
            : currencyId,
        'originalCurrencyId': originalCurrencyId,
        'exchangeRate': exchangeRate <= 0 ? 1 : exchangeRate,
        'paymentAccountId': paymentAccountId,
      };
}
