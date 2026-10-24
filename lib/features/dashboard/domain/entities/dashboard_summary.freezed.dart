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

 double get salesToday; int get salesInvoicesToday; double get purchasesThisMonth; int get lowStockCount; List<LowStockItem> get lowStockList; int get expiringCount; List<ExpiringItem> get expiringList; int get totalMedicines; int get totalCustomers; int get totalSuppliers; List<SalesTrendPoint> get salesTrend; List<DashboardTopMedicine> get topMedicines; double get totalStockValue; double get totalPayables; List<DashboardPayable> get topPayables;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.salesToday, _this.salesToday) || other.salesToday == _this.salesToday)&&(identical(other.salesInvoicesToday, _this.salesInvoicesToday) || other.salesInvoicesToday == _this.salesInvoicesToday)&&(identical(other.purchasesThisMonth, _this.purchasesThisMonth) || other.purchasesThisMonth == _this.purchasesThisMonth)&&(identical(other.lowStockCount, _this.lowStockCount) || other.lowStockCount == _this.lowStockCount)&&const DeepCollectionEquality().equals(other.lowStockList, _this.lowStockList)&&(identical(other.expiringCount, _this.expiringCount) || other.expiringCount == _this.expiringCount)&&const DeepCollectionEquality().equals(other.expiringList, _this.expiringList)&&(identical(other.totalMedicines, _this.totalMedicines) || other.totalMedicines == _this.totalMedicines)&&(identical(other.totalCustomers, _this.totalCustomers) || other.totalCustomers == _this.totalCustomers)&&(identical(other.totalSuppliers, _this.totalSuppliers) || other.totalSuppliers == _this.totalSuppliers)&&const DeepCollectionEquality().equals(other.salesTrend, _this.salesTrend)&&const DeepCollectionEquality().equals(other.topMedicines, _this.topMedicines)&&(identical(other.totalStockValue, _this.totalStockValue) || other.totalStockValue == _this.totalStockValue)&&(identical(other.totalPayables, _this.totalPayables) || other.totalPayables == _this.totalPayables)&&const DeepCollectionEquality().equals(other.topPayables, _this.topPayables));
}


@override
int get hashCode {
  final _this = this as DashboardSummary;
  return Object.hash(runtimeType,_this.salesToday,_this.salesInvoicesToday,_this.purchasesThisMonth,_this.lowStockCount,const DeepCollectionEquality().hash(_this.lowStockList),_this.expiringCount,const DeepCollectionEquality().hash(_this.expiringList),_this.totalMedicines,_this.totalCustomers,_this.totalSuppliers,const DeepCollectionEquality().hash(_this.salesTrend),const DeepCollectionEquality().hash(_this.topMedicines),_this.totalStockValue,_this.totalPayables,const DeepCollectionEquality().hash(_this.topPayables));
}

