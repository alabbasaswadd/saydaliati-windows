import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable(createToJson: false)
class CategoryDto {
  const CategoryDto(
      {this.id, this.categoryName, this.description, this.medicinesCount});

  final String? id;
  final String? categoryName;
  final String? description;
  final int? medicinesCount;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
