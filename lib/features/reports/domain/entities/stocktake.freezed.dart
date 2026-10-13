// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stocktake.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Stocktake {

 double get totalCostValue; int get medicinesCount; List<StocktakeItem> get items;
/// Create a copy of Stocktake
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StocktakeCopyWith<Stocktake> get copyWith => _$StocktakeCopyWithImpl<Stocktake>(this as Stocktake, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Stocktake;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stocktake&&(identical(other.totalCostValue, _this.totalCostValue) || other.totalCostValue == _this.totalCostValue)&&(identical(other.medicinesCount, _this.medicinesCount) || other.medicinesCount == _this.medicinesCount)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Stocktake;
  return Object.hash(runtimeType,_this.totalCostValue,_this.medicinesCount,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Stocktake;
  return 'Stocktake(totalCostValue: ${_this.totalCostValue}, medicinesCount: ${_this.medicinesCount}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $StocktakeCopyWith<$Res>  {
  factory $StocktakeCopyWith(Stocktake value, $Res Function(Stocktake) _then) = _$StocktakeCopyWithImpl;
@useResult
$Res call({
 double totalCostValue, int medicinesCount, List<StocktakeItem> items
});




}
/// @nodoc
class _$StocktakeCopyWithImpl<$Res>
    implements $StocktakeCopyWith<$Res> {
  _$StocktakeCopyWithImpl(this._self, this._then);

  final Stocktake _self;
  final $Res Function(Stocktake) _then;

/// Create a copy of Stocktake
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCostValue = null,Object? medicinesCount = null,Object? items = null,}) {
  return _then(Stocktake(
totalCostValue: null == totalCostValue ? _self.totalCostValue : totalCostValue // ignore: cast_nullable_to_non_nullable
as double,medicinesCount: null == medicinesCount ? _self.medicinesCount : medicinesCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StocktakeItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Stocktake].
extension StocktakePatterns on Stocktake {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stocktake value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stocktake() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stocktake value)  $default,){
final _that = this;
switch (_that) {
case _Stocktake():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stocktake value)?  $default,){
final _that = this;
switch (_that) {
case _Stocktake() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalCostValue,  int medicinesCount,  List<StocktakeItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stocktake() when $default != null:
return $default(_that.totalCostValue,_that.medicinesCount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalCostValue,  int medicinesCount,  List<StocktakeItem> items)  $default,) {final _that = this;
switch (_that) {
case _Stocktake():
return $default(_that.totalCostValue,_that.medicinesCount,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalCostValue,  int medicinesCount,  List<StocktakeItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Stocktake() when $default != null:
return $default(_that.totalCostValue,_that.medicinesCount,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Stocktake implements Stocktake {
  const _Stocktake({required this.totalCostValue, required this.medicinesCount,  List<StocktakeItem> items = const <StocktakeItem>[]}): _items = items;
  

@override final  double totalCostValue;
@override final  int medicinesCount;
 final  List<StocktakeItem> _items;
@override@JsonKey() List<StocktakeItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Stocktake
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StocktakeCopyWith<_Stocktake> get copyWith => __$StocktakeCopyWithImpl<_Stocktake>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stocktake&&(identical(other.totalCostValue, totalCostValue) || other.totalCostValue == totalCostValue)&&(identical(other.medicinesCount, medicinesCount) || other.medicinesCount == medicinesCount)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalCostValue,medicinesCount,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Stocktake(totalCostValue: $totalCostValue, medicinesCount: $medicinesCount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$StocktakeCopyWith<$Res> implements $StocktakeCopyWith<$Res> {
  factory _$StocktakeCopyWith(_Stocktake value, $Res Function(_Stocktake) _then) = __$StocktakeCopyWithImpl;
@override @useResult
$Res call({
 double totalCostValue, int medicinesCount, List<StocktakeItem> items
});




}
/// @nodoc
class __$StocktakeCopyWithImpl<$Res>
    implements _$StocktakeCopyWith<$Res> {
  __$StocktakeCopyWithImpl(this._self, this._then);

  final _Stocktake _self;
  final $Res Function(_Stocktake) _then;

/// Create a copy of Stocktake
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCostValue = null,Object? medicinesCount = null,Object? items = null,}) {
  return _then(_Stocktake(
totalCostValue: null == totalCostValue ? _self.totalCostValue : totalCostValue // ignore: cast_nullable_to_non_nullable
as double,medicinesCount: null == medicinesCount ? _self.medicinesCount : medicinesCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StocktakeItem>,
  ));
}


}

/// @nodoc
mixin _$StocktakeItem {

 String get medicineId; String get brandName; double get onHandQuantity; double get purchaseCost; double get costValue; List<StocktakeUnit> get units;
/// Create a copy of StocktakeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StocktakeItemCopyWith<StocktakeItem> get copyWith => _$StocktakeItemCopyWithImpl<StocktakeItem>(this as StocktakeItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StocktakeItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StocktakeItem&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.onHandQuantity, _this.onHandQuantity) || other.onHandQuantity == _this.onHandQuantity)&&(identical(other.purchaseCost, _this.purchaseCost) || other.purchaseCost == _this.purchaseCost)&&(identical(other.costValue, _this.costValue) || other.costValue == _this.costValue)&&const DeepCollectionEquality().equals(other.units, _this.units));
}


@override
int get hashCode {
  final _this = this as StocktakeItem;
  return Object.hash(runtimeType,_this.medicineId,_this.brandName,_this.onHandQuantity,_this.purchaseCost,_this.costValue,const DeepCollectionEquality().hash(_this.units));
}

@override
String toString() {
  final _this = this as StocktakeItem;
  return 'StocktakeItem(medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, onHandQuantity: ${_this.onHandQuantity}, purchaseCost: ${_this.purchaseCost}, costValue: ${_this.costValue}, units: ${_this.units})';
}


}

/// @nodoc
abstract mixin class $StocktakeItemCopyWith<$Res>  {
  factory $StocktakeItemCopyWith(StocktakeItem value, $Res Function(StocktakeItem) _then) = _$StocktakeItemCopyWithImpl;
@useResult
$Res call({
 String medicineId, String brandName, double onHandQuantity, double purchaseCost, double costValue, List<StocktakeUnit> units
});




}
/// @nodoc
class _$StocktakeItemCopyWithImpl<$Res>
    implements $StocktakeItemCopyWith<$Res> {
  _$StocktakeItemCopyWithImpl(this._self, this._then);

  final StocktakeItem _self;
  final $Res Function(StocktakeItem) _then;

/// Create a copy of StocktakeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? brandName = null,Object? onHandQuantity = null,Object? purchaseCost = null,Object? costValue = null,Object? units = null,}) {
  return _then(StocktakeItem(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,onHandQuantity: null == onHandQuantity ? _self.onHandQuantity : onHandQuantity // ignore: cast_nullable_to_non_nullable
as double,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,costValue: null == costValue ? _self.costValue : costValue // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<StocktakeUnit>,
  ));
}

}


/// Adds pattern-matching-related methods to [StocktakeItem].
extension StocktakeItemPatterns on StocktakeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StocktakeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StocktakeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StocktakeItem value)  $default,){
final _that = this;
switch (_that) {
case _StocktakeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StocktakeItem value)?  $default,){
final _that = this;
switch (_that) {
case _StocktakeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double onHandQuantity,  double purchaseCost,  double costValue,  List<StocktakeUnit> units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StocktakeItem() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.onHandQuantity,_that.purchaseCost,_that.costValue,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double onHandQuantity,  double purchaseCost,  double costValue,  List<StocktakeUnit> units)  $default,) {final _that = this;
switch (_that) {
case _StocktakeItem():
return $default(_that.medicineId,_that.brandName,_that.onHandQuantity,_that.purchaseCost,_that.costValue,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String brandName,  double onHandQuantity,  double purchaseCost,  double costValue,  List<StocktakeUnit> units)?  $default,) {final _that = this;
switch (_that) {
case _StocktakeItem() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.onHandQuantity,_that.purchaseCost,_that.costValue,_that.units);case _:
  return null;

}
}

}

/// @nodoc


class _StocktakeItem implements StocktakeItem {
  const _StocktakeItem({required this.medicineId, required this.brandName, required this.onHandQuantity, required this.purchaseCost, required this.costValue,  List<StocktakeUnit> units = const <StocktakeUnit>[]}): _units = units;
  

@override final  String medicineId;
@override final  String brandName;
@override final  double onHandQuantity;
@override final  double purchaseCost;
@override final  double costValue;
 final  List<StocktakeUnit> _units;
@override@JsonKey() List<StocktakeUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}


/// Create a copy of StocktakeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StocktakeItemCopyWith<_StocktakeItem> get copyWith => __$StocktakeItemCopyWithImpl<_StocktakeItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StocktakeItem&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.onHandQuantity, onHandQuantity) || other.onHandQuantity == onHandQuantity)&&(identical(other.purchaseCost, purchaseCost) || other.purchaseCost == purchaseCost)&&(identical(other.costValue, costValue) || other.costValue == costValue)&&const DeepCollectionEquality().equals(other.units, _units));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,brandName,onHandQuantity,purchaseCost,costValue,const DeepCollectionEquality().hash(_units));
}