@override
String toString() {
  final _this = this as DashboardSummary;
  return 'DashboardSummary(salesToday: ${_this.salesToday}, salesInvoicesToday: ${_this.salesInvoicesToday}, purchasesThisMonth: ${_this.purchasesThisMonth}, lowStockCount: ${_this.lowStockCount}, lowStockList: ${_this.lowStockList}, expiringCount: ${_this.expiringCount}, expiringList: ${_this.expiringList}, totalMedicines: ${_this.totalMedicines}, totalCustomers: ${_this.totalCustomers}, totalSuppliers: ${_this.totalSuppliers}, salesTrend: ${_this.salesTrend}, topMedicines: ${_this.topMedicines}, totalStockValue: ${_this.totalStockValue}, totalPayables: ${_this.totalPayables}, topPayables: ${_this.topPayables})';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 double salesToday, int salesInvoicesToday, double purchasesThisMonth, int lowStockCount, List<LowStockItem> lowStockList, int expiringCount, List<ExpiringItem> expiringList, int totalMedicines, int totalCustomers, int totalSuppliers, List<SalesTrendPoint> salesTrend, List<DashboardTopMedicine> topMedicines, double totalStockValue, double totalPayables, List<DashboardPayable> topPayables
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
@pragma('vm:prefer-inline') @override $Res call({Object? salesToday = null,Object? salesInvoicesToday = null,Object? purchasesThisMonth = null,Object? lowStockCount = null,Object? lowStockList = null,Object? expiringCount = null,Object? expiringList = null,Object? totalMedicines = null,Object? totalCustomers = null,Object? totalSuppliers = null,Object? salesTrend = null,Object? topMedicines = null,Object? totalStockValue = null,Object? totalPayables = null,Object? topPayables = null,}) {
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
as int,salesTrend: null == salesTrend ? _self.salesTrend : salesTrend // ignore: cast_nullable_to_non_nullable
as List<SalesTrendPoint>,topMedicines: null == topMedicines ? _self.topMedicines : topMedicines // ignore: cast_nullable_to_non_nullable
as List<DashboardTopMedicine>,totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,totalPayables: null == totalPayables ? _self.totalPayables : totalPayables // ignore: cast_nullable_to_non_nullable
as double,topPayables: null == topPayables ? _self.topPayables : topPayables // ignore: cast_nullable_to_non_nullable
as List<DashboardPayable>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double salesToday,  int salesInvoicesToday,  double purchasesThisMonth,  int lowStockCount,  List<LowStockItem> lowStockList,  int expiringCount,  List<ExpiringItem> expiringList,  int totalMedicines,  int totalCustomers,  int totalSuppliers,  List<SalesTrendPoint> salesTrend,  List<DashboardTopMedicine> topMedicines,  double totalStockValue,  double totalPayables,  List<DashboardPayable> topPayables)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.salesToday,_that.salesInvoicesToday,_that.purchasesThisMonth,_that.lowStockCount,_that.lowStockList,_that.expiringCount,_that.expiringList,_that.totalMedicines,_that.totalCustomers,_that.totalSuppliers,_that.salesTrend,_that.topMedicines,_that.totalStockValue,_that.totalPayables,_that.topPayables);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double salesToday,  int salesInvoicesToday,  double purchasesThisMonth,  int lowStockCount,  List<LowStockItem> lowStockList,  int expiringCount,  List<ExpiringItem> expiringList,  int totalMedicines,  int totalCustomers,  int totalSuppliers,  List<SalesTrendPoint> salesTrend,  List<DashboardTopMedicine> topMedicines,  double totalStockValue,  double totalPayables,  List<DashboardPayable> topPayables)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.salesToday,_that.salesInvoicesToday,_that.purchasesThisMonth,_that.lowStockCount,_that.lowStockList,_that.expiringCount,_that.expiringList,_that.totalMedicines,_that.totalCustomers,_that.totalSuppliers,_that.salesTrend,_that.topMedicines,_that.totalStockValue,_that.totalPayables,_that.topPayables);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double salesToday,  int salesInvoicesToday,  double purchasesThisMonth,  int lowStockCount,  List<LowStockItem> lowStockList,  int expiringCount,  List<ExpiringItem> expiringList,  int totalMedicines,  int totalCustomers,  int totalSuppliers,  List<SalesTrendPoint> salesTrend,  List<DashboardTopMedicine> topMedicines,  double totalStockValue,  double totalPayables,  List<DashboardPayable> topPayables)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.salesToday,_that.salesInvoicesToday,_that.purchasesThisMonth,_that.lowStockCount,_that.lowStockList,_that.expiringCount,_that.expiringList,_that.totalMedicines,_that.totalCustomers,_that.totalSuppliers,_that.salesTrend,_that.topMedicines,_that.totalStockValue,_that.totalPayables,_that.topPayables);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.salesToday, required this.salesInvoicesToday, required this.purchasesThisMonth, required this.lowStockCount, required  List<LowStockItem> lowStockList, required this.expiringCount, required  List<ExpiringItem> expiringList, required this.totalMedicines, required this.totalCustomers, required this.totalSuppliers, required  List<SalesTrendPoint> salesTrend, required  List<DashboardTopMedicine> topMedicines, required this.totalStockValue, required this.totalPayables, required  List<DashboardPayable> topPayables}): _lowStockList = lowStockList,_expiringList = expiringList,_salesTrend = salesTrend,_topMedicines = topMedicines,_topPayables = topPayables;
  

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
 final  List<SalesTrendPoint> _salesTrend;
@override List<SalesTrendPoint> get salesTrend {
  if (_salesTrend is EqualUnmodifiableListView) return _salesTrend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_salesTrend);
}

 final  List<DashboardTopMedicine> _topMedicines;
@override List<DashboardTopMedicine> get topMedicines {
  if (_topMedicines is EqualUnmodifiableListView) return _topMedicines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topMedicines);
}

@override final  double totalStockValue;
@override final  double totalPayables;
 final  List<DashboardPayable> _topPayables;
