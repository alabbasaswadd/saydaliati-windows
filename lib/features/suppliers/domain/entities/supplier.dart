import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';

/// A supplier (vendor). Pure domain model.
@freezed
abstract class Supplier with _$Supplier {
  const factory Supplier({
    required String id,
    required String name,
    required String contactPerson,
    required String email,
  }) = _Supplier;
}
