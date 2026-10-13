// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockMovement {

 String get id; String get medicineId; double get quantityDelta; StockMovementType get type; DateTime get occurredOn; String get note; String get medicineName; String get referenceType; DateTime? get expiryDate;
/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementCopyWith<StockMovement> get copyWith => _$StockMovementCopyWithImpl<StockMovement>(this as StockMovement, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockMovement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.quantityDelta, _this.quantityDelta) || other.quantityDelta == _this.quantityDelta)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.occurredOn, _this.occurredOn) || other.occurredOn == _this.occurredOn)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.medicineName, _this.medicineName) || other.medicineName == _this.medicineName)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate));
}


@override
int get hashCode {
  final _this = this as StockMovement;
  return Object.hash(runtimeType,_this.id,_this.medicineId,_this.quantityDelta,_this.type,_this.occurredOn,_this.note,_this.medicineName,_this.referenceType,_this.expiryDate);
}

@override
String toString() {
  final _this = this as StockMovement;
  return 'StockMovement(id: ${_this.id}, medicineId: ${_this.medicineId}, quantityDelta: ${_this.quantityDelta}, type: ${_this.type}, occurredOn: ${_this.occurredOn}, note: ${_this.note}, medicineName: ${_this.medicineName}, referenceType: ${_this.referenceType}, expiryDate: ${_this.expiryDate})';
}


}

/// @nodoc
abstract mixin class $StockMovementCopyWith<$Res>  {
  factory $StockMovementCopyWith(StockMovement value, $Res Function(StockMovement) _then) = _$StockMovementCopyWithImpl;
@useResult
$Res call({
 String id, String medicineId, double quantityDelta, StockMovementType type, DateTime occurredOn, String note, String medicineName, String referenceType, DateTime? expiryDate
});




}
/// @nodoc
class _$StockMovementCopyWithImpl<$Res>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._self, this._then);

  final StockMovement _self;
  final $Res Function(StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicineId = null,Object? quantityDelta = null,Object? type = null,Object? occurredOn = null,Object? note = null,Object? medicineName = null,Object? referenceType = null,Object? expiryDate = freezed,}) {
  return _then(StockMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,quantityDelta: null == quantityDelta ? _self.quantityDelta : quantityDelta // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StockMovementType,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovement].
extension StockMovementPatterns on StockMovement {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovement value)  $default,){
final _that = this;
switch (_that) {
case _StockMovement():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovement value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicineId,  double quantityDelta,  StockMovementType type,  DateTime occurredOn,  String note,  String medicineName,  String referenceType,  DateTime? expiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.id,_that.medicineId,_that.quantityDelta,_that.type,_that.occurredOn,_that.note,_that.medicineName,_that.referenceType,_that.expiryDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicineId,  double quantityDelta,  StockMovementType type,  DateTime occurredOn,  String note,  String medicineName,  String referenceType,  DateTime? expiryDate)  $default,) {final _that = this;
switch (_that) {
case _StockMovement():
return $default(_that.id,_that.medicineId,_that.quantityDelta,_that.type,_that.occurredOn,_that.note,_that.medicineName,_that.referenceType,_that.expiryDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicineId,  double quantityDelta,  StockMovementType type,  DateTime occurredOn,  String note,  String medicineName,  String referenceType,  DateTime? expiryDate)?  $default,) {final _that = this;
switch (_that) {
case _StockMovement() when $default != null:
return $default(_that.id,_that.medicineId,_that.quantityDelta,_that.type,_that.occurredOn,_that.note,_that.medicineName,_that.referenceType,_that.expiryDate);case _:
  return null;

}
}

}

/// @nodoc


class _StockMovement implements StockMovement {
  const _StockMovement({required this.id, required this.medicineId, required this.quantityDelta, required this.type, required this.occurredOn, required this.note, this.medicineName = '', this.referenceType = '', this.expiryDate});
  

@override final  String id;
@override final  String medicineId;
@override final  double quantityDelta;
@override final  StockMovementType type;
@override final  DateTime occurredOn;
@override final  String note;
@override@JsonKey() final  String medicineName;
@override@JsonKey() final  String referenceType;
@override final  DateTime? expiryDate;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementCopyWith<_StockMovement> get copyWith => __$StockMovementCopyWithImpl<_StockMovement>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.quantityDelta, quantityDelta) || other.quantityDelta == quantityDelta)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.note, note) || other.note == note)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,medicineId,quantityDelta,type,occurredOn,note,medicineName,referenceType,expiryDate);
}

@override
String toString() {
    return 'StockMovement(id: $id, medicineId: $medicineId, quantityDelta: $quantityDelta, type: $type, occurredOn: $occurredOn, note: $note, medicineName: $medicineName, referenceType: $referenceType, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class _$StockMovementCopyWith<$Res> implements $StockMovementCopyWith<$Res> {
  factory _$StockMovementCopyWith(_StockMovement value, $Res Function(_StockMovement) _then) = __$StockMovementCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicineId, double quantityDelta, StockMovementType type, DateTime occurredOn, String note, String medicineName, String referenceType, DateTime? expiryDate
});




}
/// @nodoc
class __$StockMovementCopyWithImpl<$Res>
    implements _$StockMovementCopyWith<$Res> {
  __$StockMovementCopyWithImpl(this._self, this._then);

  final _StockMovement _self;
  final $Res Function(_StockMovement) _then;

/// Create a copy of StockMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicineId = null,Object? quantityDelta = null,Object? type = null,Object? occurredOn = null,Object? note = null,Object? medicineName = null,Object? referenceType = null,Object? expiryDate = freezed,}) {
  return _then(_StockMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,quantityDelta: null == quantityDelta ? _self.quantityDelta : quantityDelta // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StockMovementType,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,referenceType: null == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
