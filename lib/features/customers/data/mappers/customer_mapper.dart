import 'package:saydaliati/features/customers/data/dtos/customer_dto.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';

extension CustomerDtoMapper on CustomerDto {
  Customer toEntity() => Customer(
        id: id ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        phone: phone ?? '',
        address: address ?? '',
      );
}
