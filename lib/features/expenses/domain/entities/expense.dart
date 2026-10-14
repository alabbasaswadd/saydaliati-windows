/// سجلّ مصروف محفوظ — تتبّع بحت بهذه المرحلة، بلا قيد محاسبي (راجع
/// EXPENSES_PLAN.md §6 للمرحلة اللاحقة). مصدر الدفع حساب حقيقي من دليل
/// الحسابات (الصندوق/البنك/أي حساب آخر)، لا تعداد ثابت.
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
  });

  final String id;
  final int number;
  final String categoryId;
  final String categoryName;
  final DateTime spentOn;
  final String note;
  final double amount;
  final String currencyCode;
  final String paymentAccountId;
  final String paymentAccountName;
}

/// حمولة `POST pharmacy-api/Expense` — [amount] دوماً بعملة الصيدلية الأساسية
/// (الواجهة تحوِّله قبل الإرسال عبر `convertToBase`)؛ [originalCurrencyId] +
/// [exchangeRate] هما ما اختاره المستخدم فعلياً، للتدقيق فقط — بنفس نمط فاتورة البيع.
class CreateExpenseInput {
  const CreateExpenseInput({
    required this.categoryId,
    required this.spentOn,
    required this.note,
    required this.amount,
    required this.paymentAccountId,
    this.originalCurrencyId,
    this.exchangeRate = 1,
  });

  final String categoryId;
  final DateTime spentOn;
  final String note;
  final double amount;
  final String paymentAccountId;
  final String? originalCurrencyId;
  final double exchangeRate;

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'spentOn': spentOn.toIso8601String(),
        'note': note,
        'amount': amount,
        'currencyId': '00000000-0000-0000-0000-000000000000',
        'originalCurrencyId': originalCurrencyId,
        'exchangeRate': exchangeRate <= 0 ? 1 : exchangeRate,
        'paymentAccountId': paymentAccountId,
      };
}

/// حمولة `PUT pharmacy-api/Expense/{id}` — نفس منطق [CreateExpenseInput]؛
/// عملة التخزين الأساسية للمصروف لا تتغيّر بالتعديل (الباك لا يقبلها هنا).
class UpdateExpenseInput {
  const UpdateExpenseInput({
    required this.categoryId,
    required this.spentOn,
    required this.note,
    required this.amount,
    required this.paymentAccountId,
    this.originalCurrencyId,
    this.exchangeRate = 1,
  });

  final String categoryId;
  final DateTime spentOn;
  final String note;
  final double amount;
  final String paymentAccountId;
  final String? originalCurrencyId;
  final double exchangeRate;

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'spentOn': spentOn.toIso8601String(),
        'note': note,
        'amount': amount,
        'originalCurrencyId': originalCurrencyId,
        'exchangeRate': exchangeRate <= 0 ? 1 : exchangeRate,
        'paymentAccountId': paymentAccountId,
      };
}
