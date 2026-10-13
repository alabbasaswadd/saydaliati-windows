// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSummary {

 double get salesToday; int get salesInvoicesToday; double get purchasesThisMonth; int get lowStockCount; List<LowStockItem> get lowStockList; int get expiringCount; List<ExpiringItem> get expiringList; int get totalMedicines; int get totalCustomers; int get totalSuppliers;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.salesToday, _this.salesToday) || other.salesToday == _this.salesToday)&&(identical(other.salesInvoicesToday, _this.salesInvoicesToday) || other.salesInvoicesToday == _this.salesInvoicesToday)&&(identical(other.purchasesThisMonth, _this.purchasesThisMonth) || other.purchasesThisMonth == _this.purchasesThisMonth)&&(identical(other.lowStockCount, _this.lowStockCount) || other.lowStockCount == _this.lowStockCount)&&const DeepCollectionEquality().equals(other.lowStockList, _this.lowStockList)&&(identical(other.expiringCount, _this.expiringCount) || other.expiringCount == _this.expiringCount)&&const DeepCollectionEquality().equals(other.expiringList, _this.expiringList)&&(identical(other.totalMedicines, _this.totalMedicines) || other.totalMedicines == _this.totalMedicines)&&(identical(other.totalCustomers, _this.totalCustomers) || other.totalCustomers == _this.totalCustomers)&&(identical(other.totalSuppliers, _this.totalSuppliers) || other.totalSuppliers == _this.totalSuppliers));
}


@override
int get hashCode {
  final _this = this as DashboardSummary;
  return Object.hash(runtimeType,_this.salesToday,_this.salesInvoicesToday,_this.purchasesThisMonth,_this.lowStockCount,const DeepCollectionEquality().hash(_this.lowStockList),_this.expiringCount,const DeepCollectionEquality().hash(_this.expiringList),_this.totalMedicines,_this.totalCustomers,_this.totalSuppliers);
}

@override
String toString() {
  final _this = this as DashboardSummary;
  return 'DashboardSummary(salesToday: ${_this.salesToday}, salesInvoicesToday: ${_this.salesInvoicesToday}, purchasesThisMonth: ${_this.purchasesThisMonth}, lowStockCount: ${_this.lowStockCount}, lowStockList: ${_this.lowStockList}, expiringCount: ${_this.expiringCount}, expiringList: ${_this.expiringList}, totalMedicines: ${_this.totalMedicines}, totalCustomers: ${_this.totalCustomers}, totalSuppliers: ${_this.totalSuppliers})';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 double salesToday, int salesInvoicesToday, double purchasesThisMonth, int lowStockCount, List<LowStockItem> lowStockList, int expiringCount, List<ExpiringItem> expiringList, int totalMedicines, int totalCustomers, int totalSuppliers
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? salesToday = null,Object? salesInvoicesToday = null,Object? purchasesThisMonth = null,Object? lowStockCount = null,Object? lowStockList = null,Object? expiringCount = null,Object? expiringList = null,Object? totalMedicines = null,Object? totalCustomers = null,Object? totalSuppliers = null,}) {
  return _then(DashboardSummary(
salesToday: null == salesToday ? _self.salesToday : salesToday // ignore: cast_nullable_to_non_nullable
as double,salesInvoicesToday: null == salesInvoicesToday ? _self.salesInvoicesToday : salesInvoicesToday // ignore: cast_nullable_to_non_nullable
as int,purchasesThisMonth: null == purchasesThisMonth ? _self.purchasesThisMonth : purchasesThisMonth // ignore: cast_nullable_to_non_nullable
as double,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,lowStockList: null == lowStockList ? _self.lowStockList : lowStockList // ignore: cast_nullable_to_non_nullable
as List<LowStockItem>,expiringCount: null == expiringCount ? _self.expiringCount : expiringCount // ignore: cast_nullable_to_non_nullable
as int,expiringList: null == expiringList ? _self.expiringList : expiringList // ignore: cast_nullable_to_non_nullable
as List<ExpiringItem>,totalMedicines: null == totalMedicines ? _self.totalMedicines : totalMedicines // ignore: cast_nullable_to_non_nullable
as int,totalCustomers: null == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int,totalSuppliers: null == totalSuppliers ? _self.totalSuppliers : totalSuppliers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double salesToday,  int salesInvoicesToday,  double purchasesThisMonth,  int lowStockCount,  List<LowStockItem> lowStockList,  int expiringCount,  List<ExpiringItem> expiringList,  int totalMedicines,  int totalCustomers,  int totalSuppliers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.salesToday,_that.salesInvoicesToday,_that.purchasesThisMonth,_that.lowStockCount,_that.lowStockList,_that.expiringCount,_that.expiringList,_that.totalMedicines,_that.totalCustomers,_that.totalSuppliers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double salesToday,  int salesInvoicesToday,  double purchasesThisMonth,  int lowStockCount,  List<LowStockItem> lowStockList,  int expiringCount,  List<ExpiringItem> expiringList,  int totalMedicines,  int totalCustomers,  int totalSuppliers)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.salesToday,_that.salesInvoicesToday,_that.purchasesThisMonth,_that.lowStockCount,_that.lowStockList,_that.expiringCount,_that.expiringList,_that.totalMedicines,_that.totalCustomers,_that.totalSuppliers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double salesToday,  int salesInvoicesToday,  double purchasesThisMonth,  int lowStockCount,  List<LowStockItem> lowStockList,  int expiringCount,  List<ExpiringItem> expiringList,  int totalMedicines,  int totalCustomers,  int totalSuppliers)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.salesToday,_that.salesInvoicesToday,_that.purchasesThisMonth,_that.lowStockCount,_that.lowStockList,_that.expiringCount,_that.expiringList,_that.totalMedicines,_that.totalCustomers,_that.totalSuppliers);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.salesToday, required this.salesInvoicesToday, required this.purchasesThisMonth, required this.lowStockCount, required  List<LowStockItem> lowStockList, required this.expiringCount, required  List<ExpiringItem> expiringList, required this.totalMedicines, required this.totalCustomers, required this.totalSuppliers}): _lowStockList = lowStockList,_expiringList = expiringList;
  

