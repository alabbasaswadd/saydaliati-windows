// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_grid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesGridInvoice {

 int get invoiceNumber; DateTime get saleDate; String get customerName; int get paymentMethod; String get warehouseName; String get currencyCode; String get currencySymbol; String get originalCurrencyCode; double get originalExchangeRate; double get discountAmount; double get totalAmount; double get cost; double get profit; double get profitMargin; bool get costMissing; List<SalesGridItem> get items;
/// Create a copy of SalesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesGridInvoiceCopyWith<SalesGridInvoice> get copyWith => _$SalesGridInvoiceCopyWithImpl<SalesGridInvoice>(this as SalesGridInvoice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesGridInvoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesGridInvoice&&(identical(other.invoiceNumber, _this.invoiceNumber) || other.invoiceNumber == _this.invoiceNumber)&&(identical(other.saleDate, _this.saleDate) || other.saleDate == _this.saleDate)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.currencySymbol, _this.currencySymbol) || other.currencySymbol == _this.currencySymbol)&&(identical(other.originalCurrencyCode, _this.originalCurrencyCode) || other.originalCurrencyCode == _this.originalCurrencyCode)&&(identical(other.originalExchangeRate, _this.originalExchangeRate) || other.originalExchangeRate == _this.originalExchangeRate)&&(identical(other.discountAmount, _this.discountAmount) || other.discountAmount == _this.discountAmount)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.profit, _this.profit) || other.profit == _this.profit)&&(identical(other.profitMargin, _this.profitMargin) || other.profitMargin == _this.profitMargin)&&(identical(other.costMissing, _this.costMissing) || other.costMissing == _this.costMissing)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as SalesGridInvoice;
  return Object.hash(runtimeType,_this.invoiceNumber,_this.saleDate,_this.customerName,_this.paymentMethod,_this.warehouseName,_this.currencyCode,_this.currencySymbol,_this.originalCurrencyCode,_this.originalExchangeRate,_this.discountAmount,_this.totalAmount,_this.cost,_this.profit,_this.profitMargin,_this.costMissing,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as SalesGridInvoice;
  return 'SalesGridInvoice(invoiceNumber: ${_this.invoiceNumber}, saleDate: ${_this.saleDate}, customerName: ${_this.customerName}, paymentMethod: ${_this.paymentMethod}, warehouseName: ${_this.warehouseName}, currencyCode: ${_this.currencyCode}, currencySymbol: ${_this.currencySymbol}, originalCurrencyCode: ${_this.originalCurrencyCode}, originalExchangeRate: ${_this.originalExchangeRate}, discountAmount: ${_this.discountAmount}, totalAmount: ${_this.totalAmount}, cost: ${_this.cost}, profit: ${_this.profit}, profitMargin: ${_this.profitMargin}, costMissing: ${_this.costMissing}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $SalesGridInvoiceCopyWith<$Res>  {
  factory $SalesGridInvoiceCopyWith(SalesGridInvoice value, $Res Function(SalesGridInvoice) _then) = _$SalesGridInvoiceCopyWithImpl;
@useResult
$Res call({
 int invoiceNumber, DateTime saleDate, String customerName, int paymentMethod, String warehouseName, String currencyCode, String currencySymbol, String originalCurrencyCode, double originalExchangeRate, double discountAmount, double totalAmount, double cost, double profit, double profitMargin, bool costMissing, List<SalesGridItem> items
});




}
/// @nodoc
class _$SalesGridInvoiceCopyWithImpl<$Res>
    implements $SalesGridInvoiceCopyWith<$Res> {
  _$SalesGridInvoiceCopyWithImpl(this._self, this._then);

  final SalesGridInvoice _self;
  final $Res Function(SalesGridInvoice) _then;

/// Create a copy of SalesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoiceNumber = null,Object? saleDate = null,Object? customerName = null,Object? paymentMethod = null,Object? warehouseName = null,Object? currencyCode = null,Object? currencySymbol = null,Object? originalCurrencyCode = null,Object? originalExchangeRate = null,Object? discountAmount = null,Object? totalAmount = null,Object? cost = null,Object? profit = null,Object? profitMargin = null,Object? costMissing = null,Object? items = null,}) {
  return _then(SalesGridInvoice(
invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,saleDate: null == saleDate ? _self.saleDate : saleDate // ignore: cast_nullable_to_non_nullable
as DateTime,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,originalCurrencyCode: null == originalCurrencyCode ? _self.originalCurrencyCode : originalCurrencyCode // ignore: cast_nullable_to_non_nullable
as String,originalExchangeRate: null == originalExchangeRate ? _self.originalExchangeRate : originalExchangeRate // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,profitMargin: null == profitMargin ? _self.profitMargin : profitMargin // ignore: cast_nullable_to_non_nullable
as double,costMissing: null == costMissing ? _self.costMissing : costMissing // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SalesGridItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesGridInvoice].
extension SalesGridInvoicePatterns on SalesGridInvoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesGridInvoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesGridInvoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesGridInvoice value)  $default,){
final _that = this;
switch (_that) {
case _SalesGridInvoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesGridInvoice value)?  $default,){
final _that = this;
switch (_that) {
case _SalesGridInvoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int invoiceNumber,  DateTime saleDate,  String customerName,  int paymentMethod,  String warehouseName,  String currencyCode,  String currencySymbol,  String originalCurrencyCode,  double originalExchangeRate,  double discountAmount,  double totalAmount,  double cost,  double profit,  double profitMargin,  bool costMissing,  List<SalesGridItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesGridInvoice() when $default != null:
return $default(_that.invoiceNumber,_that.saleDate,_that.customerName,_that.paymentMethod,_that.warehouseName,_that.currencyCode,_that.currencySymbol,_that.originalCurrencyCode,_that.originalExchangeRate,_that.discountAmount,_that.totalAmount,_that.cost,_that.profit,_that.profitMargin,_that.costMissing,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int invoiceNumber,  DateTime saleDate,  String customerName,  int paymentMethod,  String warehouseName,  String currencyCode,  String currencySymbol,  String originalCurrencyCode,  double originalExchangeRate,  double discountAmount,  double totalAmount,  double cost,  double profit,  double profitMargin,  bool costMissing,  List<SalesGridItem> items)  $default,) {final _that = this;
switch (_that) {
case _SalesGridInvoice():
return $default(_that.invoiceNumber,_that.saleDate,_that.customerName,_that.paymentMethod,_that.warehouseName,_that.currencyCode,_that.currencySymbol,_that.originalCurrencyCode,_that.originalExchangeRate,_that.discountAmount,_that.totalAmount,_that.cost,_that.profit,_that.profitMargin,_that.costMissing,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int invoiceNumber,  DateTime saleDate,  String customerName,  int paymentMethod,  String warehouseName,  String currencyCode,  String currencySymbol,  String originalCurrencyCode,  double originalExchangeRate,  double discountAmount,  double totalAmount,  double cost,  double profit,  double profitMargin,  bool costMissing,  List<SalesGridItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SalesGridInvoice() when $default != null:
return $default(_that.invoiceNumber,_that.saleDate,_that.customerName,_that.paymentMethod,_that.warehouseName,_that.currencyCode,_that.currencySymbol,_that.originalCurrencyCode,_that.originalExchangeRate,_that.discountAmount,_that.totalAmount,_that.cost,_that.profit,_that.profitMargin,_that.costMissing,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _SalesGridInvoice implements SalesGridInvoice {
  const _SalesGridInvoice({required this.invoiceNumber, required this.saleDate, this.customerName = '', this.paymentMethod = 0, this.warehouseName = '', this.currencyCode = '', this.currencySymbol = '', this.originalCurrencyCode = '', this.originalExchangeRate = 1, this.discountAmount = 0, this.totalAmount = 0, this.cost = 0, this.profit = 0, this.profitMargin = 0, this.costMissing = false,  List<SalesGridItem> items = const <SalesGridItem>[]}): _items = items;
  

@override final  int invoiceNumber;
@override final  DateTime saleDate;
@override@JsonKey() final  String customerName;
@override@JsonKey() final  int paymentMethod;
@override@JsonKey() final  String warehouseName;
@override@JsonKey() final  String currencyCode;
@override@JsonKey() final  String currencySymbol;
@override@JsonKey() final  String originalCurrencyCode;
@override@JsonKey() final  double originalExchangeRate;
@override@JsonKey() final  double discountAmount;
@override@JsonKey() final  double totalAmount;
@override@JsonKey() final  double cost;
@override@JsonKey() final  double profit;
@override@JsonKey() final  double profitMargin;
@override@JsonKey() final  bool costMissing;
 final  List<SalesGridItem> _items;
@override@JsonKey() List<SalesGridItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SalesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesGridInvoiceCopyWith<_SalesGridInvoice> get copyWith => __$SalesGridInvoiceCopyWithImpl<_SalesGridInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesGridInvoice&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.saleDate, saleDate) || other.saleDate == saleDate)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.originalCurrencyCode, originalCurrencyCode) || other.originalCurrencyCode == originalCurrencyCode)&&(identical(other.originalExchangeRate, originalExchangeRate) || other.originalExchangeRate == originalExchangeRate)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.profitMargin, profitMargin) || other.profitMargin == profitMargin)&&(identical(other.costMissing, costMissing) || other.costMissing == costMissing)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,invoiceNumber,saleDate,customerName,paymentMethod,warehouseName,currencyCode,currencySymbol,originalCurrencyCode,originalExchangeRate,discountAmount,totalAmount,cost,profit,profitMargin,costMissing,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'SalesGridInvoice(invoiceNumber: $invoiceNumber, saleDate: $saleDate, customerName: $customerName, paymentMethod: $paymentMethod, warehouseName: $warehouseName, currencyCode: $currencyCode, currencySymbol: $currencySymbol, originalCurrencyCode: $originalCurrencyCode, originalExchangeRate: $originalExchangeRate, discountAmount: $discountAmount, totalAmount: $totalAmount, cost: $cost, profit: $profit, profitMargin: $profitMargin, costMissing: $costMissing, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SalesGridInvoiceCopyWith<$Res> implements $SalesGridInvoiceCopyWith<$Res> {
  factory _$SalesGridInvoiceCopyWith(_SalesGridInvoice value, $Res Function(_SalesGridInvoice) _then) = __$SalesGridInvoiceCopyWithImpl;
@override @useResult
$Res call({
 int invoiceNumber, DateTime saleDate, String customerName, int paymentMethod, String warehouseName, String currencyCode, String currencySymbol, String originalCurrencyCode, double originalExchangeRate, double discountAmount, double totalAmount, double cost, double profit, double profitMargin, bool costMissing, List<SalesGridItem> items
});




}
/// @nodoc
class __$SalesGridInvoiceCopyWithImpl<$Res>
    implements _$SalesGridInvoiceCopyWith<$Res> {
  __$SalesGridInvoiceCopyWithImpl(this._self, this._then);

  final _SalesGridInvoice _self;
  final $Res Function(_SalesGridInvoice) _then;

/// Create a copy of SalesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoiceNumber = null,Object? saleDate = null,Object? customerName = null,Object? paymentMethod = null,Object? warehouseName = null,Object? currencyCode = null,Object? currencySymbol = null,Object? originalCurrencyCode = null,Object? originalExchangeRate = null,Object? discountAmount = null,Object? totalAmount = null,Object? cost = null,Object? profit = null,Object? profitMargin = null,Object? costMissing = null,Object? items = null,}) {
  return _then(_SalesGridInvoice(
invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,saleDate: null == saleDate ? _self.saleDate : saleDate // ignore: cast_nullable_to_non_nullable
as DateTime,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,originalCurrencyCode: null == originalCurrencyCode ? _self.originalCurrencyCode : originalCurrencyCode // ignore: cast_nullable_to_non_nullable
as String,originalExchangeRate: null == originalExchangeRate ? _self.originalExchangeRate : originalExchangeRate // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,profitMargin: null == profitMargin ? _self.profitMargin : profitMargin // ignore: cast_nullable_to_non_nullable
as double,costMissing: null == costMissing ? _self.costMissing : costMissing // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SalesGridItem>,
  ));
}


}

