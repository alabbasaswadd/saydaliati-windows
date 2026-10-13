import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// A medicine category (`MedicineCategory` on the backend). Pure domain model.
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String categoryName,
    required String description,
    @Default(0) int medicinesCount,
  }) = _Category;
}
