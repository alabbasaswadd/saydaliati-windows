import 'package:saydaliati/features/purchases/data/dtos/purchase_dto.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';

extension PurchaseDtoMapper on PurchaseDto {
  Purchase toEntity() => Purchase(
        id: id ?? '',
        invoiceNumber: invoiceNumber ?? 0,
        purchaseDate: purchaseDate ?? DateTime.now(),
        supplierName: supplierName ?? '',
        totalAmount: (totalAmount ?? 0).toDouble(),
        discountAmount: (discountAmount ?? 0).toDouble(),
        paymentAccountId: paymentAccountId ?? '',
        items: (items ?? const []).map((i) => i.toEntity()).toList(),
        isOpeningBalance: isOpeningBalance ?? false,
      );
}

extension PurchaseItemDtoMapper on PurchaseItemDto {
  PurchaseLine toEntity() {
    final qty = (quantity ?? 0).toDouble();
    final price = (unitPrice ?? 0).toDouble();
    final disc = (discount ?? 0).toDouble();
    return PurchaseLine(
      medicineId: medicineId ?? '',
      unitId: unitId ?? '',
      medicineName: medicine?.brandName ?? medicine?.genericName ?? '',
      unitName: unit?.name ?? '',
      unitPrice: price,
      quantity: qty,
      bonusQuantity: (bonusQuantity ?? 0).toDouble(),
      discount: disc,
      subTotal: (subTotal ?? (qty * price - disc)).toDouble(),
      expiryDate: expiryDate,
    );
  }
}
