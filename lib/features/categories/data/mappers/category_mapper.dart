import 'package:saydaliati/features/categories/data/dtos/category_dto.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';

extension CategoryDtoMapper on CategoryDto {
  Category toEntity() => Category(
        id: id ?? '',
        categoryName: categoryName ?? '',
        description: description ?? '',
        medicinesCount: medicinesCount ?? 0,
      );
}
