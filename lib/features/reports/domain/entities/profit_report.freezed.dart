// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profit_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfitReport {

 double get totalRevenue; double get totalCost; double get totalProfit; int get invoicesCount; List<ProfitByCurrency> get byCurrency; List<ProfitInvoice> get invoices;
/// Create a copy of ProfitReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfitReportCopyWith<ProfitReport> get copyWith => _$ProfitReportCopyWithImpl<ProfitReport>(this as ProfitReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfitReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfitReport&&(identical(other.totalRevenue, _this.totalRevenue) || other.totalRevenue == _this.totalRevenue)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.totalProfit, _this.totalProfit) || other.totalProfit == _this.totalProfit)&&(identical(other.invoicesCount, _this.invoicesCount) || other.invoicesCount == _this.invoicesCount)&&const DeepCollectionEquality().equals(other.byCurrency, _this.byCurrency)&&const DeepCollectionEquality().equals(other.invoices, _this.invoices));
}


@override
int get hashCode {
  final _this = this as ProfitReport;
  return Object.hash(runtimeType,_this.totalRevenue,_this.totalCost,_this.totalProfit,_this.invoicesCount,const DeepCollectionEquality().hash(_this.byCurrency),const DeepCollectionEquality().hash(_this.invoices));
}

@override
String toString() {
  final _this = this as ProfitReport;
  return 'ProfitReport(totalRevenue: ${_this.totalRevenue}, totalCost: ${_this.totalCost}, totalProfit: ${_this.totalProfit}, invoicesCount: ${_this.invoicesCount}, byCurrency: ${_this.byCurrency}, invoices: ${_this.invoices})';
}


}

/// @nodoc
abstract mixin class $ProfitReportCopyWith<$Res>  {
  factory $ProfitReportCopyWith(ProfitReport value, $Res Function(ProfitReport) _then) = _$ProfitReportCopyWithImpl;
@useResult
$Res call({
 double totalRevenue, double totalCost, double totalProfit, int invoicesCount, List<ProfitByCurrency> byCurrency, List<ProfitInvoice> invoices
});




}
/// @nodoc
class _$ProfitReportCopyWithImpl<$Res>
    implements $ProfitReportCopyWith<$Res> {
  _$ProfitReportCopyWithImpl(this._self, this._then);

  final ProfitReport _self;
  final $Res Function(ProfitReport) _then;

/// Create a copy of ProfitReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRevenue = null,Object? totalCost = null,Object? totalProfit = null,Object? invoicesCount = null,Object? byCurrency = null,Object? invoices = null,}) {
  return _then(ProfitReport(
totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,byCurrency: null == byCurrency ? _self.byCurrency : byCurrency // ignore: cast_nullable_to_non_nullable
as List<ProfitByCurrency>,invoices: null == invoices ? _self.invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<ProfitInvoice>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfitReport].
extension ProfitReportPatterns on ProfitReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfitReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfitReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfitReport value)  $default,){
final _that = this;
switch (_that) {
case _ProfitReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfitReport value)?  $default,){
final _that = this;
switch (_that) {
case _ProfitReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalRevenue,  double totalCost,  double totalProfit,  int invoicesCount,  List<ProfitByCurrency> byCurrency,  List<ProfitInvoice> invoices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfitReport() when $default != null:
return $default(_that.totalRevenue,_that.totalCost,_that.totalProfit,_that.invoicesCount,_that.byCurrency,_that.invoices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalRevenue,  double totalCost,  double totalProfit,  int invoicesCount,  List<ProfitByCurrency> byCurrency,  List<ProfitInvoice> invoices)  $default,) {final _that = this;
switch (_that) {
case _ProfitReport():
return $default(_that.totalRevenue,_that.totalCost,_that.totalProfit,_that.invoicesCount,_that.byCurrency,_that.invoices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalRevenue,  double totalCost,  double totalProfit,  int invoicesCount,  List<ProfitByCurrency> byCurrency,  List<ProfitInvoice> invoices)?  $default,) {final _that = this;
switch (_that) {
case _ProfitReport() when $default != null:
return $default(_that.totalRevenue,_that.totalCost,_that.totalProfit,_that.invoicesCount,_that.byCurrency,_that.invoices);case _:
  return null;

}
}

}

/// @nodoc


class _ProfitReport implements ProfitReport {
  const _ProfitReport({this.totalRevenue = 0, this.totalCost = 0, this.totalProfit = 0, this.invoicesCount = 0,  List<ProfitByCurrency> byCurrency = const <ProfitByCurrency>[],  List<ProfitInvoice> invoices = const <ProfitInvoice>[]}): _byCurrency = byCurrency,_invoices = invoices;
  

@override@JsonKey() final  double totalRevenue;
@override@JsonKey() final  double totalCost;
@override@JsonKey() final  double totalProfit;
@override@JsonKey() final  int invoicesCount;
 final  List<ProfitByCurrency> _byCurrency;
@override@JsonKey() List<ProfitByCurrency> get byCurrency {
  if (_byCurrency is EqualUnmodifiableListView) return _byCurrency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byCurrency);
}

 final  List<ProfitInvoice> _invoices;
@override@JsonKey() List<ProfitInvoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}


