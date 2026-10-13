import 'package:saydaliati/features/reports/data/dtos/expiry_report_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/expiry_report.dart';

extension ExpiryReportDtoMapper on ExpiryReportDto {
  ExpiryReport toEntity() => ExpiryReport(
        expiringSoon: (expiringSoon ?? const []).map(_batch).toList(),
        expired: (expired ?? const []).map(_batch).toList(),
      );

  ExpiryBatch _batch(ExpiryBatchDto d) => ExpiryBatch(
        stockId: d.stockId ?? '',
        medicineId: d.medicineId ?? '',
        brandName: d.brandName ?? '',
        warehouseName: d.warehouseName ?? '',
        expiryDate: d.expiryDate ?? DateTime(1970),
        quantityAvailable: (d.quantityAvailable ?? 0).toDouble(),
        daysLeft: d.daysLeft ?? 0,
      );
}
