import 'package:saydaliati/features/suppliers/data/dtos/supplier_dto.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';

extension SupplierDtoMapper on SupplierDto {
  Supplier toEntity() => Supplier(
        id: id ?? '',
        name: name ?? '',
        contactPerson: contactPerson ?? '',
        email: email ?? '',
      );
}
