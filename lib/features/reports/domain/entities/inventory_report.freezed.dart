// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryReport {

 double get totalStockValue; int get medicinesInStock; int get batchesCount; int get lowStockCount; List<InventoryItem> get items;
/// Create a copy of InventoryReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryReportCopyWith<InventoryReport> get copyWith => _$InventoryReportCopyWithImpl<InventoryReport>(this as InventoryReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InventoryReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryReport&&(identical(other.totalStockValue, _this.totalStockValue) || other.totalStockValue == _this.totalStockValue)&&(identical(other.medicinesInStock, _this.medicinesInStock) || other.medicinesInStock == _this.medicinesInStock)&&(identical(other.batchesCount, _this.batchesCount) || other.batchesCount == _this.batchesCount)&&(identical(other.lowStockCount, _this.lowStockCount) || other.lowStockCount == _this.lowStockCount)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as InventoryReport;
  return Object.hash(runtimeType,_this.totalStockValue,_this.medicinesInStock,_this.batchesCount,_this.lowStockCount,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as InventoryReport;
  return 'InventoryReport(totalStockValue: ${_this.totalStockValue}, medicinesInStock: ${_this.medicinesInStock}, batchesCount: ${_this.batchesCount}, lowStockCount: ${_this.lowStockCount}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $InventoryReportCopyWith<$Res>  {
  factory $InventoryReportCopyWith(InventoryReport value, $Res Function(InventoryReport) _then) = _$InventoryReportCopyWithImpl;
@useResult
$Res call({
 double totalStockValue, int medicinesInStock, int batchesCount, int lowStockCount, List<InventoryItem> items
});




}
/// @nodoc
class _$InventoryReportCopyWithImpl<$Res>
    implements $InventoryReportCopyWith<$Res> {
  _$InventoryReportCopyWithImpl(this._self, this._then);

  final InventoryReport _self;
  final $Res Function(InventoryReport) _then;

/// Create a copy of InventoryReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalStockValue = null,Object? medicinesInStock = null,Object? batchesCount = null,Object? lowStockCount = null,Object? items = null,}) {
  return _then(InventoryReport(
totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,medicinesInStock: null == medicinesInStock ? _self.medicinesInStock : medicinesInStock // ignore: cast_nullable_to_non_nullable
as int,batchesCount: null == batchesCount ? _self.batchesCount : batchesCount // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryReport].
extension InventoryReportPatterns on InventoryReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryReport value)  $default,){
final _that = this;
switch (_that) {
case _InventoryReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryReport value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalStockValue,  int medicinesInStock,  int batchesCount,  int lowStockCount,  List<InventoryItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryReport() when $default != null:
return $default(_that.totalStockValue,_that.medicinesInStock,_that.batchesCount,_that.lowStockCount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalStockValue,  int medicinesInStock,  int batchesCount,  int lowStockCount,  List<InventoryItem> items)  $default,) {final _that = this;
switch (_that) {
case _InventoryReport():
return $default(_that.totalStockValue,_that.medicinesInStock,_that.batchesCount,_that.lowStockCount,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalStockValue,  int medicinesInStock,  int batchesCount,  int lowStockCount,  List<InventoryItem> items)?  $default,) {final _that = this;
switch (_that) {
case _InventoryReport() when $default != null:
return $default(_that.totalStockValue,_that.medicinesInStock,_that.batchesCount,_that.lowStockCount,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryReport implements InventoryReport {
  const _InventoryReport({required this.totalStockValue, required this.medicinesInStock, required this.batchesCount, required this.lowStockCount,  List<InventoryItem> items = const <InventoryItem>[]}): _items = items;
  

@override final  double totalStockValue;
@override final  int medicinesInStock;
@override final  int batchesCount;
@override final  int lowStockCount;
 final  List<InventoryItem> _items;
@override@JsonKey() List<InventoryItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of InventoryReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryReportCopyWith<_InventoryReport> get copyWith => __$InventoryReportCopyWithImpl<_InventoryReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryReport&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue)&&(identical(other.medicinesInStock, medicinesInStock) || other.medicinesInStock == medicinesInStock)&&(identical(other.batchesCount, batchesCount) || other.batchesCount == batchesCount)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalStockValue,medicinesInStock,batchesCount,lowStockCount,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'InventoryReport(totalStockValue: $totalStockValue, medicinesInStock: $medicinesInStock, batchesCount: $batchesCount, lowStockCount: $lowStockCount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$InventoryReportCopyWith<$Res> implements $InventoryReportCopyWith<$Res> {
  factory _$InventoryReportCopyWith(_InventoryReport value, $Res Function(_InventoryReport) _then) = __$InventoryReportCopyWithImpl;
@override @useResult
$Res call({
 double totalStockValue, int medicinesInStock, int batchesCount, int lowStockCount, List<InventoryItem> items
});




}
/// @nodoc
class __$InventoryReportCopyWithImpl<$Res>
    implements _$InventoryReportCopyWith<$Res> {
  __$InventoryReportCopyWithImpl(this._self, this._then);

  final _InventoryReport _self;
  final $Res Function(_InventoryReport) _then;

/// Create a copy of InventoryReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalStockValue = null,Object? medicinesInStock = null,Object? batchesCount = null,Object? lowStockCount = null,Object? items = null,}) {
  return _then(_InventoryReport(
totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,medicinesInStock: null == medicinesInStock ? _self.medicinesInStock : medicinesInStock // ignore: cast_nullable_to_non_nullable
as int,batchesCount: null == batchesCount ? _self.batchesCount : batchesCount // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>,
  ));
}


}

/// @nodoc
mixin _$InventoryItem {

 String get medicineId; String get brandName; double get quantity; double get stockValue; bool get isLowStock; double get baseUnitSalePrice; double get baseUnitCost; List<InventoryUnit> get units; List<InventoryBatch> get batches;
/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemCopyWith<InventoryItem> get copyWith => _$InventoryItemCopyWithImpl<InventoryItem>(this as InventoryItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InventoryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItem&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.stockValue, _this.stockValue) || other.stockValue == _this.stockValue)&&(identical(other.isLowStock, _this.isLowStock) || other.isLowStock == _this.isLowStock)&&(identical(other.baseUnitSalePrice, _this.baseUnitSalePrice) || other.baseUnitSalePrice == _this.baseUnitSalePrice)&&(identical(other.baseUnitCost, _this.baseUnitCost) || other.baseUnitCost == _this.baseUnitCost)&&const DeepCollectionEquality().equals(other.units, _this.units)&&const DeepCollectionEquality().equals(other.batches, _this.batches));
}


@override
int get hashCode {
  final _this = this as InventoryItem;
  return Object.hash(runtimeType,_this.medicineId,_this.brandName,_this.quantity,_this.stockValue,_this.isLowStock,_this.baseUnitSalePrice,_this.baseUnitCost,const DeepCollectionEquality().hash(_this.units),const DeepCollectionEquality().hash(_this.batches));
}

@override
String toString() {
  final _this = this as InventoryItem;
  return 'InventoryItem(medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, quantity: ${_this.quantity}, stockValue: ${_this.stockValue}, isLowStock: ${_this.isLowStock}, baseUnitSalePrice: ${_this.baseUnitSalePrice}, baseUnitCost: ${_this.baseUnitCost}, units: ${_this.units}, batches: ${_this.batches})';
}


}

/// @nodoc
abstract mixin class $InventoryItemCopyWith<$Res>  {
  factory $InventoryItemCopyWith(InventoryItem value, $Res Function(InventoryItem) _then) = _$InventoryItemCopyWithImpl;
@useResult
$Res call({
 String medicineId, String brandName, double quantity, double stockValue, bool isLowStock, double baseUnitSalePrice, double baseUnitCost, List<InventoryUnit> units, List<InventoryBatch> batches
});




}
/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._self, this._then);

  final InventoryItem _self;
  final $Res Function(InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? brandName = null,Object? quantity = null,Object? stockValue = null,Object? isLowStock = null,Object? baseUnitSalePrice = null,Object? baseUnitCost = null,Object? units = null,Object? batches = null,}) {
  return _then(InventoryItem(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,stockValue: null == stockValue ? _self.stockValue : stockValue // ignore: cast_nullable_to_non_nullable
as double,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,baseUnitSalePrice: null == baseUnitSalePrice ? _self.baseUnitSalePrice : baseUnitSalePrice // ignore: cast_nullable_to_non_nullable
as double,baseUnitCost: null == baseUnitCost ? _self.baseUnitCost : baseUnitCost // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<InventoryUnit>,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<InventoryBatch>,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryItem].
extension InventoryItemPatterns on InventoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _InventoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantity,  double stockValue,  bool isLowStock,  double baseUnitSalePrice,  double baseUnitCost,  List<InventoryUnit> units,  List<InventoryBatch> batches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantity,_that.stockValue,_that.isLowStock,_that.baseUnitSalePrice,_that.baseUnitCost,_that.units,_that.batches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantity,  double stockValue,  bool isLowStock,  double baseUnitSalePrice,  double baseUnitCost,  List<InventoryUnit> units,  List<InventoryBatch> batches)  $default,) {final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that.medicineId,_that.brandName,_that.quantity,_that.stockValue,_that.isLowStock,_that.baseUnitSalePrice,_that.baseUnitCost,_that.units,_that.batches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String brandName,  double quantity,  double stockValue,  bool isLowStock,  double baseUnitSalePrice,  double baseUnitCost,  List<InventoryUnit> units,  List<InventoryBatch> batches)?  $default,) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantity,_that.stockValue,_that.isLowStock,_that.baseUnitSalePrice,_that.baseUnitCost,_that.units,_that.batches);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryItem implements InventoryItem {
  const _InventoryItem({required this.medicineId, required this.brandName, required this.quantity, required this.stockValue, required this.isLowStock, this.baseUnitSalePrice = 0, this.baseUnitCost = 0,  List<InventoryUnit> units = const <InventoryUnit>[],  List<InventoryBatch> batches = const <InventoryBatch>[]}): _units = units,_batches = batches;
  

@override final  String medicineId;
@override final  String brandName;
@override final  double quantity;
@override final  double stockValue;
@override final  bool isLowStock;
@override@JsonKey() final  double baseUnitSalePrice;
@override@JsonKey() final  double baseUnitCost;
 final  List<InventoryUnit> _units;
@override@JsonKey() List<InventoryUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

