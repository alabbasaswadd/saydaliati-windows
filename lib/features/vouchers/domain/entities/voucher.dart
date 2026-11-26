/// سطر واحد من سند — حساب + مدين أو دائن (واحد منهما فقط غير صفري).
class VoucherLine {
  const VoucherLine({
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    this.accountCurrencyCode,
    this.notes,
    this.originalDebit = 0,
    this.originalCredit = 0,
  });

  final String accountId;
  final String accountName;

  /// المبلغ بالعملة الأساسية (بعد تحويل الخادم).
  final double debit;
  final double credit;

  /// عملة الحساب (مثل USD) — null إن لم تكن له عملة خاصة.
  final String? accountCurrencyCode;
  final String? notes;

  /// المبلغ الأصلي بعملة المعاملة قبل تحويل الخادم للعملة الأساسية.
  /// يُرجعه الخادم الحديث (amountsInOriginalCurrency)؛ صفر إن لم يُرسله.
  final double originalDebit;
  final double originalCredit;
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

  /// أول سطر له عملة أجنبية (غير أساسية) — المدين أولاً ثم الدائن.
  /// يُستخدَم لتوحيد مصدر [currencyCode] و[originalTotal] حتى لا يختلفا.
  VoucherLine? get _foreignLine =>
      lines.where((l) => l.debit > 0 && l.accountCurrencyCode != null).firstOrNull ??
      lines.where((l) => l.credit > 0 && l.accountCurrencyCode != null).firstOrNull;

  /// عملة السند — مأخوذة من [_foreignLine]؛ null = العملة الأساسية.
  String? get currencyCode => _foreignLine?.accountCurrencyCode;

  /// المبلغ الأصلي بعملة [_foreignLine] إن أرسله الخادم؛ وإلا null.
  /// الواجهة تستخدم هذا لتقرير إن كانت بحاجة لتحويل من العملة الأساسية بسعر الصرف.
  double? get knownOriginalTotal {
    final foreign = _foreignLine;
    if (foreign == null) return null;
    final orig = foreign.debit > 0 ? foreign.originalDebit : foreign.originalCredit;
    return orig > 0 ? orig : null;
  }

  double get originalTotal => knownOriginalTotal ?? totalDebit;
}

/// حمولة تعديل سند مباشر مبسَّط: طرف مدين واحد + طرف دائن واحد بنفس المبلغ.
class UpdateVoucherInput {
  const UpdateVoucherInput({
    required this.id,
    required this.date,
    required this.description,
    required this.debitAccountId,
    required this.creditAccountId,
    required this.amount,
    this.currencyId,
  });

  final String id;
  final DateTime date;
  final String description;
  final String debitAccountId;
  final String creditAccountId;
  final double amount;
  final String? currencyId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'description': description,
        'totalDepit': amount,
        'totalCredit': amount,
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
