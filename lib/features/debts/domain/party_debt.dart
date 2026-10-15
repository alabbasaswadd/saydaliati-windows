/// نوع الطرف — يطابق `PartyTypeEnum` بالباك.
enum PartyType {
  customer(1, 'عميل'),
  supplier(2, 'مورّد');

  const PartyType(this.wire, this.label);

  final int wire;
  final String label;
}

/// رصيد دين طرف واحد بالعملة الأساسية.
///
/// الرقم موجب دوماً بمعنى «مستحقّ»: على العميل لنا، أو علينا للمورّد —
/// الباك يقلب إشارة المورّد قبل الإرسال، فالواجهة لا تفسّر إشارة.
class PartyDebt {
  const PartyDebt({
    required this.partyId,
    required this.partyName,
    required this.balance,
  });

  final String partyId;
  final String partyName;
  final double balance;

  factory PartyDebt.fromJson(Map<String, dynamic> j) => PartyDebt(
        partyId: (j['partyId'] ?? '').toString(),
        partyName: (j['partyName'] ?? '').toString(),
        balance: ((j['balance'] ?? 0) as num).toDouble(),
      );
}

/// حمولة تسديد دين — كلّه أو قسم منه.
class SettleDebtInput {
  const SettleDebtInput({
    required this.partyType,
    required this.partyId,
    required this.amount,
    required this.paymentAccountId,
    this.currencyId,
    this.date,
    this.note,
  });

  final PartyType partyType;
  final String partyId;

  /// بعملة [currencyId]؛ الخادم يحوّلها بسعره هو.
  final double amount;
  final String paymentAccountId;
  final String? currencyId;
  final DateTime? date;
  final String? note;

  Map<String, dynamic> toJson() => {
        'partyType': partyType.wire,
        'partyId': partyId,
        'amount': amount,
        'paymentAccountId': paymentAccountId,
        'currencyId': currencyId,
        'date': date?.toUtc().toIso8601String(),
        'note': note,
      };
}

/// نتيجة التسديد — المتبقّي محسوبٌ بالخادم لا مقدَّراً بالواجهة.
class SettleDebtResult {
  const SettleDebtResult({
    required this.journalEntryId,
    required this.remainingBalance,
  });

  final String journalEntryId;
  final double remainingBalance;

  factory SettleDebtResult.fromJson(Map<String, dynamic> j) => SettleDebtResult(
        journalEntryId: (j['journalEntryId'] ?? '').toString(),
        remainingBalance: ((j['remainingBalance'] ?? 0) as num).toDouble(),
      );
}