/// Create a copy of ProfitReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfitReportCopyWith<_ProfitReport> get copyWith => __$ProfitReportCopyWithImpl<_ProfitReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfitReport&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit)&&(identical(other.invoicesCount, invoicesCount) || other.invoicesCount == invoicesCount)&&const DeepCollectionEquality().equals(other.byCurrency, _byCurrency)&&const DeepCollectionEquality().equals(other.invoices, _invoices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalRevenue,totalCost,totalProfit,invoicesCount,const DeepCollectionEquality().hash(_byCurrency),const DeepCollectionEquality().hash(_invoices));
}

@override
String toString() {
    return 'ProfitReport(totalRevenue: $totalRevenue, totalCost: $totalCost, totalProfit: $totalProfit, invoicesCount: $invoicesCount, byCurrency: $byCurrency, invoices: $invoices)';
}


}

/// @nodoc
abstract mixin class _$ProfitReportCopyWith<$Res> implements $ProfitReportCopyWith<$Res> {
  factory _$ProfitReportCopyWith(_ProfitReport value, $Res Function(_ProfitReport) _then) = __$ProfitReportCopyWithImpl;
@override @useResult
$Res call({
 double totalRevenue, double totalCost, double totalProfit, int invoicesCount, List<ProfitByCurrency> byCurrency, List<ProfitInvoice> invoices
});




}
/// @nodoc
class __$ProfitReportCopyWithImpl<$Res>
    implements _$ProfitReportCopyWith<$Res> {
  __$ProfitReportCopyWithImpl(this._self, this._then);

  final _ProfitReport _self;
  final $Res Function(_ProfitReport) _then;

/// Create a copy of ProfitReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRevenue = null,Object? totalCost = null,Object? totalProfit = null,Object? invoicesCount = null,Object? byCurrency = null,Object? invoices = null,}) {
  return _then(_ProfitReport(
totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,byCurrency: null == byCurrency ? _self._byCurrency : byCurrency // ignore: cast_nullable_to_non_nullable
as List<ProfitByCurrency>,invoices: null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<ProfitInvoice>,
  ));
}


}

/// @nodoc
mixin _$ProfitByCurrency {

 String get currencyId; String get currencyCode; String get currencySymbol; int get invoicesCount; double get revenue; double get cost; double get profit;
/// Create a copy of ProfitByCurrency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfitByCurrencyCopyWith<ProfitByCurrency> get copyWith => _$ProfitByCurrencyCopyWithImpl<ProfitByCurrency>(this as ProfitByCurrency, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfitByCurrency;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfitByCurrency&&(identical(other.currencyId, _this.currencyId) || other.currencyId == _this.currencyId)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.currencySymbol, _this.currencySymbol) || other.currencySymbol == _this.currencySymbol)&&(identical(other.invoicesCount, _this.invoicesCount) || other.invoicesCount == _this.invoicesCount)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.profit, _this.profit) || other.profit == _this.profit));
}


@override
int get hashCode {
  final _this = this as ProfitByCurrency;
  return Object.hash(runtimeType,_this.currencyId,_this.currencyCode,_this.currencySymbol,_this.invoicesCount,_this.revenue,_this.cost,_this.profit);
}

@override
String toString() {
  final _this = this as ProfitByCurrency;
  return 'ProfitByCurrency(currencyId: ${_this.currencyId}, currencyCode: ${_this.currencyCode}, currencySymbol: ${_this.currencySymbol}, invoicesCount: ${_this.invoicesCount}, revenue: ${_this.revenue}, cost: ${_this.cost}, profit: ${_this.profit})';
}


}

