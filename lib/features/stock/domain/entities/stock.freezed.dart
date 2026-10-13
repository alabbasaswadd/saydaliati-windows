// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Stock {

 String get id; String get medicineId; String get medicineName; double get quantityAvailable; double get purchasePrice; double get sellingPrice; DateTime? get expiryDate; DateTime? get dateReceived;
/// Create a copy of Stock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockCopyWith<Stock> get copyWith => _$StockCopyWithImpl<Stock>(this as Stock, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Stock;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stock&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.medicineName, _this.medicineName) || other.medicineName == _this.medicineName)&&(identical(other.quantityAvailable, _this.quantityAvailable) || other.quantityAvailable == _this.quantityAvailable)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.sellingPrice, _this.sellingPrice) || other.sellingPrice == _this.sellingPrice)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.dateReceived, _this.dateReceived) || other.dateReceived == _this.dateReceived));
}


@override
int get hashCode {
  final _this = this as Stock;
  return Object.hash(runtimeType,_this.id,_this.medicineId,_this.medicineName,_this.quantityAvailable,_this.purchasePrice,_this.sellingPrice,_this.expiryDate,_this.dateReceived);
}

@override
String toString() {
  final _this = this as Stock;
  return 'Stock(id: ${_this.id}, medicineId: ${_this.medicineId}, medicineName: ${_this.medicineName}, quantityAvailable: ${_this.quantityAvailable}, purchasePrice: ${_this.purchasePrice}, sellingPrice: ${_this.sellingPrice}, expiryDate: ${_this.expiryDate}, dateReceived: ${_this.dateReceived})';
}


}

/// @nodoc
abstract mixin class $StockCopyWith<$Res>  {
  factory $StockCopyWith(Stock value, $Res Function(Stock) _then) = _$StockCopyWithImpl;
@useResult
$Res call({
 String id, String medicineId, String medicineName, double quantityAvailable, double purchasePrice, double sellingPrice, DateTime? expiryDate, DateTime? dateReceived
});




}
/// @nodoc
class _$StockCopyWithImpl<$Res>
    implements $StockCopyWith<$Res> {
  _$StockCopyWithImpl(this._self, this._then);

  final Stock _self;
  final $Res Function(Stock) _then;

/// Create a copy of Stock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicineId = null,Object? medicineName = null,Object? quantityAvailable = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? expiryDate = freezed,Object? dateReceived = freezed,}) {
  return _then(Stock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateReceived: freezed == dateReceived ? _self.dateReceived : dateReceived // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Stock].
extension StockPatterns on Stock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stock value)  $default,){
final _that = this;
switch (_that) {
case _Stock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stock value)?  $default,){
final _that = this;
switch (_that) {
case _Stock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicineId,  String medicineName,  double quantityAvailable,  double purchasePrice,  double sellingPrice,  DateTime? expiryDate,  DateTime? dateReceived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stock() when $default != null:
return $default(_that.id,_that.medicineId,_that.medicineName,_that.quantityAvailable,_that.purchasePrice,_that.sellingPrice,_that.expiryDate,_that.dateReceived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicineId,  String medicineName,  double quantityAvailable,  double purchasePrice,  double sellingPrice,  DateTime? expiryDate,  DateTime? dateReceived)  $default,) {final _that = this;
switch (_that) {
case _Stock():
return $default(_that.id,_that.medicineId,_that.medicineName,_that.quantityAvailable,_that.purchasePrice,_that.sellingPrice,_that.expiryDate,_that.dateReceived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicineId,  String medicineName,  double quantityAvailable,  double purchasePrice,  double sellingPrice,  DateTime? expiryDate,  DateTime? dateReceived)?  $default,) {final _that = this;
switch (_that) {
case _Stock() when $default != null:
return $default(_that.id,_that.medicineId,_that.medicineName,_that.quantityAvailable,_that.purchasePrice,_that.sellingPrice,_that.expiryDate,_that.dateReceived);case _:
  return null;

}
}

}

/// @nodoc


class _Stock implements Stock {
  const _Stock({required this.id, required this.medicineId, required this.medicineName, required this.quantityAvailable, required this.purchasePrice, required this.sellingPrice, this.expiryDate, this.dateReceived});
  

@override final  String id;
@override final  String medicineId;
@override final  String medicineName;
@override final  double quantityAvailable;
@override final  double purchasePrice;
@override final  double sellingPrice;
@override final  DateTime? expiryDate;
@override final  DateTime? dateReceived;

/// Create a copy of Stock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockCopyWith<_Stock> get copyWith => __$StockCopyWithImpl<_Stock>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stock&&(identical(other.id, id) || other.id == id)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.quantityAvailable, quantityAvailable) || other.quantityAvailable == quantityAvailable)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.dateReceived, dateReceived) || other.dateReceived == dateReceived));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,medicineId,medicineName,quantityAvailable,purchasePrice,sellingPrice,expiryDate,dateReceived);
}

@override
String toString() {
    return 'Stock(id: $id, medicineId: $medicineId, medicineName: $medicineName, quantityAvailable: $quantityAvailable, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, expiryDate: $expiryDate, dateReceived: $dateReceived)';
}


}

/// @nodoc
abstract mixin class _$StockCopyWith<$Res> implements $StockCopyWith<$Res> {
  factory _$StockCopyWith(_Stock value, $Res Function(_Stock) _then) = __$StockCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicineId, String medicineName, double quantityAvailable, double purchasePrice, double sellingPrice, DateTime? expiryDate, DateTime? dateReceived
});




}
/// @nodoc
class __$StockCopyWithImpl<$Res>
    implements _$StockCopyWith<$Res> {
  __$StockCopyWithImpl(this._self, this._then);

  final _Stock _self;
  final $Res Function(_Stock) _then;

/// Create a copy of Stock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicineId = null,Object? medicineName = null,Object? quantityAvailable = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? expiryDate = freezed,Object? dateReceived = freezed,}) {
  return _then(_Stock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateReceived: freezed == dateReceived ? _self.dateReceived : dateReceived // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
