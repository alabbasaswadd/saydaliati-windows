import 'package:saydaliati/features/reports/data/dtos/sales_grid_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_grid.dart';

extension SalesGridInvoiceDtoMapper on SalesGridInvoiceDto {
  SalesGridInvoice toEntity() => SalesGridInvoice(
        saleId: saleId ?? '',
        invoiceNumber: invoiceNumber ?? 0,
        saleDate: saleDate ?? DateTime(1970),
        customerName: customerName ?? '',
        paymentMethod: paymentMethod ?? 0,
        warehouseName: warehouseName ?? '',
        currencyCode: currencyCode ?? '',
        currencySymbol: currencySymbol ?? '',
        originalCurrencyCode: originalCurrencyCode ?? '',
        originalExchangeRate: (originalExchangeRate ?? 1).toDouble(),
        discountAmount: (discountAmount ?? 0).toDouble(),
        totalAmount: (totalAmount ?? 0).toDouble(),
        cost: (cost ?? 0).toDouble(),
        profit: (profit ?? 0).toDouble(),
        profitMargin: (profitMargin ?? 0).toDouble(),
        costMissing: costMissing ?? false,
        items: [
          for (final i in items ?? const <SalesGridItemDto>[]) i.toEntity(),
        ],
      );
}

extension SalesGridItemDtoMapper on SalesGridItemDto {
  SalesGridItem toEntity() => SalesGridItem(
        brandName: brandName ?? '',
        unitName: unitName ?? '',
        quantity: (quantity ?? 0).toDouble(),
        unitPrice: (unitPrice ?? 0).toDouble(),
        discount: (discount ?? 0).toDouble(),
        subTotal: (subTotal ?? 0).toDouble(),
        unitCost: (unitCost ?? 0).toDouble(),
        lineCost: (lineCost ?? 0).toDouble(),
        lineProfit: (lineProfit ?? 0).toDouble(),
        costMissing: costMissing ?? false,
      );
}