 final  List<InventoryBatch> _batches;
@override@JsonKey() List<InventoryBatch> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}


/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryItemCopyWith<_InventoryItem> get copyWith => __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryItem&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.stockValue, stockValue) || other.stockValue == stockValue)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&(identical(other.baseUnitSalePrice, baseUnitSalePrice) || other.baseUnitSalePrice == baseUnitSalePrice)&&(identical(other.baseUnitCost, baseUnitCost) || other.baseUnitCost == baseUnitCost)&&const DeepCollectionEquality().equals(other.units, _units)&&const DeepCollectionEquality().equals(other.batches, _batches));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,brandName,quantity,stockValue,isLowStock,baseUnitSalePrice,baseUnitCost,const DeepCollectionEquality().hash(_units),const DeepCollectionEquality().hash(_batches));
}

@override
String toString() {
    return 'InventoryItem(medicineId: $medicineId, brandName: $brandName, quantity: $quantity, stockValue: $stockValue, isLowStock: $isLowStock, baseUnitSalePrice: $baseUnitSalePrice, baseUnitCost: $baseUnitCost, units: $units, batches: $batches)';
}


}

/// @nodoc
abstract mixin class _$InventoryItemCopyWith<$Res> implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(_InventoryItem value, $Res Function(_InventoryItem) _then) = __$InventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String brandName, double quantity, double stockValue, bool isLowStock, double baseUnitSalePrice, double baseUnitCost, List<InventoryUnit> units, List<InventoryBatch> batches
});




}
/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(this._self, this._then);

  final _InventoryItem _self;
  final $Res Function(_InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? brandName = null,Object? quantity = null,Object? stockValue = null,Object? isLowStock = null,Object? baseUnitSalePrice = null,Object? baseUnitCost = null,Object? units = null,Object? batches = null,}) {
  return _then(_InventoryItem(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,stockValue: null == stockValue ? _self.stockValue : stockValue // ignore: cast_nullable_to_non_nullable
as double,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,baseUnitSalePrice: null == baseUnitSalePrice ? _self.baseUnitSalePrice : baseUnitSalePrice // ignore: cast_nullable_to_non_nullable
as double,baseUnitCost: null == baseUnitCost ? _self.baseUnitCost : baseUnitCost // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<InventoryUnit>,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<InventoryBatch>,
  ));
}


}