/// @nodoc
mixin _$SalesGridItem {

 String get brandName; String get unitName; double get quantity; double get unitPrice; double get discount; double get subTotal; double get unitCost; double get lineCost; double get lineProfit; bool get costMissing;
/// Create a copy of SalesGridItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesGridItemCopyWith<SalesGridItem> get copyWith => _$SalesGridItemCopyWithImpl<SalesGridItem>(this as SalesGridItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesGridItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesGridItem&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.subTotal, _this.subTotal) || other.subTotal == _this.subTotal)&&(identical(other.unitCost, _this.unitCost) || other.unitCost == _this.unitCost)&&(identical(other.lineCost, _this.lineCost) || other.lineCost == _this.lineCost)&&(identical(other.lineProfit, _this.lineProfit) || other.lineProfit == _this.lineProfit)&&(identical(other.costMissing, _this.costMissing) || other.costMissing == _this.costMissing));
}


@override
int get hashCode {
  final _this = this as SalesGridItem;
  return Object.hash(runtimeType,_this.brandName,_this.unitName,_this.quantity,_this.unitPrice,_this.discount,_this.subTotal,_this.unitCost,_this.lineCost,_this.lineProfit,_this.costMissing);
}

@override
String toString() {
  final _this = this as SalesGridItem;
  return 'SalesGridItem(brandName: ${_this.brandName}, unitName: ${_this.unitName}, quantity: ${_this.quantity}, unitPrice: ${_this.unitPrice}, discount: ${_this.discount}, subTotal: ${_this.subTotal}, unitCost: ${_this.unitCost}, lineCost: ${_this.lineCost}, lineProfit: ${_this.lineProfit}, costMissing: ${_this.costMissing})';
}


}