@override List<DashboardPayable> get topPayables {
  if (_topPayables is EqualUnmodifiableListView) return _topPayables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topPayables);
}


/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.salesToday, salesToday) || other.salesToday == salesToday)&&(identical(other.salesInvoicesToday, salesInvoicesToday) || other.salesInvoicesToday == salesInvoicesToday)&&(identical(other.purchasesThisMonth, purchasesThisMonth) || other.purchasesThisMonth == purchasesThisMonth)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&const DeepCollectionEquality().equals(other.lowStockList, _lowStockList)&&(identical(other.expiringCount, expiringCount) || other.expiringCount == expiringCount)&&const DeepCollectionEquality().equals(other.expiringList, _expiringList)&&(identical(other.totalMedicines, totalMedicines) || other.totalMedicines == totalMedicines)&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.totalSuppliers, totalSuppliers) || other.totalSuppliers == totalSuppliers)&&const DeepCollectionEquality().equals(other.salesTrend, _salesTrend)&&const DeepCollectionEquality().equals(other.topMedicines, _topMedicines)&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue)&&(identical(other.totalPayables, totalPayables) || other.totalPayables == totalPayables)&&const DeepCollectionEquality().equals(other.topPayables, _topPayables));
}


@override
int get hashCode {
    return Object.hash(runtimeType,salesToday,salesInvoicesToday,purchasesThisMonth,lowStockCount,const DeepCollectionEquality().hash(_lowStockList),expiringCount,const DeepCollectionEquality().hash(_expiringList),totalMedicines,totalCustomers,totalSuppliers,const DeepCollectionEquality().hash(_salesTrend),const DeepCollectionEquality().hash(_topMedicines),totalStockValue,totalPayables,const DeepCollectionEquality().hash(_topPayables));
}

@override
String toString() {
    return 'DashboardSummary(salesToday: $salesToday, salesInvoicesToday: $salesInvoicesToday, purchasesThisMonth: $purchasesThisMonth, lowStockCount: $lowStockCount, lowStockList: $lowStockList, expiringCount: $expiringCount, expiringList: $expiringList, totalMedicines: $totalMedicines, totalCustomers: $totalCustomers, totalSuppliers: $totalSuppliers, salesTrend: $salesTrend, topMedicines: $topMedicines, totalStockValue: $totalStockValue, totalPayables: $totalPayables, topPayables: $topPayables)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 double salesToday, int salesInvoicesToday, double purchasesThisMonth, int lowStockCount, List<LowStockItem> lowStockList, int expiringCount, List<ExpiringItem> expiringList, int totalMedicines, int totalCustomers, int totalSuppliers, List<SalesTrendPoint> salesTrend, List<DashboardTopMedicine> topMedicines, double totalStockValue, double totalPayables, List<DashboardPayable> topPayables
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
@override @pragma('vm:prefer-inline') $Res call({Object? salesToday = null,Object? salesInvoicesToday = null,Object? purchasesThisMonth = null,Object? lowStockCount = null,Object? lowStockList = null,Object? expiringCount = null,Object? expiringList = null,Object? totalMedicines = null,Object? totalCustomers = null,Object? totalSuppliers = null,Object? salesTrend = null,Object? topMedicines = null,Object? totalStockValue = null,Object? totalPayables = null,Object? topPayables = null,}) {
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
as int,salesTrend: null == salesTrend ? _self._salesTrend : salesTrend // ignore: cast_nullable_to_non_nullable
as List<SalesTrendPoint>,topMedicines: null == topMedicines ? _self._topMedicines : topMedicines // ignore: cast_nullable_to_non_nullable
as List<DashboardTopMedicine>,totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,totalPayables: null == totalPayables ? _self.totalPayables : totalPayables // ignore: cast_nullable_to_non_nullable
as double,topPayables: null == topPayables ? _self._topPayables : topPayables // ignore: cast_nullable_to_non_nullable
as List<DashboardPayable>,
  ));
}


}

/// @nodoc
mixin _$DashboardProfit {

 double get revenue; double get cost; double get profit;
/// Create a copy of DashboardProfit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardProfitCopyWith<DashboardProfit> get copyWith => _$DashboardProfitCopyWithImpl<DashboardProfit>(this as DashboardProfit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardProfit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardProfit&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.profit, _this.profit) || other.profit == _this.profit));
}


