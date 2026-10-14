import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saydaliati/core/enums/payment_method.dart';

part 'sale.freezed.dart';

/// A sales invoice as returned by the backend (list/detail). Pure domain model.
@freezed
abstract class Sale with _$Sale {
  const factory Sale({
    required String id,
    required DateTime saleDate,
    required double totalAmount,
    required PaymentMethod paymentMethod,
    required String currencyCode,
    @Default(0) int invoiceNumber,
    @Default('') String customerId,
    @Default('') String originalCurrencyId,
    @Default(1) double exchangeRate,
    @Default(false) bool isPrescription,
    @Default('') String paymentAccountId,
    @Default(<SaleLine>[]) List<SaleLine> items,
  }) = _Sale;
}

/// One line on a sales invoice.
@freezed
abstract class SaleLine with _$SaleLine {
  const factory SaleLine({
    required String medicineName,
    required String unitName,
    required double individual,
    required double quantity,
    required double subTotal,
    @Default(0) double unitCost,
    @Default('') String medicineId,
    @Default('') String unitId,
  }) = _SaleLine;
}
