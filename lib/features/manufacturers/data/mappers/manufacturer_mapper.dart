import 'package:saydaliati/features/manufacturers/data/dtos/manufacturer_dto.dart';
import 'package:saydaliati/features/manufacturers/domain/entities/manufacturer.dart';

extension ManufacturerDtoMapper on ManufacturerDto {
  Manufacturer toEntity() => Manufacturer(
        id: id ?? '',
        name: name ?? '',
        location: location ?? '',
      );
}