/// @nodoc
abstract mixin class $ProfitByCurrencyCopyWith<$Res>  {
  factory $ProfitByCurrencyCopyWith(ProfitByCurrency value, $Res Function(ProfitByCurrency) _then) = _$ProfitByCurrencyCopyWithImpl;
@useResult
$Res call({
 String currencyId, String currencyCode, String currencySymbol, int invoicesCount, double revenue, double cost, double profit
});




}
/// @nodoc
class _$ProfitByCurrencyCopyWithImpl<$Res>
    implements $ProfitByCurrencyCopyWith<$Res> {
  _$ProfitByCurrencyCopyWithImpl(this._self, this._then);

  final ProfitByCurrency _self;
  final $Res Function(ProfitByCurrency) _then;

/// Create a copy of ProfitByCurrency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currencyId = null,Object? currencyCode = null,Object? currencySymbol = null,Object? invoicesCount = null,Object? revenue = null,Object? cost = null,Object? profit = null,}) {
  return _then(ProfitByCurrency(
currencyId: null == currencyId ? _self.currencyId : currencyId // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfitByCurrency].
extension ProfitByCurrencyPatterns on ProfitByCurrency {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfitByCurrency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfitByCurrency() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfitByCurrency value)  $default,){
final _that = this;
switch (_that) {
case _ProfitByCurrency():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfitByCurrency value)?  $default,){
final _that = this;
switch (_that) {
case _ProfitByCurrency() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currencyId,  String currencyCode,  String currencySymbol,  int invoicesCount,  double revenue,  double cost,  double profit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfitByCurrency() when $default != null:
return $default(_that.currencyId,_that.currencyCode,_that.currencySymbol,_that.invoicesCount,_that.revenue,_that.cost,_that.profit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currencyId,  String currencyCode,  String currencySymbol,  int invoicesCount,  double revenue,  double cost,  double profit)  $default,) {final _that = this;
switch (_that) {
case _ProfitByCurrency():
return $default(_that.currencyId,_that.currencyCode,_that.currencySymbol,_that.invoicesCount,_that.revenue,_that.cost,_that.profit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currencyId,  String currencyCode,  String currencySymbol,  int invoicesCount,  double revenue,  double cost,  double profit)?  $default,) {final _that = this;
switch (_that) {
case _ProfitByCurrency() when $default != null:
return $default(_that.currencyId,_that.currencyCode,_that.currencySymbol,_that.invoicesCount,_that.revenue,_that.cost,_that.profit);case _:
  return null;

}
}

}

/// @nodoc


class _ProfitByCurrency implements ProfitByCurrency {
  const _ProfitByCurrency({required this.currencyId, required this.currencyCode, required this.currencySymbol, required this.invoicesCount, required this.revenue, required this.cost, required this.profit});
  

@override final  String currencyId;
@override final  String currencyCode;
@override final  String currencySymbol;
@override final  int invoicesCount;
@override final  double revenue;
@override final  double cost;
@override final  double profit;

/// Create a copy of ProfitByCurrency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfitByCurrencyCopyWith<_ProfitByCurrency> get copyWith => __$ProfitByCurrencyCopyWithImpl<_ProfitByCurrency>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfitByCurrency&&(identical(other.currencyId, currencyId) || other.currencyId == currencyId)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.invoicesCount, invoicesCount) || other.invoicesCount == invoicesCount)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.profit, profit) || other.profit == profit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currencyId,currencyCode,currencySymbol,invoicesCount,revenue,cost,profit);
}

@override
String toString() {
    return 'ProfitByCurrency(currencyId: $currencyId, currencyCode: $currencyCode, currencySymbol: $currencySymbol, invoicesCount: $invoicesCount, revenue: $revenue, cost: $cost, profit: $profit)';
}


}

/// @nodoc
abstract mixin class _$ProfitByCurrencyCopyWith<$Res> implements $ProfitByCurrencyCopyWith<$Res> {
  factory _$ProfitByCurrencyCopyWith(_ProfitByCurrency value, $Res Function(_ProfitByCurrency) _then) = __$ProfitByCurrencyCopyWithImpl;
@override @useResult
$Res call({
 String currencyId, String currencyCode, String currencySymbol, int invoicesCount, double revenue, double cost, double profit
});




}
/// @nodoc
class __$ProfitByCurrencyCopyWithImpl<$Res>
    implements _$ProfitByCurrencyCopyWith<$Res> {
  __$ProfitByCurrencyCopyWithImpl(this._self, this._then);

  final _ProfitByCurrency _self;
  final $Res Function(_ProfitByCurrency) _then;

/// Create a copy of ProfitByCurrency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currencyId = null,Object? currencyCode = null,Object? currencySymbol = null,Object? invoicesCount = null,Object? revenue = null,Object? cost = null,Object? profit = null,}) {
  return _then(_ProfitByCurrency(
currencyId: null == currencyId ? _self.currencyId : currencyId // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ProfitInvoice {

 int get invoiceNumber; DateTime get saleDate; String get currencyCode; int get paymentMethod; double get revenue; double get cost; double get profit; String get originalCurrencyCode; double get originalExchangeRate;
/// Create a copy of ProfitInvoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfitInvoiceCopyWith<ProfitInvoice> get copyWith => _$ProfitInvoiceCopyWithImpl<ProfitInvoice>(this as ProfitInvoice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfitInvoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfitInvoice&&(identical(other.invoiceNumber, _this.invoiceNumber) || other.invoiceNumber == _this.invoiceNumber)&&(identical(other.saleDate, _this.saleDate) || other.saleDate == _this.saleDate)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.profit, _this.profit) || other.profit == _this.profit)&&(identical(other.originalCurrencyCode, _this.originalCurrencyCode) || other.originalCurrencyCode == _this.originalCurrencyCode)&&(identical(other.originalExchangeRate, _this.originalExchangeRate) || other.originalExchangeRate == _this.originalExchangeRate));
}


@override
int get hashCode {
  final _this = this as ProfitInvoice;
  return Object.hash(runtimeType,_this.invoiceNumber,_this.saleDate,_this.currencyCode,_this.paymentMethod,_this.revenue,_this.cost,_this.profit,_this.originalCurrencyCode,_this.originalExchangeRate);
}

@override
String toString() {
  final _this = this as ProfitInvoice;
  return 'ProfitInvoice(invoiceNumber: ${_this.invoiceNumber}, saleDate: ${_this.saleDate}, currencyCode: ${_this.currencyCode}, paymentMethod: ${_this.paymentMethod}, revenue: ${_this.revenue}, cost: ${_this.cost}, profit: ${_this.profit}, originalCurrencyCode: ${_this.originalCurrencyCode}, originalExchangeRate: ${_this.originalExchangeRate})';
}


}

/// @nodoc
abstract mixin class $ProfitInvoiceCopyWith<$Res>  {
  factory $ProfitInvoiceCopyWith(ProfitInvoice value, $Res Function(ProfitInvoice) _then) = _$ProfitInvoiceCopyWithImpl;
@useResult
$Res call({
 int invoiceNumber, DateTime saleDate, String currencyCode, int paymentMethod, double revenue, double cost, double profit, String originalCurrencyCode, double originalExchangeRate
});




}
/// @nodoc
class _$ProfitInvoiceCopyWithImpl<$Res>
    implements $ProfitInvoiceCopyWith<$Res> {
  _$ProfitInvoiceCopyWithImpl(this._self, this._then);

  final ProfitInvoice _self;
  final $Res Function(ProfitInvoice) _then;

/// Create a copy of ProfitInvoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoiceNumber = null,Object? saleDate = null,Object? currencyCode = null,Object? paymentMethod = null,Object? revenue = null,Object? cost = null,Object? profit = null,Object? originalCurrencyCode = null,Object? originalExchangeRate = null,}) {
  return _then(ProfitInvoice(
invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,saleDate: null == saleDate ? _self.saleDate : saleDate // ignore: cast_nullable_to_non_nullable
as DateTime,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,originalCurrencyCode: null == originalCurrencyCode ? _self.originalCurrencyCode : originalCurrencyCode // ignore: cast_nullable_to_non_nullable
as String,originalExchangeRate: null == originalExchangeRate ? _self.originalExchangeRate : originalExchangeRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfitInvoice].
extension ProfitInvoicePatterns on ProfitInvoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfitInvoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfitInvoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfitInvoice value)  $default,){
final _that = this;
switch (_that) {
case _ProfitInvoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfitInvoice value)?  $default,){
final _that = this;
switch (_that) {
case _ProfitInvoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int invoiceNumber,  DateTime saleDate,  String currencyCode,  int paymentMethod,  double revenue,  double cost,  double profit,  String originalCurrencyCode,  double originalExchangeRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfitInvoice() when $default != null:
return $default(_that.invoiceNumber,_that.saleDate,_that.currencyCode,_that.paymentMethod,_that.revenue,_that.cost,_that.profit,_that.originalCurrencyCode,_that.originalExchangeRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int invoiceNumber,  DateTime saleDate,  String currencyCode,  int paymentMethod,  double revenue,  double cost,  double profit,  String originalCurrencyCode,  double originalExchangeRate)  $default,) {final _that = this;
switch (_that) {
case _ProfitInvoice():
return $default(_that.invoiceNumber,_that.saleDate,_that.currencyCode,_that.paymentMethod,_that.revenue,_that.cost,_that.profit,_that.originalCurrencyCode,_that.originalExchangeRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int invoiceNumber,  DateTime saleDate,  String currencyCode,  int paymentMethod,  double revenue,  double cost,  double profit,  String originalCurrencyCode,  double originalExchangeRate)?  $default,) {final _that = this;
switch (_that) {
case _ProfitInvoice() when $default != null:
return $default(_that.invoiceNumber,_that.saleDate,_that.currencyCode,_that.paymentMethod,_that.revenue,_that.cost,_that.profit,_that.originalCurrencyCode,_that.originalExchangeRate);case _:
  return null;

}
}

}

/// @nodoc


class _ProfitInvoice implements ProfitInvoice {
  const _ProfitInvoice({required this.invoiceNumber, required this.saleDate, required this.currencyCode, required this.paymentMethod, required this.revenue, required this.cost, required this.profit, this.originalCurrencyCode = '', this.originalExchangeRate = 1});
  

@override final  int invoiceNumber;
@override final  DateTime saleDate;
@override final  String currencyCode;
@override final  int paymentMethod;
@override final  double revenue;
@override final  double cost;
@override final  double profit;
@override@JsonKey() final  String originalCurrencyCode;
@override@JsonKey() final  double originalExchangeRate;

/// Create a copy of ProfitInvoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfitInvoiceCopyWith<_ProfitInvoice> get copyWith => __$ProfitInvoiceCopyWithImpl<_ProfitInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfitInvoice&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.saleDate, saleDate) || other.saleDate == saleDate)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.originalCurrencyCode, originalCurrencyCode) || other.originalCurrencyCode == originalCurrencyCode)&&(identical(other.originalExchangeRate, originalExchangeRate) || other.originalExchangeRate == originalExchangeRate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,invoiceNumber,saleDate,currencyCode,paymentMethod,revenue,cost,profit,originalCurrencyCode,originalExchangeRate);
}

@override
String toString() {
    return 'ProfitInvoice(invoiceNumber: $invoiceNumber, saleDate: $saleDate, currencyCode: $currencyCode, paymentMethod: $paymentMethod, revenue: $revenue, cost: $cost, profit: $profit, originalCurrencyCode: $originalCurrencyCode, originalExchangeRate: $originalExchangeRate)';
}


}

/// @nodoc
abstract mixin class _$ProfitInvoiceCopyWith<$Res> implements $ProfitInvoiceCopyWith<$Res> {
  factory _$ProfitInvoiceCopyWith(_ProfitInvoice value, $Res Function(_ProfitInvoice) _then) = __$ProfitInvoiceCopyWithImpl;
@override @useResult
$Res call({
 int invoiceNumber, DateTime saleDate, String currencyCode, int paymentMethod, double revenue, double cost, double profit, String originalCurrencyCode, double originalExchangeRate
});




}
/// @nodoc
class __$ProfitInvoiceCopyWithImpl<$Res>
    implements _$ProfitInvoiceCopyWith<$Res> {
  __$ProfitInvoiceCopyWithImpl(this._self, this._then);

  final _ProfitInvoice _self;
  final $Res Function(_ProfitInvoice) _then;

/// Create a copy of ProfitInvoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoiceNumber = null,Object? saleDate = null,Object? currencyCode = null,Object? paymentMethod = null,Object? revenue = null,Object? cost = null,Object? profit = null,Object? originalCurrencyCode = null,Object? originalExchangeRate = null,}) {
  return _then(_ProfitInvoice(
invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,saleDate: null == saleDate ? _self.saleDate : saleDate // ignore: cast_nullable_to_non_nullable
as DateTime,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,originalCurrencyCode: null == originalCurrencyCode ? _self.originalCurrencyCode : originalCurrencyCode // ignore: cast_nullable_to_non_nullable
as String,originalExchangeRate: null == originalExchangeRate ? _self.originalExchangeRate : originalExchangeRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
