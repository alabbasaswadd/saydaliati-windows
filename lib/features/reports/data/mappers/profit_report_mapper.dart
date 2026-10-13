import 'package:saydaliati/features/reports/data/dtos/profit_report_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';

extension ProfitReportDtoMapper on ProfitReportDto {
  ProfitReport toEntity() => ProfitReport(
        totalRevenue: (totalRevenue ?? 0).toDouble(),
        totalCost: (totalCost ?? 0).toDouble(),
        totalProfit: (totalProfit ?? 0).toDouble(),
        invoicesCount: invoicesCount ?? 0,
        byCurrency: [
          for (final c in byCurrency ?? const <ProfitByCurrencyDto>[])
            c.toEntity(),
        ],
        invoices: [
          for (final i in invoices ?? const <ProfitInvoiceDto>[]) i.toEntity(),
        ],
      );
}

extension ProfitByCurrencyDtoMapper on ProfitByCurrencyDto {
  ProfitByCurrency toEntity() => ProfitByCurrency(
        currencyId: currencyId ?? '',
        currencyCode: currencyCode ?? '',
        currencySymbol: currencySymbol ?? '',
        invoicesCount: invoicesCount ?? 0,
        revenue: (revenue ?? 0).toDouble(),
        cost: (cost ?? 0).toDouble(),
        profit: (profit ?? 0).toDouble(),
      );
}

extension ProfitInvoiceDtoMapper on ProfitInvoiceDto {
  ProfitInvoice toEntity() => ProfitInvoice(
        invoiceNumber: invoiceNumber ?? 0,
        saleDate: saleDate ?? DateTime(1970),
        currencyCode: currencyCode ?? '',
        paymentMethod: paymentMethod ?? 0,
        revenue: (revenue ?? 0).toDouble(),
        cost: (cost ?? 0).toDouble(),
        profit: (profit ?? 0).toDouble(),
        originalCurrencyCode: originalCurrencyCode ?? '',
        originalExchangeRate: (originalExchangeRate ?? 1).toDouble(),
      );
}
