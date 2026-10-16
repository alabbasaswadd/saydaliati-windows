// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchases_grid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchasesGridInvoice {

 String get purchaseId; int get invoiceNumber; DateTime get purchaseDate; String get supplierName; int get paymentMethod; String get warehouseName; String get currencyCode; String get currencySymbol; double get discountAmount; double get totalAmount; int get itemsCount;/// مجموع كميات البونص في الفاتورة — يُقرأ على الترويسة بلا توسيعها.
 double get bonusQuantity; List<PurchasesGridItem> get items;
/// Create a copy of PurchasesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchasesGridInvoiceCopyWith<PurchasesGridInvoice> get copyWith => _$PurchasesGridInvoiceCopyWithImpl<PurchasesGridInvoice>(this as PurchasesGridInvoice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchasesGridInvoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchasesGridInvoice&&(identical(other.purchaseId, _this.purchaseId) || other.purchaseId == _this.purchaseId)&&(identical(other.invoiceNumber, _this.invoiceNumber) || other.invoiceNumber == _this.invoiceNumber)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.supplierName, _this.supplierName) || other.supplierName == _this.supplierName)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.currencySymbol, _this.currencySymbol) || other.currencySymbol == _this.currencySymbol)&&(identical(other.discountAmount, _this.discountAmount) || other.discountAmount == _this.discountAmount)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.itemsCount, _this.itemsCount) || other.itemsCount == _this.itemsCount)&&(identical(other.bonusQuantity, _this.bonusQuantity) || other.bonusQuantity == _this.bonusQuantity)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as PurchasesGridInvoice;
  return Object.hash(runtimeType,_this.purchaseId,_this.invoiceNumber,_this.purchaseDate,_this.supplierName,_this.paymentMethod,_this.warehouseName,_this.currencyCode,_this.currencySymbol,_this.discountAmount,_this.totalAmount,_this.itemsCount,_this.bonusQuantity,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PurchasesGridInvoice;
  return 'PurchasesGridInvoice(purchaseId: ${_this.purchaseId}, invoiceNumber: ${_this.invoiceNumber}, purchaseDate: ${_this.purchaseDate}, supplierName: ${_this.supplierName}, paymentMethod: ${_this.paymentMethod}, warehouseName: ${_this.warehouseName}, currencyCode: ${_this.currencyCode}, currencySymbol: ${_this.currencySymbol}, discountAmount: ${_this.discountAmount}, totalAmount: ${_this.totalAmount}, itemsCount: ${_this.itemsCount}, bonusQuantity: ${_this.bonusQuantity}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PurchasesGridInvoiceCopyWith<$Res>  {
  factory $PurchasesGridInvoiceCopyWith(PurchasesGridInvoice value, $Res Function(PurchasesGridInvoice) _then) = _$PurchasesGridInvoiceCopyWithImpl;
@useResult
$Res call({
 String purchaseId, int invoiceNumber, DateTime purchaseDate, String supplierName, int paymentMethod, String warehouseName, String currencyCode, String currencySymbol, double discountAmount, double totalAmount, int itemsCount, double bonusQuantity, List<PurchasesGridItem> items
});




}
/// @nodoc
class _$PurchasesGridInvoiceCopyWithImpl<$Res>
    implements $PurchasesGridInvoiceCopyWith<$Res> {
  _$PurchasesGridInvoiceCopyWithImpl(this._self, this._then);

  final PurchasesGridInvoice _self;
  final $Res Function(PurchasesGridInvoice) _then;

/// Create a copy of PurchasesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? purchaseId = null,Object? invoiceNumber = null,Object? purchaseDate = null,Object? supplierName = null,Object? paymentMethod = null,Object? warehouseName = null,Object? currencyCode = null,Object? currencySymbol = null,Object? discountAmount = null,Object? totalAmount = null,Object? itemsCount = null,Object? bonusQuantity = null,Object? items = null,}) {
  return _then(PurchasesGridInvoice(
purchaseId: null == purchaseId ? _self.purchaseId : purchaseId // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,itemsCount: null == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int,bonusQuantity: null == bonusQuantity ? _self.bonusQuantity : bonusQuantity // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PurchasesGridItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchasesGridInvoice].
extension PurchasesGridInvoicePatterns on PurchasesGridInvoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchasesGridInvoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchasesGridInvoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchasesGridInvoice value)  $default,){
final _that = this;
switch (_that) {
case _PurchasesGridInvoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchasesGridInvoice value)?  $default,){
final _that = this;
switch (_that) {
case _PurchasesGridInvoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String purchaseId,  int invoiceNumber,  DateTime purchaseDate,  String supplierName,  int paymentMethod,  String warehouseName,  String currencyCode,  String currencySymbol,  double discountAmount,  double totalAmount,  int itemsCount,  double bonusQuantity,  List<PurchasesGridItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchasesGridInvoice() when $default != null:
return $default(_that.purchaseId,_that.invoiceNumber,_that.purchaseDate,_that.supplierName,_that.paymentMethod,_that.warehouseName,_that.currencyCode,_that.currencySymbol,_that.discountAmount,_that.totalAmount,_that.itemsCount,_that.bonusQuantity,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String purchaseId,  int invoiceNumber,  DateTime purchaseDate,  String supplierName,  int paymentMethod,  String warehouseName,  String currencyCode,  String currencySymbol,  double discountAmount,  double totalAmount,  int itemsCount,  double bonusQuantity,  List<PurchasesGridItem> items)  $default,) {final _that = this;
switch (_that) {
case _PurchasesGridInvoice():
return $default(_that.purchaseId,_that.invoiceNumber,_that.purchaseDate,_that.supplierName,_that.paymentMethod,_that.warehouseName,_that.currencyCode,_that.currencySymbol,_that.discountAmount,_that.totalAmount,_that.itemsCount,_that.bonusQuantity,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String purchaseId,  int invoiceNumber,  DateTime purchaseDate,  String supplierName,  int paymentMethod,  String warehouseName,  String currencyCode,  String currencySymbol,  double discountAmount,  double totalAmount,  int itemsCount,  double bonusQuantity,  List<PurchasesGridItem> items)?  $default,) {final _that = this;
switch (_that) {
case _PurchasesGridInvoice() when $default != null:
return $default(_that.purchaseId,_that.invoiceNumber,_that.purchaseDate,_that.supplierName,_that.paymentMethod,_that.warehouseName,_that.currencyCode,_that.currencySymbol,_that.discountAmount,_that.totalAmount,_that.itemsCount,_that.bonusQuantity,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _PurchasesGridInvoice implements PurchasesGridInvoice {
  const _PurchasesGridInvoice({this.purchaseId = '', required this.invoiceNumber, required this.purchaseDate, this.supplierName = '', this.paymentMethod = 0, this.warehouseName = '', this.currencyCode = '', this.currencySymbol = '', this.discountAmount = 0, this.totalAmount = 0, this.itemsCount = 0, this.bonusQuantity = 0,  List<PurchasesGridItem> items = const <PurchasesGridItem>[]}): _items = items;
  

@override@JsonKey() final  String purchaseId;
@override final  int invoiceNumber;
@override final  DateTime purchaseDate;
@override@JsonKey() final  String supplierName;
@override@JsonKey() final  int paymentMethod;
@override@JsonKey() final  String warehouseName;
@override@JsonKey() final  String currencyCode;
@override@JsonKey() final  String currencySymbol;
@override@JsonKey() final  double discountAmount;
@override@JsonKey() final  double totalAmount;
@override@JsonKey() final  int itemsCount;
/// مجموع كميات البونص في الفاتورة — يُقرأ على الترويسة بلا توسيعها.
@override@JsonKey() final  double bonusQuantity;
 final  List<PurchasesGridItem> _items;
@override@JsonKey() List<PurchasesGridItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PurchasesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchasesGridInvoiceCopyWith<_PurchasesGridInvoice> get copyWith => __$PurchasesGridInvoiceCopyWithImpl<_PurchasesGridInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchasesGridInvoice&&(identical(other.purchaseId, purchaseId) || other.purchaseId == purchaseId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.bonusQuantity, bonusQuantity) || other.bonusQuantity == bonusQuantity)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,purchaseId,invoiceNumber,purchaseDate,supplierName,paymentMethod,warehouseName,currencyCode,currencySymbol,discountAmount,totalAmount,itemsCount,bonusQuantity,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PurchasesGridInvoice(purchaseId: $purchaseId, invoiceNumber: $invoiceNumber, purchaseDate: $purchaseDate, supplierName: $supplierName, paymentMethod: $paymentMethod, warehouseName: $warehouseName, currencyCode: $currencyCode, currencySymbol: $currencySymbol, discountAmount: $discountAmount, totalAmount: $totalAmount, itemsCount: $itemsCount, bonusQuantity: $bonusQuantity, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PurchasesGridInvoiceCopyWith<$Res> implements $PurchasesGridInvoiceCopyWith<$Res> {
  factory _$PurchasesGridInvoiceCopyWith(_PurchasesGridInvoice value, $Res Function(_PurchasesGridInvoice) _then) = __$PurchasesGridInvoiceCopyWithImpl;
@override @useResult
$Res call({
 String purchaseId, int invoiceNumber, DateTime purchaseDate, String supplierName, int paymentMethod, String warehouseName, String currencyCode, String currencySymbol, double discountAmount, double totalAmount, int itemsCount, double bonusQuantity, List<PurchasesGridItem> items
});




}
/// @nodoc
class __$PurchasesGridInvoiceCopyWithImpl<$Res>
    implements _$PurchasesGridInvoiceCopyWith<$Res> {
  __$PurchasesGridInvoiceCopyWithImpl(this._self, this._then);

  final _PurchasesGridInvoice _self;
  final $Res Function(_PurchasesGridInvoice) _then;

/// Create a copy of PurchasesGridInvoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? purchaseId = null,Object? invoiceNumber = null,Object? purchaseDate = null,Object? supplierName = null,Object? paymentMethod = null,Object? warehouseName = null,Object? currencyCode = null,Object? currencySymbol = null,Object? discountAmount = null,Object? totalAmount = null,Object? itemsCount = null,Object? bonusQuantity = null,Object? items = null,}) {
  return _then(_PurchasesGridInvoice(
purchaseId: null == purchaseId ? _self.purchaseId : purchaseId // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,itemsCount: null == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int,bonusQuantity: null == bonusQuantity ? _self.bonusQuantity : bonusQuantity // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PurchasesGridItem>,
  ));
}


}

/// @nodoc
mixin _$PurchasesGridItem {

 String get brandName; String get unitName; double get quantity;/// كمية البونص — بلا ثمن وبكلفة صفر، فبيعها ربح صافٍ كامل.
 double get bonusQuantity; double get unitPrice; double get discount; double get subTotal; String get batchNumber; DateTime? get expiryDate;
/// Create a copy of PurchasesGridItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchasesGridItemCopyWith<PurchasesGridItem> get copyWith => _$PurchasesGridItemCopyWithImpl<PurchasesGridItem>(this as PurchasesGridItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchasesGridItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchasesGridItem&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.bonusQuantity, _this.bonusQuantity) || other.bonusQuantity == _this.bonusQuantity)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.subTotal, _this.subTotal) || other.subTotal == _this.subTotal)&&(identical(other.batchNumber, _this.batchNumber) || other.batchNumber == _this.batchNumber)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate));
}


@override
int get hashCode {
  final _this = this as PurchasesGridItem;
  return Object.hash(runtimeType,_this.brandName,_this.unitName,_this.quantity,_this.bonusQuantity,_this.unitPrice,_this.discount,_this.subTotal,_this.batchNumber,_this.expiryDate);
}

@override
String toString() {
  final _this = this as PurchasesGridItem;
  return 'PurchasesGridItem(brandName: ${_this.brandName}, unitName: ${_this.unitName}, quantity: ${_this.quantity}, bonusQuantity: ${_this.bonusQuantity}, unitPrice: ${_this.unitPrice}, discount: ${_this.discount}, subTotal: ${_this.subTotal}, batchNumber: ${_this.batchNumber}, expiryDate: ${_this.expiryDate})';
}


}

/// @nodoc
abstract mixin class $PurchasesGridItemCopyWith<$Res>  {
  factory $PurchasesGridItemCopyWith(PurchasesGridItem value, $Res Function(PurchasesGridItem) _then) = _$PurchasesGridItemCopyWithImpl;
@useResult
$Res call({
 String brandName, String unitName, double quantity, double bonusQuantity, double unitPrice, double discount, double subTotal, String batchNumber, DateTime? expiryDate
});




}
/// @nodoc
class _$PurchasesGridItemCopyWithImpl<$Res>
    implements $PurchasesGridItemCopyWith<$Res> {
  _$PurchasesGridItemCopyWithImpl(this._self, this._then);

  final PurchasesGridItem _self;
  final $Res Function(PurchasesGridItem) _then;

/// Create a copy of PurchasesGridItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brandName = null,Object? unitName = null,Object? quantity = null,Object? bonusQuantity = null,Object? unitPrice = null,Object? discount = null,Object? subTotal = null,Object? batchNumber = null,Object? expiryDate = freezed,}) {
  return _then(PurchasesGridItem(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,bonusQuantity: null == bonusQuantity ? _self.bonusQuantity : bonusQuantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,batchNumber: null == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchasesGridItem].
extension PurchasesGridItemPatterns on PurchasesGridItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchasesGridItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchasesGridItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchasesGridItem value)  $default,){
final _that = this;
switch (_that) {
case _PurchasesGridItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchasesGridItem value)?  $default,){
final _that = this;
switch (_that) {
case _PurchasesGridItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brandName,  String unitName,  double quantity,  double bonusQuantity,  double unitPrice,  double discount,  double subTotal,  String batchNumber,  DateTime? expiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchasesGridItem() when $default != null:
return $default(_that.brandName,_that.unitName,_that.quantity,_that.bonusQuantity,_that.unitPrice,_that.discount,_that.subTotal,_that.batchNumber,_that.expiryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brandName,  String unitName,  double quantity,  double bonusQuantity,  double unitPrice,  double discount,  double subTotal,  String batchNumber,  DateTime? expiryDate)  $default,) {final _that = this;
switch (_that) {
case _PurchasesGridItem():
return $default(_that.brandName,_that.unitName,_that.quantity,_that.bonusQuantity,_that.unitPrice,_that.discount,_that.subTotal,_that.batchNumber,_that.expiryDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brandName,  String unitName,  double quantity,  double bonusQuantity,  double unitPrice,  double discount,  double subTotal,  String batchNumber,  DateTime? expiryDate)?  $default,) {final _that = this;
switch (_that) {
case _PurchasesGridItem() when $default != null:
return $default(_that.brandName,_that.unitName,_that.quantity,_that.bonusQuantity,_that.unitPrice,_that.discount,_that.subTotal,_that.batchNumber,_that.expiryDate);case _:
  return null;

}
}

}

/// @nodoc


class _PurchasesGridItem implements PurchasesGridItem {
  const _PurchasesGridItem({this.brandName = '', this.unitName = '', this.quantity = 0, this.bonusQuantity = 0, this.unitPrice = 0, this.discount = 0, this.subTotal = 0, this.batchNumber = '', this.expiryDate});
  

@override@JsonKey() final  String brandName;
@override@JsonKey() final  String unitName;
@override@JsonKey() final  double quantity;
/// كمية البونص — بلا ثمن وبكلفة صفر، فبيعها ربح صافٍ كامل.
@override@JsonKey() final  double bonusQuantity;
@override@JsonKey() final  double unitPrice;
@override@JsonKey() final  double discount;
@override@JsonKey() final  double subTotal;
@override@JsonKey() final  String batchNumber;
@override final  DateTime? expiryDate;

/// Create a copy of PurchasesGridItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchasesGridItemCopyWith<_PurchasesGridItem> get copyWith => __$PurchasesGridItemCopyWithImpl<_PurchasesGridItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchasesGridItem&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.bonusQuantity, bonusQuantity) || other.bonusQuantity == bonusQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,brandName,unitName,quantity,bonusQuantity,unitPrice,discount,subTotal,batchNumber,expiryDate);
}

@override
String toString() {
    return 'PurchasesGridItem(brandName: $brandName, unitName: $unitName, quantity: $quantity, bonusQuantity: $bonusQuantity, unitPrice: $unitPrice, discount: $discount, subTotal: $subTotal, batchNumber: $batchNumber, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class _$PurchasesGridItemCopyWith<$Res> implements $PurchasesGridItemCopyWith<$Res> {
  factory _$PurchasesGridItemCopyWith(_PurchasesGridItem value, $Res Function(_PurchasesGridItem) _then) = __$PurchasesGridItemCopyWithImpl;
@override @useResult
$Res call({
 String brandName, String unitName, double quantity, double bonusQuantity, double unitPrice, double discount, double subTotal, String batchNumber, DateTime? expiryDate
});




}
/// @nodoc
class __$PurchasesGridItemCopyWithImpl<$Res>
    implements _$PurchasesGridItemCopyWith<$Res> {
  __$PurchasesGridItemCopyWithImpl(this._self, this._then);

  final _PurchasesGridItem _self;
  final $Res Function(_PurchasesGridItem) _then;

/// Create a copy of PurchasesGridItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brandName = null,Object? unitName = null,Object? quantity = null,Object? bonusQuantity = null,Object? unitPrice = null,Object? discount = null,Object? subTotal = null,Object? batchNumber = null,Object? expiryDate = freezed,}) {
  return _then(_PurchasesGridItem(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,bonusQuantity: null == bonusQuantity ? _self.bonusQuantity : bonusQuantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,batchNumber: null == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