@override
String toString() {
    return 'StocktakeItem(medicineId: $medicineId, brandName: $brandName, onHandQuantity: $onHandQuantity, purchaseCost: $purchaseCost, costValue: $costValue, units: $units)';
}


}

/// @nodoc
abstract mixin class _$StocktakeItemCopyWith<$Res> implements $StocktakeItemCopyWith<$Res> {
  factory _$StocktakeItemCopyWith(_StocktakeItem value, $Res Function(_StocktakeItem) _then) = __$StocktakeItemCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String brandName, double onHandQuantity, double purchaseCost, double costValue, List<StocktakeUnit> units
});




}
/// @nodoc
class __$StocktakeItemCopyWithImpl<$Res>
    implements _$StocktakeItemCopyWith<$Res> {
  __$StocktakeItemCopyWithImpl(this._self, this._then);

  final _StocktakeItem _self;
  final $Res Function(_StocktakeItem) _then;

/// Create a copy of StocktakeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? brandName = null,Object? onHandQuantity = null,Object? purchaseCost = null,Object? costValue = null,Object? units = null,}) {
  return _then(_StocktakeItem(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,onHandQuantity: null == onHandQuantity ? _self.onHandQuantity : onHandQuantity // ignore: cast_nullable_to_non_nullable
as double,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,costValue: null == costValue ? _self.costValue : costValue // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<StocktakeUnit>,
  ));
}


}