@override
int get hashCode {
  final _this = this as DashboardProfit;
  return Object.hash(runtimeType,_this.revenue,_this.cost,_this.profit);
}

@override
String toString() {
  final _this = this as DashboardProfit;
  return 'DashboardProfit(revenue: ${_this.revenue}, cost: ${_this.cost}, profit: ${_this.profit})';
}


}

/// @nodoc
abstract mixin class $DashboardProfitCopyWith<$Res>  {
  factory $DashboardProfitCopyWith(DashboardProfit value, $Res Function(DashboardProfit) _then) = _$DashboardProfitCopyWithImpl;
@useResult
$Res call({
 double revenue, double cost, double profit
});




}
/// @nodoc
class _$DashboardProfitCopyWithImpl<$Res>
    implements $DashboardProfitCopyWith<$Res> {
  _$DashboardProfitCopyWithImpl(this._self, this._then);

  final DashboardProfit _self;
  final $Res Function(DashboardProfit) _then;

/// Create a copy of DashboardProfit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revenue = null,Object? cost = null,Object? profit = null,}) {
  return _then(DashboardProfit(
revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardProfit].
extension DashboardProfitPatterns on DashboardProfit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardProfit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardProfit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardProfit value)  $default,){
final _that = this;
switch (_that) {
case _DashboardProfit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardProfit value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardProfit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double revenue,  double cost,  double profit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardProfit() when $default != null:
return $default(_that.revenue,_that.cost,_that.profit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double revenue,  double cost,  double profit)  $default,) {final _that = this;
switch (_that) {
case _DashboardProfit():
return $default(_that.revenue,_that.cost,_that.profit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double revenue,  double cost,  double profit)?  $default,) {final _that = this;
switch (_that) {
case _DashboardProfit() when $default != null:
return $default(_that.revenue,_that.cost,_that.profit);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardProfit implements DashboardProfit {
  const _DashboardProfit({required this.revenue, required this.cost, required this.profit});
  

@override final  double revenue;
@override final  double cost;
@override final  double profit;

/// Create a copy of DashboardProfit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardProfitCopyWith<_DashboardProfit> get copyWith => __$DashboardProfitCopyWithImpl<_DashboardProfit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardProfit&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.profit, profit) || other.profit == profit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,revenue,cost,profit);
}

@override
String toString() {
    return 'DashboardProfit(revenue: $revenue, cost: $cost, profit: $profit)';
}


}

/// @nodoc
abstract mixin class _$DashboardProfitCopyWith<$Res> implements $DashboardProfitCopyWith<$Res> {
  factory _$DashboardProfitCopyWith(_DashboardProfit value, $Res Function(_DashboardProfit) _then) = __$DashboardProfitCopyWithImpl;
@override @useResult
$Res call({
 double revenue, double cost, double profit
});




}
/// @nodoc
class __$DashboardProfitCopyWithImpl<$Res>
    implements _$DashboardProfitCopyWith<$Res> {
  __$DashboardProfitCopyWithImpl(this._self, this._then);

  final _DashboardProfit _self;
  final $Res Function(_DashboardProfit) _then;

/// Create a copy of DashboardProfit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revenue = null,Object? cost = null,Object? profit = null,}) {
  return _then(_DashboardProfit(
revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$SalesTrendPoint {

 DateTime get date; double get totalAmount;
/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesTrendPointCopyWith<SalesTrendPoint> get copyWith => _$SalesTrendPointCopyWithImpl<SalesTrendPoint>(this as SalesTrendPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesTrendPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesTrendPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount));
}


@override
int get hashCode {
  final _this = this as SalesTrendPoint;
  return Object.hash(runtimeType,_this.date,_this.totalAmount);
}

@override
String toString() {
  final _this = this as SalesTrendPoint;
  return 'SalesTrendPoint(date: ${_this.date}, totalAmount: ${_this.totalAmount})';
}


}

/// @nodoc
abstract mixin class $SalesTrendPointCopyWith<$Res>  {
  factory $SalesTrendPointCopyWith(SalesTrendPoint value, $Res Function(SalesTrendPoint) _then) = _$SalesTrendPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double totalAmount
});




}
/// @nodoc
class _$SalesTrendPointCopyWithImpl<$Res>
    implements $SalesTrendPointCopyWith<$Res> {
  _$SalesTrendPointCopyWithImpl(this._self, this._then);

  final SalesTrendPoint _self;
  final $Res Function(SalesTrendPoint) _then;

/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalAmount = null,}) {
  return _then(SalesTrendPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesTrendPoint].
extension SalesTrendPointPatterns on SalesTrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesTrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesTrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesTrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _SalesTrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesTrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SalesTrendPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double totalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesTrendPoint() when $default != null:
return $default(_that.date,_that.totalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double totalAmount)  $default,) {final _that = this;
switch (_that) {
case _SalesTrendPoint():
return $default(_that.date,_that.totalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double totalAmount)?  $default,) {final _that = this;
switch (_that) {
case _SalesTrendPoint() when $default != null:
return $default(_that.date,_that.totalAmount);case _:
  return null;

}
}

}

/// @nodoc


class _SalesTrendPoint implements SalesTrendPoint {
  const _SalesTrendPoint({required this.date, required this.totalAmount});
  

@override final  DateTime date;
@override final  double totalAmount;

/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesTrendPointCopyWith<_SalesTrendPoint> get copyWith => __$SalesTrendPointCopyWithImpl<_SalesTrendPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesTrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,totalAmount);
}