@override final  double salesToday;
@override final  int salesInvoicesToday;
@override final  double purchasesThisMonth;
@override final  int lowStockCount;
 final  List<LowStockItem> _lowStockList;
@override List<LowStockItem> get lowStockList {
  if (_lowStockList is EqualUnmodifiableListView) return _lowStockList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lowStockList);
}

@override final  int expiringCount;
 final  List<ExpiringItem> _expiringList;
@override List<ExpiringItem> get expiringList {
  if (_expiringList is EqualUnmodifiableListView) return _expiringList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expiringList);
}

@override final  int totalMedicines;
@override final  int totalCustomers;
@override final  int totalSuppliers;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.salesToday, salesToday) || other.salesToday == salesToday)&&(identical(other.salesInvoicesToday, salesInvoicesToday) || other.salesInvoicesToday == salesInvoicesToday)&&(identical(other.purchasesThisMonth, purchasesThisMonth) || other.purchasesThisMonth == purchasesThisMonth)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&const DeepCollectionEquality().equals(other.lowStockList, _lowStockList)&&(identical(other.expiringCount, expiringCount) || other.expiringCount == expiringCount)&&const DeepCollectionEquality().equals(other.expiringList, _expiringList)&&(identical(other.totalMedicines, totalMedicines) || other.totalMedicines == totalMedicines)&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.totalSuppliers, totalSuppliers) || other.totalSuppliers == totalSuppliers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,salesToday,salesInvoicesToday,purchasesThisMonth,lowStockCount,const DeepCollectionEquality().hash(_lowStockList),expiringCount,const DeepCollectionEquality().hash(_expiringList),totalMedicines,totalCustomers,totalSuppliers);
}