/// @nodoc
mixin _$InventoryUnit {

 String get unitName; double get conversionFactor; bool get isBaseUnit; double get salePrice; double get purchaseCost;
/// Create a copy of InventoryUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryUnitCopyWith<InventoryUnit> get copyWith => _$InventoryUnitCopyWithImpl<InventoryUnit>(this as InventoryUnit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InventoryUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryUnit&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.conversionFactor, _this.conversionFactor) || other.conversionFactor == _this.conversionFactor)&&(identical(other.isBaseUnit, _this.isBaseUnit) || other.isBaseUnit == _this.isBaseUnit)&&(identical(other.salePrice, _this.salePrice) || other.salePrice == _this.salePrice)&&(identical(other.purchaseCost, _this.purchaseCost) || other.purchaseCost == _this.purchaseCost));
}


@override
int get hashCode {
  final _this = this as InventoryUnit;
  return Object.hash(runtimeType,_this.unitName,_this.conversionFactor,_this.isBaseUnit,_this.salePrice,_this.purchaseCost);
}

@override
String toString() {
  final _this = this as InventoryUnit;
  return 'InventoryUnit(unitName: ${_this.unitName}, conversionFactor: ${_this.conversionFactor}, isBaseUnit: ${_this.isBaseUnit}, salePrice: ${_this.salePrice}, purchaseCost: ${_this.purchaseCost})';
}


}

