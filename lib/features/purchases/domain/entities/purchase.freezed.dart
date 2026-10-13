// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Purchase {

 String get id; DateTime get purchaseDate; double get totalAmount; List<PurchaseLine> get items;
/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseCopyWith<Purchase> get copyWith => _$PurchaseCopyWithImpl<Purchase>(this as Purchase, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Purchase;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Purchase&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Purchase;
  return Object.hash(runtimeType,_this.id,_this.purchaseDate,_this.totalAmount,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Purchase;
  return 'Purchase(id: ${_this.id}, purchaseDate: ${_this.purchaseDate}, totalAmount: ${_this.totalAmount}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PurchaseCopyWith<$Res>  {
  factory $PurchaseCopyWith(Purchase value, $Res Function(Purchase) _then) = _$PurchaseCopyWithImpl;
@useResult
$Res call({
 String id, DateTime purchaseDate, double totalAmount, List<PurchaseLine> items
});




}
/// @nodoc
class _$PurchaseCopyWithImpl<$Res>
    implements $PurchaseCopyWith<$Res> {
  _$PurchaseCopyWithImpl(this._self, this._then);

  final Purchase _self;
  final $Res Function(Purchase) _then;

/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? purchaseDate = null,Object? totalAmount = null,Object? items = null,}) {
  return _then(Purchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [Purchase].
extension PurchasePatterns on Purchase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Purchase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Purchase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Purchase value)  $default,){
final _that = this;
switch (_that) {
case _Purchase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Purchase value)?  $default,){
final _that = this;
switch (_that) {
case _Purchase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime purchaseDate,  double totalAmount,  List<PurchaseLine> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Purchase() when $default != null:
return $default(_that.id,_that.purchaseDate,_that.totalAmount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime purchaseDate,  double totalAmount,  List<PurchaseLine> items)  $default,) {final _that = this;
switch (_that) {
case _Purchase():
return $default(_that.id,_that.purchaseDate,_that.totalAmount,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime purchaseDate,  double totalAmount,  List<PurchaseLine> items)?  $default,) {final _that = this;
switch (_that) {
case _Purchase() when $default != null:
return $default(_that.id,_that.purchaseDate,_that.totalAmount,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Purchase implements Purchase {
  const _Purchase({required this.id, required this.purchaseDate, required this.totalAmount,  List<PurchaseLine> items = const <PurchaseLine>[]}): _items = items;
  

@override final  String id;
@override final  DateTime purchaseDate;
@override final  double totalAmount;
 final  List<PurchaseLine> _items;
@override@JsonKey() List<PurchaseLine> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseCopyWith<_Purchase> get copyWith => __$PurchaseCopyWithImpl<_Purchase>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Purchase&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,purchaseDate,totalAmount,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Purchase(id: $id, purchaseDate: $purchaseDate, totalAmount: $totalAmount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PurchaseCopyWith<$Res> implements $PurchaseCopyWith<$Res> {
  factory _$PurchaseCopyWith(_Purchase value, $Res Function(_Purchase) _then) = __$PurchaseCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime purchaseDate, double totalAmount, List<PurchaseLine> items
});




}
/// @nodoc
class __$PurchaseCopyWithImpl<$Res>
    implements _$PurchaseCopyWith<$Res> {
  __$PurchaseCopyWithImpl(this._self, this._then);

  final _Purchase _self;
  final $Res Function(_Purchase) _then;

/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? purchaseDate = null,Object? totalAmount = null,Object? items = null,}) {
  return _then(_Purchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseLine>,
  ));
}


}

/// @nodoc
mixin _$PurchaseLine {

 String get medicineName; String get unitName; double get unitPrice; double get quantity; double get subTotal; String get medicineId; String get unitId; DateTime? get expiryDate;
/// Create a copy of PurchaseLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseLineCopyWith<PurchaseLine> get copyWith => _$PurchaseLineCopyWithImpl<PurchaseLine>(this as PurchaseLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchaseLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseLine&&(identical(other.medicineName, _this.medicineName) || other.medicineName == _this.medicineName)&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.subTotal, _this.subTotal) || other.subTotal == _this.subTotal)&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate));
}


@override
int get hashCode {
  final _this = this as PurchaseLine;
  return Object.hash(runtimeType,_this.medicineName,_this.unitName,_this.unitPrice,_this.quantity,_this.subTotal,_this.medicineId,_this.unitId,_this.expiryDate);
}

@override
String toString() {
  final _this = this as PurchaseLine;
  return 'PurchaseLine(medicineName: ${_this.medicineName}, unitName: ${_this.unitName}, unitPrice: ${_this.unitPrice}, quantity: ${_this.quantity}, subTotal: ${_this.subTotal}, medicineId: ${_this.medicineId}, unitId: ${_this.unitId}, expiryDate: ${_this.expiryDate})';
}


}

/// @nodoc
abstract mixin class $PurchaseLineCopyWith<$Res>  {
  factory $PurchaseLineCopyWith(PurchaseLine value, $Res Function(PurchaseLine) _then) = _$PurchaseLineCopyWithImpl;
@useResult
$Res call({
 String medicineName, String unitName, double unitPrice, double quantity, double subTotal, String medicineId, String unitId, DateTime? expiryDate
});




}
/// @nodoc
class _$PurchaseLineCopyWithImpl<$Res>
    implements $PurchaseLineCopyWith<$Res> {
  _$PurchaseLineCopyWithImpl(this._self, this._then);

  final PurchaseLine _self;
  final $Res Function(PurchaseLine) _then;

/// Create a copy of PurchaseLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineName = null,Object? unitName = null,Object? unitPrice = null,Object? quantity = null,Object? subTotal = null,Object? medicineId = null,Object? unitId = null,Object? expiryDate = freezed,}) {
  return _then(PurchaseLine(
medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseLine].
extension PurchaseLinePatterns on PurchaseLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseLine value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseLine value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineName,  String unitName,  double unitPrice,  double quantity,  double subTotal,  String medicineId,  String unitId,  DateTime? expiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseLine() when $default != null:
return $default(_that.medicineName,_that.unitName,_that.unitPrice,_that.quantity,_that.subTotal,_that.medicineId,_that.unitId,_that.expiryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineName,  String unitName,  double unitPrice,  double quantity,  double subTotal,  String medicineId,  String unitId,  DateTime? expiryDate)  $default,) {final _that = this;
switch (_that) {
case _PurchaseLine():
return $default(_that.medicineName,_that.unitName,_that.unitPrice,_that.quantity,_that.subTotal,_that.medicineId,_that.unitId,_that.expiryDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineName,  String unitName,  double unitPrice,  double quantity,  double subTotal,  String medicineId,  String unitId,  DateTime? expiryDate)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseLine() when $default != null:
return $default(_that.medicineName,_that.unitName,_that.unitPrice,_that.quantity,_that.subTotal,_that.medicineId,_that.unitId,_that.expiryDate);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseLine implements PurchaseLine {
  const _PurchaseLine({required this.medicineName, required this.unitName, required this.unitPrice, required this.quantity, required this.subTotal, this.medicineId = '', this.unitId = '', this.expiryDate});
  

@override final  String medicineName;
@override final  String unitName;
@override final  double unitPrice;
@override final  double quantity;
@override final  double subTotal;
@override@JsonKey() final  String medicineId;
@override@JsonKey() final  String unitId;
@override final  DateTime? expiryDate;

/// Create a copy of PurchaseLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseLineCopyWith<_PurchaseLine> get copyWith => __$PurchaseLineCopyWithImpl<_PurchaseLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseLine&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineName,unitName,unitPrice,quantity,subTotal,medicineId,unitId,expiryDate);
}

@override
String toString() {
    return 'PurchaseLine(medicineName: $medicineName, unitName: $unitName, unitPrice: $unitPrice, quantity: $quantity, subTotal: $subTotal, medicineId: $medicineId, unitId: $unitId, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class _$PurchaseLineCopyWith<$Res> implements $PurchaseLineCopyWith<$Res> {
  factory _$PurchaseLineCopyWith(_PurchaseLine value, $Res Function(_PurchaseLine) _then) = __$PurchaseLineCopyWithImpl;
@override @useResult
$Res call({
 String medicineName, String unitName, double unitPrice, double quantity, double subTotal, String medicineId, String unitId, DateTime? expiryDate
});




}
/// @nodoc
class __$PurchaseLineCopyWithImpl<$Res>
    implements _$PurchaseLineCopyWith<$Res> {
  __$PurchaseLineCopyWithImpl(this._self, this._then);

  final _PurchaseLine _self;
  final $Res Function(_PurchaseLine) _then;

/// Create a copy of PurchaseLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineName = null,Object? unitName = null,Object? unitPrice = null,Object? quantity = null,Object? subTotal = null,Object? medicineId = null,Object? unitId = null,Object? expiryDate = freezed,}) {
  return _then(_PurchaseLine(
medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