@override
String toString() {
    return 'DashboardSummary(salesToday: $salesToday, salesInvoicesToday: $salesInvoicesToday, purchasesThisMonth: $purchasesThisMonth, lowStockCount: $lowStockCount, lowStockList: $lowStockList, expiringCount: $expiringCount, expiringList: $expiringList, totalMedicines: $totalMedicines, totalCustomers: $totalCustomers, totalSuppliers: $totalSuppliers)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 double salesToday, int salesInvoicesToday, double purchasesThisMonth, int lowStockCount, List<LowStockItem> lowStockList, int expiringCount, List<ExpiringItem> expiringList, int totalMedicines, int totalCustomers, int totalSuppliers
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? salesToday = null,Object? salesInvoicesToday = null,Object? purchasesThisMonth = null,Object? lowStockCount = null,Object? lowStockList = null,Object? expiringCount = null,Object? expiringList = null,Object? totalMedicines = null,Object? totalCustomers = null,Object? totalSuppliers = null,}) {
  return _then(_DashboardSummary(
salesToday: null == salesToday ? _self.salesToday : salesToday // ignore: cast_nullable_to_non_nullable
as double,salesInvoicesToday: null == salesInvoicesToday ? _self.salesInvoicesToday : salesInvoicesToday // ignore: cast_nullable_to_non_nullable
as int,purchasesThisMonth: null == purchasesThisMonth ? _self.purchasesThisMonth : purchasesThisMonth // ignore: cast_nullable_to_non_nullable
as double,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,lowStockList: null == lowStockList ? _self._lowStockList : lowStockList // ignore: cast_nullable_to_non_nullable
as List<LowStockItem>,expiringCount: null == expiringCount ? _self.expiringCount : expiringCount // ignore: cast_nullable_to_non_nullable
as int,expiringList: null == expiringList ? _self._expiringList : expiringList // ignore: cast_nullable_to_non_nullable
as List<ExpiringItem>,totalMedicines: null == totalMedicines ? _self.totalMedicines : totalMedicines // ignore: cast_nullable_to_non_nullable
as int,totalCustomers: null == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int,totalSuppliers: null == totalSuppliers ? _self.totalSuppliers : totalSuppliers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LowStockItem {

 String get medicineId; String get brandName; double get quantityAvailable;
/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LowStockItemCopyWith<LowStockItem> get copyWith => _$LowStockItemCopyWithImpl<LowStockItem>(this as LowStockItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LowStockItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LowStockItem&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.quantityAvailable, _this.quantityAvailable) || other.quantityAvailable == _this.quantityAvailable));
}


@override
int get hashCode {
  final _this = this as LowStockItem;
  return Object.hash(runtimeType,_this.medicineId,_this.brandName,_this.quantityAvailable);
}

@override
String toString() {
  final _this = this as LowStockItem;
  return 'LowStockItem(medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, quantityAvailable: ${_this.quantityAvailable})';
}


}

/// @nodoc
abstract mixin class $LowStockItemCopyWith<$Res>  {
  factory $LowStockItemCopyWith(LowStockItem value, $Res Function(LowStockItem) _then) = _$LowStockItemCopyWithImpl;
@useResult
$Res call({
 String medicineId, String brandName, double quantityAvailable
});




}
/// @nodoc
class _$LowStockItemCopyWithImpl<$Res>
    implements $LowStockItemCopyWith<$Res> {
  _$LowStockItemCopyWithImpl(this._self, this._then);

  final LowStockItem _self;
  final $Res Function(LowStockItem) _then;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? brandName = null,Object? quantityAvailable = null,}) {
  return _then(LowStockItem(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LowStockItem].
extension LowStockItemPatterns on LowStockItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LowStockItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LowStockItem value)  $default,){
final _that = this;
switch (_that) {
case _LowStockItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LowStockItem value)?  $default,){
final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantityAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantityAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantityAvailable)  $default,) {final _that = this;
switch (_that) {
case _LowStockItem():
return $default(_that.medicineId,_that.brandName,_that.quantityAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String brandName,  double quantityAvailable)?  $default,) {final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantityAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _LowStockItem implements LowStockItem {
  const _LowStockItem({required this.medicineId, required this.brandName, required this.quantityAvailable});
  

@override final  String medicineId;
@override final  String brandName;
@override final  double quantityAvailable;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LowStockItemCopyWith<_LowStockItem> get copyWith => __$LowStockItemCopyWithImpl<_LowStockItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LowStockItem&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.quantityAvailable, quantityAvailable) || other.quantityAvailable == quantityAvailable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,brandName,quantityAvailable);
}

@override
String toString() {
    return 'LowStockItem(medicineId: $medicineId, brandName: $brandName, quantityAvailable: $quantityAvailable)';
}


}