/// @nodoc
abstract mixin class $SalesGridItemCopyWith<$Res>  {
  factory $SalesGridItemCopyWith(SalesGridItem value, $Res Function(SalesGridItem) _then) = _$SalesGridItemCopyWithImpl;
@useResult
$Res call({
 String brandName, String unitName, double quantity, double unitPrice, double discount, double subTotal, double unitCost, double lineCost, double lineProfit, bool costMissing
});




}
/// @nodoc
class _$SalesGridItemCopyWithImpl<$Res>
    implements $SalesGridItemCopyWith<$Res> {
  _$SalesGridItemCopyWithImpl(this._self, this._then);

  final SalesGridItem _self;
  final $Res Function(SalesGridItem) _then;

/// Create a copy of SalesGridItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brandName = null,Object? unitName = null,Object? quantity = null,Object? unitPrice = null,Object? discount = null,Object? subTotal = null,Object? unitCost = null,Object? lineCost = null,Object? lineProfit = null,Object? costMissing = null,}) {
  return _then(SalesGridItem(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,lineCost: null == lineCost ? _self.lineCost : lineCost // ignore: cast_nullable_to_non_nullable
as double,lineProfit: null == lineProfit ? _self.lineProfit : lineProfit // ignore: cast_nullable_to_non_nullable
as double,costMissing: null == costMissing ? _self.costMissing : costMissing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesGridItem].
extension SalesGridItemPatterns on SalesGridItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesGridItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesGridItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesGridItem value)  $default,){
final _that = this;
switch (_that) {
case _SalesGridItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesGridItem value)?  $default,){
final _that = this;
switch (_that) {
case _SalesGridItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brandName,  String unitName,  double quantity,  double unitPrice,  double discount,  double subTotal,  double unitCost,  double lineCost,  double lineProfit,  bool costMissing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesGridItem() when $default != null:
return $default(_that.brandName,_that.unitName,_that.quantity,_that.unitPrice,_that.discount,_that.subTotal,_that.unitCost,_that.lineCost,_that.lineProfit,_that.costMissing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brandName,  String unitName,  double quantity,  double unitPrice,  double discount,  double subTotal,  double unitCost,  double lineCost,  double lineProfit,  bool costMissing)  $default,) {final _that = this;
switch (_that) {
case _SalesGridItem():
return $default(_that.brandName,_that.unitName,_that.quantity,_that.unitPrice,_that.discount,_that.subTotal,_that.unitCost,_that.lineCost,_that.lineProfit,_that.costMissing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brandName,  String unitName,  double quantity,  double unitPrice,  double discount,  double subTotal,  double unitCost,  double lineCost,  double lineProfit,  bool costMissing)?  $default,) {final _that = this;
switch (_that) {
case _SalesGridItem() when $default != null:
return $default(_that.brandName,_that.unitName,_that.quantity,_that.unitPrice,_that.discount,_that.subTotal,_that.unitCost,_that.lineCost,_that.lineProfit,_that.costMissing);case _:
  return null;

}
}

}

/// @nodoc


class _SalesGridItem implements SalesGridItem {
  const _SalesGridItem({this.brandName = '', this.unitName = '', this.quantity = 0, this.unitPrice = 0, this.discount = 0, this.subTotal = 0, this.unitCost = 0, this.lineCost = 0, this.lineProfit = 0, this.costMissing = false});
  

@override@JsonKey() final  String brandName;
@override@JsonKey() final  String unitName;
@override@JsonKey() final  double quantity;
@override@JsonKey() final  double unitPrice;
@override@JsonKey() final  double discount;
@override@JsonKey() final  double subTotal;
@override@JsonKey() final  double unitCost;
@override@JsonKey() final  double lineCost;
@override@JsonKey() final  double lineProfit;
@override@JsonKey() final  bool costMissing;

/// Create a copy of SalesGridItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesGridItemCopyWith<_SalesGridItem> get copyWith => __$SalesGridItemCopyWithImpl<_SalesGridItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesGridItem&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.lineCost, lineCost) || other.lineCost == lineCost)&&(identical(other.lineProfit, lineProfit) || other.lineProfit == lineProfit)&&(identical(other.costMissing, costMissing) || other.costMissing == costMissing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,brandName,unitName,quantity,unitPrice,discount,subTotal,unitCost,lineCost,lineProfit,costMissing);
}

@override
String toString() {
    return 'SalesGridItem(brandName: $brandName, unitName: $unitName, quantity: $quantity, unitPrice: $unitPrice, discount: $discount, subTotal: $subTotal, unitCost: $unitCost, lineCost: $lineCost, lineProfit: $lineProfit, costMissing: $costMissing)';
}


}