/// @nodoc
abstract mixin class $InventoryUnitCopyWith<$Res>  {
  factory $InventoryUnitCopyWith(InventoryUnit value, $Res Function(InventoryUnit) _then) = _$InventoryUnitCopyWithImpl;
@useResult
$Res call({
 String unitName, double conversionFactor, bool isBaseUnit, double salePrice, double purchaseCost
});




}
/// @nodoc
class _$InventoryUnitCopyWithImpl<$Res>
    implements $InventoryUnitCopyWith<$Res> {
  _$InventoryUnitCopyWithImpl(this._self, this._then);

  final InventoryUnit _self;
  final $Res Function(InventoryUnit) _then;

/// Create a copy of InventoryUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unitName = null,Object? conversionFactor = null,Object? isBaseUnit = null,Object? salePrice = null,Object? purchaseCost = null,}) {
  return _then(InventoryUnit(
unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as double,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryUnit].
extension InventoryUnitPatterns on InventoryUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryUnit value)  $default,){
final _that = this;
switch (_that) {
case _InventoryUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryUnit value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unitName,  double conversionFactor,  bool isBaseUnit,  double salePrice,  double purchaseCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryUnit() when $default != null:
return $default(_that.unitName,_that.conversionFactor,_that.isBaseUnit,_that.salePrice,_that.purchaseCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unitName,  double conversionFactor,  bool isBaseUnit,  double salePrice,  double purchaseCost)  $default,) {final _that = this;
switch (_that) {
case _InventoryUnit():
return $default(_that.unitName,_that.conversionFactor,_that.isBaseUnit,_that.salePrice,_that.purchaseCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unitName,  double conversionFactor,  bool isBaseUnit,  double salePrice,  double purchaseCost)?  $default,) {final _that = this;
switch (_that) {
case _InventoryUnit() when $default != null:
return $default(_that.unitName,_that.conversionFactor,_that.isBaseUnit,_that.salePrice,_that.purchaseCost);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryUnit implements InventoryUnit {
  const _InventoryUnit({required this.unitName, required this.conversionFactor, required this.isBaseUnit, required this.salePrice, required this.purchaseCost});
  

@override final  String unitName;
@override final  double conversionFactor;
@override final  bool isBaseUnit;
@override final  double salePrice;
@override final  double purchaseCost;

/// Create a copy of InventoryUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryUnitCopyWith<_InventoryUnit> get copyWith => __$InventoryUnitCopyWithImpl<_InventoryUnit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryUnit&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.conversionFactor, conversionFactor) || other.conversionFactor == conversionFactor)&&(identical(other.isBaseUnit, isBaseUnit) || other.isBaseUnit == isBaseUnit)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.purchaseCost, purchaseCost) || other.purchaseCost == purchaseCost));
}


@override
int get hashCode {
    return Object.hash(runtimeType,unitName,conversionFactor,isBaseUnit,salePrice,purchaseCost);
}

@override
String toString() {
    return 'InventoryUnit(unitName: $unitName, conversionFactor: $conversionFactor, isBaseUnit: $isBaseUnit, salePrice: $salePrice, purchaseCost: $purchaseCost)';
}


}

/// @nodoc
abstract mixin class _$InventoryUnitCopyWith<$Res> implements $InventoryUnitCopyWith<$Res> {
  factory _$InventoryUnitCopyWith(_InventoryUnit value, $Res Function(_InventoryUnit) _then) = __$InventoryUnitCopyWithImpl;
@override @useResult
$Res call({
 String unitName, double conversionFactor, bool isBaseUnit, double salePrice, double purchaseCost
});




}
/// @nodoc
class __$InventoryUnitCopyWithImpl<$Res>
    implements _$InventoryUnitCopyWith<$Res> {
  __$InventoryUnitCopyWithImpl(this._self, this._then);

  final _InventoryUnit _self;
  final $Res Function(_InventoryUnit) _then;

/// Create a copy of InventoryUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unitName = null,Object? conversionFactor = null,Object? isBaseUnit = null,Object? salePrice = null,Object? purchaseCost = null,}) {
  return _then(_InventoryUnit(
unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as double,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$InventoryBatch {

 DateTime? get expiryDate; String get warehouseId; String get warehouseName; double get quantity; double get purchasePrice; double get batchValue; int? get daysLeft;
/// Create a copy of InventoryBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryBatchCopyWith<InventoryBatch> get copyWith => _$InventoryBatchCopyWithImpl<InventoryBatch>(this as InventoryBatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InventoryBatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryBatch&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.warehouseId, _this.warehouseId) || other.warehouseId == _this.warehouseId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.batchValue, _this.batchValue) || other.batchValue == _this.batchValue)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft));
}


@override
int get hashCode {
  final _this = this as InventoryBatch;
  return Object.hash(runtimeType,_this.expiryDate,_this.warehouseId,_this.warehouseName,_this.quantity,_this.purchasePrice,_this.batchValue,_this.daysLeft);
}

@override
String toString() {
  final _this = this as InventoryBatch;
  return 'InventoryBatch(expiryDate: ${_this.expiryDate}, warehouseId: ${_this.warehouseId}, warehouseName: ${_this.warehouseName}, quantity: ${_this.quantity}, purchasePrice: ${_this.purchasePrice}, batchValue: ${_this.batchValue}, daysLeft: ${_this.daysLeft})';
}


}

/// @nodoc
abstract mixin class $InventoryBatchCopyWith<$Res>  {
  factory $InventoryBatchCopyWith(InventoryBatch value, $Res Function(InventoryBatch) _then) = _$InventoryBatchCopyWithImpl;
@useResult
$Res call({
 DateTime? expiryDate, String warehouseId, String warehouseName, double quantity, double purchasePrice, double batchValue, int? daysLeft
});




}
/// @nodoc
class _$InventoryBatchCopyWithImpl<$Res>
    implements $InventoryBatchCopyWith<$Res> {
  _$InventoryBatchCopyWithImpl(this._self, this._then);

  final InventoryBatch _self;
  final $Res Function(InventoryBatch) _then;

/// Create a copy of InventoryBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiryDate = freezed,Object? warehouseId = null,Object? warehouseName = null,Object? quantity = null,Object? purchasePrice = null,Object? batchValue = null,Object? daysLeft = freezed,}) {
  return _then(InventoryBatch(
expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,warehouseId: null == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,batchValue: null == batchValue ? _self.batchValue : batchValue // ignore: cast_nullable_to_non_nullable
as double,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryBatch].
extension InventoryBatchPatterns on InventoryBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryBatch value)  $default,){
final _that = this;
switch (_that) {
case _InventoryBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryBatch value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? expiryDate,  String warehouseId,  String warehouseName,  double quantity,  double purchasePrice,  double batchValue,  int? daysLeft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryBatch() when $default != null:
return $default(_that.expiryDate,_that.warehouseId,_that.warehouseName,_that.quantity,_that.purchasePrice,_that.batchValue,_that.daysLeft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? expiryDate,  String warehouseId,  String warehouseName,  double quantity,  double purchasePrice,  double batchValue,  int? daysLeft)  $default,) {final _that = this;
switch (_that) {
case _InventoryBatch():
return $default(_that.expiryDate,_that.warehouseId,_that.warehouseName,_that.quantity,_that.purchasePrice,_that.batchValue,_that.daysLeft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? expiryDate,  String warehouseId,  String warehouseName,  double quantity,  double purchasePrice,  double batchValue,  int? daysLeft)?  $default,) {final _that = this;
switch (_that) {
case _InventoryBatch() when $default != null:
return $default(_that.expiryDate,_that.warehouseId,_that.warehouseName,_that.quantity,_that.purchasePrice,_that.batchValue,_that.daysLeft);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryBatch implements InventoryBatch {
  const _InventoryBatch({this.expiryDate, this.warehouseId = '', this.warehouseName = '', this.quantity = 0, this.purchasePrice = 0, this.batchValue = 0, this.daysLeft});
  

@override final  DateTime? expiryDate;
@override@JsonKey() final  String warehouseId;
@override@JsonKey() final  String warehouseName;
@override@JsonKey() final  double quantity;
@override@JsonKey() final  double purchasePrice;
@override@JsonKey() final  double batchValue;
@override final  int? daysLeft;

/// Create a copy of InventoryBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryBatchCopyWith<_InventoryBatch> get copyWith => __$InventoryBatchCopyWithImpl<_InventoryBatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryBatch&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.batchValue, batchValue) || other.batchValue == batchValue)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,expiryDate,warehouseId,warehouseName,quantity,purchasePrice,batchValue,daysLeft);
}

@override
String toString() {
    return 'InventoryBatch(expiryDate: $expiryDate, warehouseId: $warehouseId, warehouseName: $warehouseName, quantity: $quantity, purchasePrice: $purchasePrice, batchValue: $batchValue, daysLeft: $daysLeft)';
}


}

/// @nodoc
abstract mixin class _$InventoryBatchCopyWith<$Res> implements $InventoryBatchCopyWith<$Res> {
  factory _$InventoryBatchCopyWith(_InventoryBatch value, $Res Function(_InventoryBatch) _then) = __$InventoryBatchCopyWithImpl;
@override @useResult
$Res call({
 DateTime? expiryDate, String warehouseId, String warehouseName, double quantity, double purchasePrice, double batchValue, int? daysLeft
});




}
/// @nodoc
class __$InventoryBatchCopyWithImpl<$Res>
    implements _$InventoryBatchCopyWith<$Res> {
  __$InventoryBatchCopyWithImpl(this._self, this._then);

  final _InventoryBatch _self;
  final $Res Function(_InventoryBatch) _then;

/// Create a copy of InventoryBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiryDate = freezed,Object? warehouseId = null,Object? warehouseName = null,Object? quantity = null,Object? purchasePrice = null,Object? batchValue = null,Object? daysLeft = freezed,}) {
  return _then(_InventoryBatch(
expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,warehouseId: null == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,batchValue: null == batchValue ? _self.batchValue : batchValue // ignore: cast_nullable_to_non_nullable
as double,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
