/// سطر واحد من سند — حساب + مدين أو دائن (واحد منهما فقط غير صفري).
class VoucherLine {
  const VoucherLine({
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    this.accountCurrencyCode,
    this.notes,
  });

  final String accountId;
  final String accountName;
  final double debit;
  final double credit;

  /// عملة الحساب (مثل USD) — null إن لم تكن له عملة خاصة.
  final String? accountCurrencyCode;
  final String? notes;
}

/// سند (قيد محاسبي) — يدوي أو تابع لفاتورة/مصروف/مرتجع. السندات التابعة
/// (`hasOrigin`) لا تُحذَف/تُعدَّل من واجهة السندات — فقط من مصدرها.
class Voucher {
  const Voucher({
    required this.id,
    required this.date,
    required this.description,
    required this.totalDebit,
    required this.totalCredit,
    required this.hasOrigin,
    required this.lines,
    this.originType,
    this.originId,
    this.originNumber,
  });

  final String id;
  final DateTime date;
  final String description;
  final double totalDebit;
  final double totalCredit;
  final bool hasOrigin;
  final List<VoucherLine> lines;

  /// "Sale" | "Purchase" | "Expense" | "SaleReturn" | "PurchaseReturn" — null
  /// لسند يدوي.
  final String? originType;
  final String? originId;
  final int? originNumber;

  /// اسم الحساب المدين (أول سطر مدين) — للعرض بعمود "مدين".
  String get debitAccountName =>
      lines.where((l) => l.debit > 0).map((l) => l.accountName).firstOrNull ?? '';

  /// اسم الحساب الدائن (أول سطر دائن) — للعرض بعمود "دائن".
  String get creditAccountName =>
      lines.where((l) => l.credit > 0).map((l) => l.accountName).firstOrNull ?? '';

  /// عملة السند — عملة الحساب المدين، أو الدائن إن لم تكن للمدين عملة خاصة
  /// (null إن لم يكن لأي من الطرفين عملة خاصة، أي العملة الأساسية).
  String? get currencyCode =>
      lines.where((l) => l.debit > 0).map((l) => l.accountCurrencyCode).firstOrNull ??
      lines.where((l) => l.credit > 0).map((l) => l.accountCurrencyCode).firstOrNull;
}

/// حمولة إنشاء سند مباشر مبسَّط: طرف مدين واحد + طرف دائن واحد بنفس المبلغ
/// (الحالة الشائعة لسند قبض/دفع). الباك يقبل أسطراً أكثر لكن الواجهة المباشرة
/// تبقى بسيطتين فقط.
class CreateVoucherInput {
  const CreateVoucherInput({
    required this.date,
    required this.description,
    required this.debitAccountId,
    required this.creditAccountId,
    required this.amount,
    this.currencyId,
  });

  final DateTime date;
  final String description;
  final String debitAccountId;
  final String creditAccountId;

  /// المبلغ **كما كتبه المستخدم بعملة [currencyId]** — لا تحويل في الواجهة.
  /// الخادم يحوّله للعملة الأساسية بسعره هو، فيبقى مصدر السعر واحداً ولا
  /// يتحرّك رصيد صندوق العملة بمبلغ لم يُكتَب.
  final double amount;

  /// عملة المبلغ. `null` = العملة الأساسية.
  final String? currencyId;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'description': description,
        'totalDepit': amount,
        'totalCredit': amount,
        'accountId': null,
        'currencyId': currencyId,
        'journalEntryDetails': [
          {
            'accountId': debitAccountId,
            'debit': amount,
            'credit': 0,
            'notes': description,
          },
          {
            'accountId': creditAccountId,
            'debit': 0,
            'credit': amount,
            'notes': description,
          },
        ],
      };
}
