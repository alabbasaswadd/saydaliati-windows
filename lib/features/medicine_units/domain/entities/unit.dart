import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';

/// A medicine unit (box, strip, tablet, …). Pure domain model.
@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String name,
    required String description,
  }) = _Unit;
}
