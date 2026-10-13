import 'package:saydaliati/core/enums/dosage_form.dart';
import 'package:saydaliati/features/medicines/data/dtos/medicine_dto.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';

extension MedicineDtoMapper on MedicineDto {
  Medicine toEntity() => Medicine(
        id: id ?? '',
        brandName: brandName ?? '',
        brandNameArabic: brandNameArabic ?? '',
        genericName: genericName ?? '',
        foreignName: foreignName ?? '',
        barcode: barcode ?? '',
        dosageForm: DosageForm.fromWire(dosageForm),
        categoryId: categoryId ?? category?.id ?? '',
        categoryName: category?.categoryName,
        manufacturerId: manufacturer?.id,
        manufacturerName: manufacturer?.name,
        purchaseCost: (purchaseCost ?? 0).toDouble(),
        autoPriceSync: autoPriceSync ?? true,
        currency: (currency == null || currency!.trim().isEmpty)
            ? 'SYP'
            : currency!.trim().toUpperCase(),
        units: (unitPrices ?? const [])
            .where((p) => (p.unitId ?? p.unit?.id) != null)
            .map((p) => MedicineUnit(
                  unitId: (p.unitId ?? p.unit?.id)!,
                  unitName: p.unit?.name ?? '',
                  salePrice: (p.salePrice ?? 0).toDouble(),
                  conversionFactor: (p.conversionFactor ?? 1).toDouble(),
                  isBaseUnit: p.isBaseUnit ?? false,
                  isDefault: p.isDefault ?? false,
                ))
            .toList(),
      );
}
