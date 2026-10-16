import 'package:saydaliati/features/purchases/data/dtos/purchase_dto.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';

extension PurchaseDtoMapper on PurchaseDto {
  Purchase toEntity() => Purchase(
        id: id ?? '',
        invoiceNumber: invoiceNumber ?? 0,
        purchaseDate: purchaseDate ?? DateTime.now(),
        totalAmount: (totalAmount ?? 0).toDouble(),
        paymentAccountId: paymentAccountId ?? '',
        items: (items ?? const []).map((i) => i.toEntity()).toList(),
      );
}

extension PurchaseItemDtoMapper on PurchaseItemDto {
  PurchaseLine toEntity() {
    final qty = (quantity ?? 0).toDouble();
    final price = (unitPrice ?? 0).toDouble();
    return PurchaseLine(
      medicineId: medicineId ?? '',
      unitId: unitId ?? '',
      medicineName: medicine?.brandName ?? medicine?.genericName ?? '',
      unitName: unit?.name ?? '',
      unitPrice: price,
      quantity: qty,
      bonusQuantity: (bonusQuantity ?? 0).toDouble(),
      subTotal: (subTotal ?? (qty * price)).toDouble(),
      expiryDate: expiryDate,
    );
  }
}