/// @nodoc
abstract mixin class _$LowStockItemCopyWith<$Res> implements $LowStockItemCopyWith<$Res> {
  factory _$LowStockItemCopyWith(_LowStockItem value, $Res Function(_LowStockItem) _then) = __$LowStockItemCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String brandName, double quantityAvailable
});




}
/// @nodoc
class __$LowStockItemCopyWithImpl<$Res>
    implements _$LowStockItemCopyWith<$Res> {
  __$LowStockItemCopyWithImpl(this._self, this._then);

  final _LowStockItem _self;
  final $Res Function(_LowStockItem) _then;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? brandName = null,Object? quantityAvailable = null,}) {
  return _then(_LowStockItem(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ExpiringItem {

 String get id; String get brandName; DateTime get expirationDate; int get daysLeft;
/// Create a copy of ExpiringItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiringItemCopyWith<ExpiringItem> get copyWith => _$ExpiringItemCopyWithImpl<ExpiringItem>(this as ExpiringItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExpiringItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiringItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.expirationDate, _this.expirationDate) || other.expirationDate == _this.expirationDate)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft));
}


@override
int get hashCode {
  final _this = this as ExpiringItem;
  return Object.hash(runtimeType,_this.id,_this.brandName,_this.expirationDate,_this.daysLeft);
}

@override
String toString() {
  final _this = this as ExpiringItem;
  return 'ExpiringItem(id: ${_this.id}, brandName: ${_this.brandName}, expirationDate: ${_this.expirationDate}, daysLeft: ${_this.daysLeft})';
}


}

/// @nodoc
abstract mixin class $ExpiringItemCopyWith<$Res>  {
  factory $ExpiringItemCopyWith(ExpiringItem value, $Res Function(ExpiringItem) _then) = _$ExpiringItemCopyWithImpl;
@useResult
$Res call({
 String id, String brandName, DateTime expirationDate, int daysLeft
});




}
/// @nodoc
class _$ExpiringItemCopyWithImpl<$Res>
    implements $ExpiringItemCopyWith<$Res> {
  _$ExpiringItemCopyWithImpl(this._self, this._then);

  final ExpiringItem _self;
  final $Res Function(ExpiringItem) _then;

/// Create a copy of ExpiringItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brandName = null,Object? expirationDate = null,Object? daysLeft = null,}) {
  return _then(ExpiringItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,expirationDate: null == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpiringItem].
extension ExpiringItemPatterns on ExpiringItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiringItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiringItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiringItem value)  $default,){
final _that = this;
switch (_that) {
case _ExpiringItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiringItem value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiringItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String brandName,  DateTime expirationDate,  int daysLeft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiringItem() when $default != null:
return $default(_that.id,_that.brandName,_that.expirationDate,_that.daysLeft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String brandName,  DateTime expirationDate,  int daysLeft)  $default,) {final _that = this;
switch (_that) {
case _ExpiringItem():
return $default(_that.id,_that.brandName,_that.expirationDate,_that.daysLeft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String brandName,  DateTime expirationDate,  int daysLeft)?  $default,) {final _that = this;
switch (_that) {
case _ExpiringItem() when $default != null:
return $default(_that.id,_that.brandName,_that.expirationDate,_that.daysLeft);case _:
  return null;

}
}

}

/// @nodoc


class _ExpiringItem implements ExpiringItem {
  const _ExpiringItem({required this.id, required this.brandName, required this.expirationDate, required this.daysLeft});
  

@override final  String id;
@override final  String brandName;
@override final  DateTime expirationDate;
@override final  int daysLeft;

/// Create a copy of ExpiringItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiringItemCopyWith<_ExpiringItem> get copyWith => __$ExpiringItemCopyWithImpl<_ExpiringItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiringItem&&(identical(other.id, id) || other.id == id)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,brandName,expirationDate,daysLeft);
}

@override
String toString() {
    return 'ExpiringItem(id: $id, brandName: $brandName, expirationDate: $expirationDate, daysLeft: $daysLeft)';
}


}

/// @nodoc
abstract mixin class _$ExpiringItemCopyWith<$Res> implements $ExpiringItemCopyWith<$Res> {
  factory _$ExpiringItemCopyWith(_ExpiringItem value, $Res Function(_ExpiringItem) _then) = __$ExpiringItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String brandName, DateTime expirationDate, int daysLeft
});




}
/// @nodoc
class __$ExpiringItemCopyWithImpl<$Res>
    implements _$ExpiringItemCopyWith<$Res> {
  __$ExpiringItemCopyWithImpl(this._self, this._then);

  final _ExpiringItem _self;
  final $Res Function(_ExpiringItem) _then;

/// Create a copy of ExpiringItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brandName = null,Object? expirationDate = null,Object? daysLeft = null,}) {
  return _then(_ExpiringItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,expirationDate: null == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
