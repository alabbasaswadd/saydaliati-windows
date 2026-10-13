import 'package:json_annotation/json_annotation.dart';

part 'customer_dto.g.dart';

@JsonSerializable(createToJson: false)
class CustomerDto {
  const CustomerDto({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;

  factory CustomerDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDtoFromJson(json);
}
