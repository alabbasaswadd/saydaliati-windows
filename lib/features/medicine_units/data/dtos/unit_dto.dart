import 'package:json_annotation/json_annotation.dart';

part 'unit_dto.g.dart';

@JsonSerializable(createToJson: false)
class UnitDto {
  const UnitDto({this.id, this.name, this.description});

  final String? id;
  final String? name;
  final String? description;

  factory UnitDto.fromJson(Map<String, dynamic> json) =>
      _$UnitDtoFromJson(json);
}