/// @nodoc
abstract mixin class _$SalesGridItemCopyWith<$Res> implements $SalesGridItemCopyWith<$Res> {
  factory _$SalesGridItemCopyWith(_SalesGridItem value, $Res Function(_SalesGridItem) _then) = __$SalesGridItemCopyWithImpl;
@override @useResult
$Res call({
 String brandName, String unitName, double quantity, double unitPrice, double discount, double subTotal, double unitCost, double lineCost, double lineProfit, bool costMissing
});




}
/// @nodoc
class __$SalesGridItemCopyWithImpl<$Res>
    implements _$SalesGridItemCopyWith<$Res> {
  __$SalesGridItemCopyWithImpl(this._self, this._then);

  final _SalesGridItem _self;
  final $Res Function(_SalesGridItem) _then;

/// Create a copy of SalesGridItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brandName = null,Object? unitName = null,Object? quantity = null,Object? unitPrice = null,Object? discount = null,Object? subTotal = null,Object? unitCost = null,Object? lineCost = null,Object? lineProfit = null,Object? costMissing = null,}) {
  return _then(_SalesGridItem(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,lineCost: null == lineCost ? _self.lineCost : lineCost // ignore: cast_nullable_to_non_nullable
as double,lineProfit: null == lineProfit ? _self.lineProfit : lineProfit // ignore: cast_nullable_to_non_nullable
as double,costMissing: null == costMissing ? _self.costMissing : costMissing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
