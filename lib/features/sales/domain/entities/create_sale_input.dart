import 'package:saydaliati/core/enums/payment_method.dart';

/// The request payload for `POST pharmacy-api/Sale`. Built in-memory by the POS
/// (there is no cart) and serialized straight to the API / offline outbox.
class CreateSaleInput {
  const CreateSaleInput({
    required this.currencyId,
    required this.warehouseId,
    required this.saleDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.lines,
    this.customerId,
    this.note,
    this.originalCurrencyId,
    this.exchangeRate = 1,
    this.amountsInOriginalCurrency = false,
    this.isPrescription = false,
    this.paymentAccountId,
  });

  final String currencyId;
  final String warehouseId;
  final DateTime saleDate;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final List<CreateSaleLineInput> lines;
  final String? customerId;
  final String? note;

  /// The currency the cashier actually transacted in (for audit); amounts above
  /// are stored in the base currency. Null when the sale was in the base.
  final String? originalCurrencyId;

  /// Snapshot of that currency's rate at sale time (units of original per 1
  /// base). Original amount = baseAmount × exchangeRate.
  final double exchangeRate;

  /// المبالغ مُرسَلة **بالعملة الأصلية** كما كتبها المستخدم — الخادم يحوّلها
  /// بسعره هو. يغلق تباعد الأسعار بين جهاز وآخر: كاشيران بسعرين مخزَّنين
  /// مختلفين كانا يُنتجان رقمَي إيراد مختلفين لبيعة واحدة.
  final bool amountsInOriginalCurrency;

  /// Whether this sale is a medical prescription (requires a customer).
  final bool isPrescription;

  /// Actual receiving account (cash/bank); required unless [paymentMethod] is
  /// Credit — defaults in the UI to the cash box matching the sale's currency.
  final String? paymentAccountId;

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'userId': null,
        'currencyId': currencyId,
        'warehouseId': warehouseId,
        'saleDate': saleDate.toIso8601String(),
        'note': note,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod.wire,
        'originalCurrencyId': originalCurrencyId,
        'exchangeRate': exchangeRate,
        'amountsInOriginalCurrency': amountsInOriginalCurrency,
        'isPrescription': isPrescription,
        'paymentAccountId': paymentAccountId,
        'items': lines.map((l) => l.toJson(currencyId, warehouseId)).toList(),
      };
}

/// One line in a [CreateSaleInput].
class CreateSaleLineInput {
  const CreateSaleLineInput({
    required this.medicineId,
    required this.unitId,
    required this.individual,
    required this.quantity,
    this.stockId,
  });

  final String medicineId;
  final String unitId;
  final double individual; // unit price
  final double quantity;
  final String? stockId; // chosen expiry batch (optional)

  Map<String, dynamic> toJson(String currencyId, String warehouseId) => {
        'medicineId': medicineId,
        'unitId': unitId,
        'warehouseId': warehouseId,
        'currencyId': currencyId,
        'individual': individual,
        'quantity': quantity,
        'stockId': stockId,
      };
}
