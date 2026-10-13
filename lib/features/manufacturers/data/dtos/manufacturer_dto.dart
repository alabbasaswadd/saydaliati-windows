import 'package:json_annotation/json_annotation.dart';

part 'manufacturer_dto.g.dart';

@JsonSerializable(createToJson: false)
class ManufacturerDto {
  const ManufacturerDto({this.id, this.name, this.location});

  final String? id;
  final String? name;
  final String? location;

  factory ManufacturerDto.fromJson(Map<String, dynamic> json) =>
      _$ManufacturerDtoFromJson(json);
}