/// @nodoc
mixin _$StocktakeUnit {

 String get unitName; double get conversionFactor; bool get isBaseUnit; double get costPrice; double get salePrice;
/// Create a copy of StocktakeUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StocktakeUnitCopyWith<StocktakeUnit> get copyWith => _$StocktakeUnitCopyWithImpl<StocktakeUnit>(this as StocktakeUnit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StocktakeUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StocktakeUnit&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.conversionFactor, _this.conversionFactor) || other.conversionFactor == _this.conversionFactor)&&(identical(other.isBaseUnit, _this.isBaseUnit) || other.isBaseUnit == _this.isBaseUnit)&&(identical(other.costPrice, _this.costPrice) || other.costPrice == _this.costPrice)&&(identical(other.salePrice, _this.salePrice) || other.salePrice == _this.salePrice));
}


@override
int get hashCode {
  final _this = this as StocktakeUnit;
  return Object.hash(runtimeType,_this.unitName,_this.conversionFactor,_this.isBaseUnit,_this.costPrice,_this.salePrice);
}

@override
String toString() {
  final _this = this as StocktakeUnit;
  return 'StocktakeUnit(unitName: ${_this.unitName}, conversionFactor: ${_this.conversionFactor}, isBaseUnit: ${_this.isBaseUnit}, costPrice: ${_this.costPrice}, salePrice: ${_this.salePrice})';
}


}

