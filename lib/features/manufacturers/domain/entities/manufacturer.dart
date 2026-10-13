import 'package:freezed_annotation/freezed_annotation.dart';

part 'manufacturer.freezed.dart';

/// A medicine manufacturer. Pure domain model.
@freezed
abstract class Manufacturer with _$Manufacturer {
  const factory Manufacturer({
    required String id,
    required String name,
    required String location,
  }) = _Manufacturer;
}