@override
String toString() {
    return 'SalesTrendPoint(date: $date, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class _$SalesTrendPointCopyWith<$Res> implements $SalesTrendPointCopyWith<$Res> {
  factory _$SalesTrendPointCopyWith(_SalesTrendPoint value, $Res Function(_SalesTrendPoint) _then) = __$SalesTrendPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double totalAmount
});




}
/// @nodoc
class __$SalesTrendPointCopyWithImpl<$Res>
    implements _$SalesTrendPointCopyWith<$Res> {
  __$SalesTrendPointCopyWithImpl(this._self, this._then);

  final _SalesTrendPoint _self;
  final $Res Function(_SalesTrendPoint) _then;

/// Create a copy of SalesTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalAmount = null,}) {
  return _then(_SalesTrendPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DashboardTopMedicine {

 String get medicineId; String get brandName; double get revenue;
/// Create a copy of DashboardTopMedicine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTopMedicineCopyWith<DashboardTopMedicine> get copyWith => _$DashboardTopMedicineCopyWithImpl<DashboardTopMedicine>(this as DashboardTopMedicine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardTopMedicine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTopMedicine&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue));
}


@override
int get hashCode {
  final _this = this as DashboardTopMedicine;
  return Object.hash(runtimeType,_this.medicineId,_this.brandName,_this.revenue);
}

@override
String toString() {
  final _this = this as DashboardTopMedicine;
  return 'DashboardTopMedicine(medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, revenue: ${_this.revenue})';
}


}

/// @nodoc
abstract mixin class $DashboardTopMedicineCopyWith<$Res>  {
  factory $DashboardTopMedicineCopyWith(DashboardTopMedicine value, $Res Function(DashboardTopMedicine) _then) = _$DashboardTopMedicineCopyWithImpl;
@useResult
$Res call({
 String medicineId, String brandName, double revenue
});




}
/// @nodoc
class _$DashboardTopMedicineCopyWithImpl<$Res>
    implements $DashboardTopMedicineCopyWith<$Res> {
  _$DashboardTopMedicineCopyWithImpl(this._self, this._then);

  final DashboardTopMedicine _self;
  final $Res Function(DashboardTopMedicine) _then;

/// Create a copy of DashboardTopMedicine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? brandName = null,Object? revenue = null,}) {
  return _then(DashboardTopMedicine(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardTopMedicine].
extension DashboardTopMedicinePatterns on DashboardTopMedicine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTopMedicine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTopMedicine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTopMedicine value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTopMedicine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTopMedicine value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTopMedicine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double revenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardTopMedicine() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.revenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double revenue)  $default,) {final _that = this;
switch (_that) {
case _DashboardTopMedicine():
return $default(_that.medicineId,_that.brandName,_that.revenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String brandName,  double revenue)?  $default,) {final _that = this;
switch (_that) {
case _DashboardTopMedicine() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardTopMedicine implements DashboardTopMedicine {
  const _DashboardTopMedicine({required this.medicineId, required this.brandName, required this.revenue});
  

@override final  String medicineId;
@override final  String brandName;
@override final  double revenue;

/// Create a copy of DashboardTopMedicine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTopMedicineCopyWith<_DashboardTopMedicine> get copyWith => __$DashboardTopMedicineCopyWithImpl<_DashboardTopMedicine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTopMedicine&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,brandName,revenue);
}

@override
String toString() {
    return 'DashboardTopMedicine(medicineId: $medicineId, brandName: $brandName, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$DashboardTopMedicineCopyWith<$Res> implements $DashboardTopMedicineCopyWith<$Res> {
  factory _$DashboardTopMedicineCopyWith(_DashboardTopMedicine value, $Res Function(_DashboardTopMedicine) _then) = __$DashboardTopMedicineCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String brandName, double revenue
});




}
/// @nodoc
class __$DashboardTopMedicineCopyWithImpl<$Res>
    implements _$DashboardTopMedicineCopyWith<$Res> {
  __$DashboardTopMedicineCopyWithImpl(this._self, this._then);

  final _DashboardTopMedicine _self;
  final $Res Function(_DashboardTopMedicine) _then;

/// Create a copy of DashboardTopMedicine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? brandName = null,Object? revenue = null,}) {
  return _then(_DashboardTopMedicine(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DashboardPayable {

 String get supplierId; String get supplierName; double get balance;
/// Create a copy of DashboardPayable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPayableCopyWith<DashboardPayable> get copyWith => _$DashboardPayableCopyWithImpl<DashboardPayable>(this as DashboardPayable, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardPayable;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPayable&&(identical(other.supplierId, _this.supplierId) || other.supplierId == _this.supplierId)&&(identical(other.supplierName, _this.supplierName) || other.supplierName == _this.supplierName)&&(identical(other.balance, _this.balance) || other.balance == _this.balance));
}


@override
int get hashCode {
  final _this = this as DashboardPayable;
  return Object.hash(runtimeType,_this.supplierId,_this.supplierName,_this.balance);
}

@override
String toString() {
  final _this = this as DashboardPayable;
  return 'DashboardPayable(supplierId: ${_this.supplierId}, supplierName: ${_this.supplierName}, balance: ${_this.balance})';
}


}

/// @nodoc
abstract mixin class $DashboardPayableCopyWith<$Res>  {
  factory $DashboardPayableCopyWith(DashboardPayable value, $Res Function(DashboardPayable) _then) = _$DashboardPayableCopyWithImpl;
@useResult
$Res call({
 String supplierId, String supplierName, double balance
});




}
/// @nodoc
class _$DashboardPayableCopyWithImpl<$Res>
    implements $DashboardPayableCopyWith<$Res> {
  _$DashboardPayableCopyWithImpl(this._self, this._then);

  final DashboardPayable _self;
  final $Res Function(DashboardPayable) _then;

/// Create a copy of DashboardPayable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplierId = null,Object? supplierName = null,Object? balance = null,}) {
  return _then(DashboardPayable(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPayable].
extension DashboardPayablePatterns on DashboardPayable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPayable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPayable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPayable value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPayable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPayable value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPayable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String supplierId,  String supplierName,  double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPayable() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String supplierId,  String supplierName,  double balance)  $default,) {final _that = this;
switch (_that) {
case _DashboardPayable():
return $default(_that.supplierId,_that.supplierName,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String supplierId,  String supplierName,  double balance)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPayable() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.balance);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardPayable implements DashboardPayable {
  const _DashboardPayable({required this.supplierId, required this.supplierName, required this.balance});
  

@override final  String supplierId;
@override final  String supplierName;
@override final  double balance;

/// Create a copy of DashboardPayable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPayableCopyWith<_DashboardPayable> get copyWith => __$DashboardPayableCopyWithImpl<_DashboardPayable>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPayable&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,supplierId,supplierName,balance);
}

@override
String toString() {
    return 'DashboardPayable(supplierId: $supplierId, supplierName: $supplierName, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$DashboardPayableCopyWith<$Res> implements $DashboardPayableCopyWith<$Res> {
  factory _$DashboardPayableCopyWith(_DashboardPayable value, $Res Function(_DashboardPayable) _then) = __$DashboardPayableCopyWithImpl;
@override @useResult
$Res call({
 String supplierId, String supplierName, double balance
});




}
/// @nodoc
class __$DashboardPayableCopyWithImpl<$Res>
    implements _$DashboardPayableCopyWith<$Res> {
  __$DashboardPayableCopyWithImpl(this._self, this._then);

  final _DashboardPayable _self;
  final $Res Function(_DashboardPayable) _then;

/// Create a copy of DashboardPayable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplierId = null,Object? supplierName = null,Object? balance = null,}) {
  return _then(_DashboardPayable(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
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
