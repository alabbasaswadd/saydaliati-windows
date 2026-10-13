import 'package:json_annotation/json_annotation.dart';

part 'supplier_dto.g.dart';

@JsonSerializable(createToJson: false)
class SupplierDto {
  const SupplierDto({this.id, this.name, this.contactPerson, this.email});

  final String? id;
  final String? name;
  final String? contactPerson;
  final String? email;

  factory SupplierDto.fromJson(Map<String, dynamic> json) =>
      _$SupplierDtoFromJson(json);
}
