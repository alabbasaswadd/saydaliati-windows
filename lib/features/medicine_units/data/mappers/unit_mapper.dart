import 'package:saydaliati/features/medicine_units/data/dtos/unit_dto.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';

extension UnitDtoMapper on UnitDto {
  Unit toEntity() => Unit(
        id: id ?? '',
        name: name ?? '',
        description: description ?? '',
      );
}
