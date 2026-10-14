import 'package:saydaliati/features/reports/data/dtos/purchases_grid_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_grid.dart';

extension PurchasesGridInvoiceDtoMapper on PurchasesGridInvoiceDto {
  PurchasesGridInvoice toEntity() => PurchasesGridInvoice(
        purchaseId: purchaseId ?? '',
        invoiceNumber: invoiceNumber ?? 0,
        purchaseDate: purchaseDate ?? DateTime(1970),
        supplierName: supplierName ?? '',
        paymentMethod: paymentMethod ?? 0,
        warehouseName: warehouseName ?? '',
        currencyCode: currencyCode ?? '',
        currencySymbol: currencySymbol ?? '',
        discountAmount: (discountAmount ?? 0).toDouble(),
        totalAmount: (totalAmount ?? 0).toDouble(),
        itemsCount: itemsCount ?? 0,
        items: [
          for (final i in items ?? const <PurchasesGridItemDto>[]) i.toEntity(),
        ],
      );
}

extension PurchasesGridItemDtoMapper on PurchasesGridItemDto {
  PurchasesGridItem toEntity() => PurchasesGridItem(
        brandName: brandName ?? '',
        unitName: unitName ?? '',
        quantity: (quantity ?? 0).toDouble(),
        unitPrice: (unitPrice ?? 0).toDouble(),
        discount: (discount ?? 0).toDouble(),
        subTotal: (subTotal ?? 0).toDouble(),
        batchNumber: batchNumber ?? '',
        expiryDate: expiryDate,
      );
}
