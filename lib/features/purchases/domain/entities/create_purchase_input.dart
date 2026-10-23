import 'package:saydaliati/core/enums/payment_method.dart';

/// Payload for `POST pharmacy-api/Purchase`. Built in-memory by the purchase
/// screen and serialized straight to the API.
class CreatePurchaseInput {
  const CreatePurchaseInput({
    required this.currencyId,
    required this.warehouseId,
    required this.purchaseDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.lines,
    this.supplierId,
    this.note,
    this.paymentAccountId,
    this.originalCurrencyId,
    this.amountsInOriginalCurrency = false,
    this.isOpeningBalance = false,
  });

  final String currencyId;
  final String warehouseId;
  final DateTime purchaseDate;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final List<CreatePurchaseLineInput> lines;
  final String? supplierId;
  final String? note;

  /// Actual payment account (cash/bank); required unless [paymentMethod] is
  /// Credit — defaults in the UI to the cash box matching the purchase's currency.
  final String? paymentAccountId;

  /// العملة التي أصدر بها المستخدم الفاتورة. `null` = الأساسية.
  final String? originalCurrencyId;

  /// المبالغ مُرسَلة **بالعملة الأصلية** — الخادم يحوّلها بسعره.
  ///
  /// سعر الشراء المحوَّل يُخزَّن في `Stock.PurchasePrice` ومنه تُشتقّ تكلفة
  /// البضاعة المباعة، فتحويله على العميل كان يجعل جهازين بسعرين مخزَّنين
  /// مختلفين يُنتجان تكلفتين مختلفتين للصنف نفسه.
  final bool amountsInOriginalCurrency;

  /// فاتورة أول المدة: بلا مورّد ولا حساب دفع — المبلغ يُقيَّد مقابل رأس
  /// المال مباشرة (CreatePurchaseHandler)، لا كشراء عادي.
  final bool isOpeningBalance;

  Map<String, dynamic> toJson() => {
        'supplierId': supplierId,
        'userId': null,
        'currencyId': currencyId,
        'warehouseId': warehouseId,
        'paymentMethod': paymentMethod.wire,
        'note': note,
        'purchaseDate': purchaseDate.toIso8601String(),
        'totalAmount': totalAmount,
        'paymentAccountId': paymentAccountId,
        'originalCurrencyId': originalCurrencyId,
        'amountsInOriginalCurrency': amountsInOriginalCurrency,
        'isOpeningBalance': isOpeningBalance,
        'items': lines.map((l) => l.toJson(warehouseId)).toList(),
      };

  /// Body for `PUT pharmacy-api/Purchase/{id}` (UpdatePurchaseRequest). The
  /// backend keeps the original currency/payment method; amounts are already
  /// in base. paymentAccountId CAN change (kept as-is on the server if null).
  Map<String, dynamic> toUpdateJson(String id) => {
        'supplierId': supplierId,
        'userId': null,
        'purchaseDate': purchaseDate.toIso8601String(),
        'totalAmount': totalAmount,
        'paymentAccountId': paymentAccountId,
        'items': [
          for (final l in lines)
            {
              'id': '00000000-0000-0000-0000-000000000000',
              'purchaseId': id,
              'warehouseId': warehouseId,
              'medicineId': l.medicineId,
              'unitId': l.unitId,
              'unitPrice': l.unitPrice,
              'quantity': l.quantity,
              // كانت غائبة فتصل صفراً دائماً إلى الخادم (UpdatePurchaseItemRequest
              // بلا قيمة = صفر)، فيُفقَد بونص كل سطر عند أي تعديل لفاتورة شراء
              // قائمة — بما فيها أقلام البونص الخالصة (كمية صفر + بونص).
              'bonusQuantity': l.bonusQuantity,
              'note': l.note ?? '',
              'expiryDate': l.expiryDate?.toIso8601String(),
            },
        ],
      };
}

class CreatePurchaseLineInput {
  const CreatePurchaseLineInput({
    required this.medicineId,
    required this.unitId,
    required this.unitPrice,
    required this.quantity,
    this.bonusQuantity = 0,
    this.expiryDate,
    this.note,
    this.scannedBarcode,
  });

  final String medicineId;
  final String unitId;
  final double unitPrice;
  final double quantity;

  /// كمية البونص (مجّانية) بوحدة السطر.
  ///
  /// لا تُحتسَب في إجمالي الفاتورة ولا في قيدها — فلا يخرج مقابلها مال.
  /// تدخل المخزون بكلفة صفر، فبيعها ربح صافٍ كامل.
  final double bonusQuantity;

  final DateTime? expiryDate;
  final String? note;

  /// A barcode scanned on this line for a medicine that had none — the backend
  /// fills the medicine's barcode (only if currently empty) when saving.
  final String? scannedBarcode;

  Map<String, dynamic> toJson(String warehouseId) => {
        'bonusQuantity': bonusQuantity,
        'warehouseId': warehouseId,
        'medicineId': medicineId,
        'unitId': unitId,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'note': note ?? '',
        'expiryDate': expiryDate?.toIso8601String(),
        'scannedBarcode': scannedBarcode,
      };
}
