import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/features/sales/data/dtos/sale_dto.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';

extension SaleDtoMapper on SaleDto {
  Sale toEntity() => Sale(
        id: id ?? '',
        invoiceNumber: invoiceNumber ?? 0,
        customerId: customerId ?? '',
        saleDate: saleDate ?? DateTime.now(),
        totalAmount: (totalAmount ?? 0).toDouble(),
        paymentMethod: PaymentMethod.fromWire(paymentMethod),
        currencyCode: currency?.code ?? '',
        originalCurrencyId: originalCurrencyId ?? '',
        exchangeRate: (exchangeRate ?? 1).toDouble(),
        isPrescription: isPrescription ?? false,
        items: (items ?? const []).map((i) => i.toEntity()).toList(),
      );
}

extension SaleItemDtoMapper on SaleItemDto {
  SaleLine toEntity() {
    final qty = (quantity ?? 0).toDouble();
    final price = (individual ?? 0).toDouble();
    return SaleLine(
      medicineId: medicineId ?? '',
      unitId: unitId ?? '',
      medicineName: medicine?.brandName ?? medicine?.genericName ?? '',
      unitName: unit?.name ?? '',
      individual: price,
      quantity: qty,
      subTotal: (subTotal ?? (qty * price)).toDouble(),
      unitCost: (unitCost ?? 0).toDouble(),
    );
  }
}