/// @nodoc
abstract mixin class $StocktakeUnitCopyWith<$Res>  {
  factory $StocktakeUnitCopyWith(StocktakeUnit value, $Res Function(StocktakeUnit) _then) = _$StocktakeUnitCopyWithImpl;
@useResult
$Res call({
 String unitName, double conversionFactor, bool isBaseUnit, double costPrice, double salePrice
});




}
/// @nodoc
class _$StocktakeUnitCopyWithImpl<$Res>
    implements $StocktakeUnitCopyWith<$Res> {
  _$StocktakeUnitCopyWithImpl(this._self, this._then);

  final StocktakeUnit _self;
  final $Res Function(StocktakeUnit) _then;

/// Create a copy of StocktakeUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unitName = null,Object? conversionFactor = null,Object? isBaseUnit = null,Object? costPrice = null,Object? salePrice = null,}) {
  return _then(StocktakeUnit(
unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as double,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,costPrice: null == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StocktakeUnit].
extension StocktakeUnitPatterns on StocktakeUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StocktakeUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StocktakeUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StocktakeUnit value)  $default,){
final _that = this;
switch (_that) {
case _StocktakeUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StocktakeUnit value)?  $default,){
final _that = this;
switch (_that) {
case _StocktakeUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unitName,  double conversionFactor,  bool isBaseUnit,  double costPrice,  double salePrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StocktakeUnit() when $default != null:
return $default(_that.unitName,_that.conversionFactor,_that.isBaseUnit,_that.costPrice,_that.salePrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unitName,  double conversionFactor,  bool isBaseUnit,  double costPrice,  double salePrice)  $default,) {final _that = this;
switch (_that) {
case _StocktakeUnit():
return $default(_that.unitName,_that.conversionFactor,_that.isBaseUnit,_that.costPrice,_that.salePrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unitName,  double conversionFactor,  bool isBaseUnit,  double costPrice,  double salePrice)?  $default,) {final _that = this;
switch (_that) {
case _StocktakeUnit() when $default != null:
return $default(_that.unitName,_that.conversionFactor,_that.isBaseUnit,_that.costPrice,_that.salePrice);case _:
  return null;

}
}

}

/// @nodoc


class _StocktakeUnit implements StocktakeUnit {
  const _StocktakeUnit({required this.unitName, required this.conversionFactor, required this.isBaseUnit, required this.costPrice, required this.salePrice});
  

@override final  String unitName;
@override final  double conversionFactor;
@override final  bool isBaseUnit;
@override final  double costPrice;
@override final  double salePrice;

/// Create a copy of StocktakeUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StocktakeUnitCopyWith<_StocktakeUnit> get copyWith => __$StocktakeUnitCopyWithImpl<_StocktakeUnit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StocktakeUnit&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.conversionFactor, conversionFactor) || other.conversionFactor == conversionFactor)&&(identical(other.isBaseUnit, isBaseUnit) || other.isBaseUnit == isBaseUnit)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice));
}


@override
int get hashCode {
    return Object.hash(runtimeType,unitName,conversionFactor,isBaseUnit,costPrice,salePrice);
}

@override
String toString() {
    return 'StocktakeUnit(unitName: $unitName, conversionFactor: $conversionFactor, isBaseUnit: $isBaseUnit, costPrice: $costPrice, salePrice: $salePrice)';
}


}

/// @nodoc
abstract mixin class _$StocktakeUnitCopyWith<$Res> implements $StocktakeUnitCopyWith<$Res> {
  factory _$StocktakeUnitCopyWith(_StocktakeUnit value, $Res Function(_StocktakeUnit) _then) = __$StocktakeUnitCopyWithImpl;
@override @useResult
$Res call({
 String unitName, double conversionFactor, bool isBaseUnit, double costPrice, double salePrice
});




}
/// @nodoc
class __$StocktakeUnitCopyWithImpl<$Res>
    implements _$StocktakeUnitCopyWith<$Res> {
  __$StocktakeUnitCopyWithImpl(this._self, this._then);

  final _StocktakeUnit _self;
  final $Res Function(_StocktakeUnit) _then;

/// Create a copy of StocktakeUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unitName = null,Object? conversionFactor = null,Object? isBaseUnit = null,Object? costPrice = null,Object? salePrice = null,}) {
  return _then(_StocktakeUnit(
unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as double,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,costPrice: null == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
