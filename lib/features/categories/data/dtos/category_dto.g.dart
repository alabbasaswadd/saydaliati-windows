// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
  id: json['id'] as String?,
  categoryName: json['categoryName'] as String?,
  description: json['description'] as String?,
  medicinesCount: (json['medicinesCount'] as num?)?.toInt(),
);
