// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Sale {

 String get id; DateTime get saleDate; double get totalAmount; PaymentMethod get paymentMethod; String get currencyCode; int get invoiceNumber; String get customerId; String get originalCurrencyId; double get exchangeRate; bool get isPrescription; String get paymentAccountId; List<SaleLine> get items;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Sale;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.saleDate, _this.saleDate) || other.saleDate == _this.saleDate)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.invoiceNumber, _this.invoiceNumber) || other.invoiceNumber == _this.invoiceNumber)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.originalCurrencyId, _this.originalCurrencyId) || other.originalCurrencyId == _this.originalCurrencyId)&&(identical(other.exchangeRate, _this.exchangeRate) || other.exchangeRate == _this.exchangeRate)&&(identical(other.isPrescription, _this.isPrescription) || other.isPrescription == _this.isPrescription)&&(identical(other.paymentAccountId, _this.paymentAccountId) || other.paymentAccountId == _this.paymentAccountId)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Sale;
  return Object.hash(runtimeType,_this.id,_this.saleDate,_this.totalAmount,_this.paymentMethod,_this.currencyCode,_this.invoiceNumber,_this.customerId,_this.originalCurrencyId,_this.exchangeRate,_this.isPrescription,_this.paymentAccountId,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Sale;
  return 'Sale(id: ${_this.id}, saleDate: ${_this.saleDate}, totalAmount: ${_this.totalAmount}, paymentMethod: ${_this.paymentMethod}, currencyCode: ${_this.currencyCode}, invoiceNumber: ${_this.invoiceNumber}, customerId: ${_this.customerId}, originalCurrencyId: ${_this.originalCurrencyId}, exchangeRate: ${_this.exchangeRate}, isPrescription: ${_this.isPrescription}, paymentAccountId: ${_this.paymentAccountId}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
 String id, DateTime saleDate, double totalAmount, PaymentMethod paymentMethod, String currencyCode, int invoiceNumber, String customerId, String originalCurrencyId, double exchangeRate, bool isPrescription, String paymentAccountId, List<SaleLine> items
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleDate = null,Object? totalAmount = null,Object? paymentMethod = null,Object? currencyCode = null,Object? invoiceNumber = null,Object? customerId = null,Object? originalCurrencyId = null,Object? exchangeRate = null,Object? isPrescription = null,Object? paymentAccountId = null,Object? items = null,}) {
  return _then(Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleDate: null == saleDate ? _self.saleDate : saleDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,originalCurrencyId: null == originalCurrencyId ? _self.originalCurrencyId : originalCurrencyId // ignore: cast_nullable_to_non_nullable
as String,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,isPrescription: null == isPrescription ? _self.isPrescription : isPrescription // ignore: cast_nullable_to_non_nullable
as bool,paymentAccountId: null == paymentAccountId ? _self.paymentAccountId : paymentAccountId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [Sale].
extension SalePatterns on Sale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sale value)  $default,){
final _that = this;
switch (_that) {
case _Sale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sale value)?  $default,){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime saleDate,  double totalAmount,  PaymentMethod paymentMethod,  String currencyCode,  int invoiceNumber,  String customerId,  String originalCurrencyId,  double exchangeRate,  bool isPrescription,  String paymentAccountId,  List<SaleLine> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.saleDate,_that.totalAmount,_that.paymentMethod,_that.currencyCode,_that.invoiceNumber,_that.customerId,_that.originalCurrencyId,_that.exchangeRate,_that.isPrescription,_that.paymentAccountId,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime saleDate,  double totalAmount,  PaymentMethod paymentMethod,  String currencyCode,  int invoiceNumber,  String customerId,  String originalCurrencyId,  double exchangeRate,  bool isPrescription,  String paymentAccountId,  List<SaleLine> items)  $default,) {final _that = this;
switch (_that) {
case _Sale():
return $default(_that.id,_that.saleDate,_that.totalAmount,_that.paymentMethod,_that.currencyCode,_that.invoiceNumber,_that.customerId,_that.originalCurrencyId,_that.exchangeRate,_that.isPrescription,_that.paymentAccountId,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime saleDate,  double totalAmount,  PaymentMethod paymentMethod,  String currencyCode,  int invoiceNumber,  String customerId,  String originalCurrencyId,  double exchangeRate,  bool isPrescription,  String paymentAccountId,  List<SaleLine> items)?  $default,) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.saleDate,_that.totalAmount,_that.paymentMethod,_that.currencyCode,_that.invoiceNumber,_that.customerId,_that.originalCurrencyId,_that.exchangeRate,_that.isPrescription,_that.paymentAccountId,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Sale implements Sale {
  const _Sale({required this.id, required this.saleDate, required this.totalAmount, required this.paymentMethod, required this.currencyCode, this.invoiceNumber = 0, this.customerId = '', this.originalCurrencyId = '', this.exchangeRate = 1, this.isPrescription = false, this.paymentAccountId = '',  List<SaleLine> items = const <SaleLine>[]}): _items = items;
  

@override final  String id;
@override final  DateTime saleDate;
@override final  double totalAmount;
@override final  PaymentMethod paymentMethod;
@override final  String currencyCode;
@override@JsonKey() final  int invoiceNumber;
@override@JsonKey() final  String customerId;
@override@JsonKey() final  String originalCurrencyId;
@override@JsonKey() final  double exchangeRate;
@override@JsonKey() final  bool isPrescription;
@override@JsonKey() final  String paymentAccountId;
 final  List<SaleLine> _items;
@override@JsonKey() List<SaleLine> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.saleDate, saleDate) || other.saleDate == saleDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.originalCurrencyId, originalCurrencyId) || other.originalCurrencyId == originalCurrencyId)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.isPrescription, isPrescription) || other.isPrescription == isPrescription)&&(identical(other.paymentAccountId, paymentAccountId) || other.paymentAccountId == paymentAccountId)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,saleDate,totalAmount,paymentMethod,currencyCode,invoiceNumber,customerId,originalCurrencyId,exchangeRate,isPrescription,paymentAccountId,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Sale(id: $id, saleDate: $saleDate, totalAmount: $totalAmount, paymentMethod: $paymentMethod, currencyCode: $currencyCode, invoiceNumber: $invoiceNumber, customerId: $customerId, originalCurrencyId: $originalCurrencyId, exchangeRate: $exchangeRate, isPrescription: $isPrescription, paymentAccountId: $paymentAccountId, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime saleDate, double totalAmount, PaymentMethod paymentMethod, String currencyCode, int invoiceNumber, String customerId, String originalCurrencyId, double exchangeRate, bool isPrescription, String paymentAccountId, List<SaleLine> items
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleDate = null,Object? totalAmount = null,Object? paymentMethod = null,Object? currencyCode = null,Object? invoiceNumber = null,Object? customerId = null,Object? originalCurrencyId = null,Object? exchangeRate = null,Object? isPrescription = null,Object? paymentAccountId = null,Object? items = null,}) {
  return _then(_Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleDate: null == saleDate ? _self.saleDate : saleDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,originalCurrencyId: null == originalCurrencyId ? _self.originalCurrencyId : originalCurrencyId // ignore: cast_nullable_to_non_nullable
as String,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,isPrescription: null == isPrescription ? _self.isPrescription : isPrescription // ignore: cast_nullable_to_non_nullable
as bool,paymentAccountId: null == paymentAccountId ? _self.paymentAccountId : paymentAccountId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleLine>,
  ));
}


}

/// @nodoc
mixin _$SaleLine {

 String get medicineName; String get unitName; double get individual; double get quantity; double get subTotal; double get unitCost; String get medicineId; String get unitId;
/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleLineCopyWith<SaleLine> get copyWith => _$SaleLineCopyWithImpl<SaleLine>(this as SaleLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SaleLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleLine&&(identical(other.medicineName, _this.medicineName) || other.medicineName == _this.medicineName)&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.individual, _this.individual) || other.individual == _this.individual)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.subTotal, _this.subTotal) || other.subTotal == _this.subTotal)&&(identical(other.unitCost, _this.unitCost) || other.unitCost == _this.unitCost)&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId));
}


@override
int get hashCode {
  final _this = this as SaleLine;
  return Object.hash(runtimeType,_this.medicineName,_this.unitName,_this.individual,_this.quantity,_this.subTotal,_this.unitCost,_this.medicineId,_this.unitId);
}

@override
String toString() {
  final _this = this as SaleLine;
  return 'SaleLine(medicineName: ${_this.medicineName}, unitName: ${_this.unitName}, individual: ${_this.individual}, quantity: ${_this.quantity}, subTotal: ${_this.subTotal}, unitCost: ${_this.unitCost}, medicineId: ${_this.medicineId}, unitId: ${_this.unitId})';
}


}

/// @nodoc
abstract mixin class $SaleLineCopyWith<$Res>  {
  factory $SaleLineCopyWith(SaleLine value, $Res Function(SaleLine) _then) = _$SaleLineCopyWithImpl;
@useResult
$Res call({
 String medicineName, String unitName, double individual, double quantity, double subTotal, double unitCost, String medicineId, String unitId
});




}
/// @nodoc
class _$SaleLineCopyWithImpl<$Res>
    implements $SaleLineCopyWith<$Res> {
  _$SaleLineCopyWithImpl(this._self, this._then);

  final SaleLine _self;
  final $Res Function(SaleLine) _then;

/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineName = null,Object? unitName = null,Object? individual = null,Object? quantity = null,Object? subTotal = null,Object? unitCost = null,Object? medicineId = null,Object? unitId = null,}) {
  return _then(SaleLine(
medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,individual: null == individual ? _self.individual : individual // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleLine].
extension SaleLinePatterns on SaleLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleLine value)  $default,){
final _that = this;
switch (_that) {
case _SaleLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleLine value)?  $default,){
final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineName,  String unitName,  double individual,  double quantity,  double subTotal,  double unitCost,  String medicineId,  String unitId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
return $default(_that.medicineName,_that.unitName,_that.individual,_that.quantity,_that.subTotal,_that.unitCost,_that.medicineId,_that.unitId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineName,  String unitName,  double individual,  double quantity,  double subTotal,  double unitCost,  String medicineId,  String unitId)  $default,) {final _that = this;
switch (_that) {
case _SaleLine():
return $default(_that.medicineName,_that.unitName,_that.individual,_that.quantity,_that.subTotal,_that.unitCost,_that.medicineId,_that.unitId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineName,  String unitName,  double individual,  double quantity,  double subTotal,  double unitCost,  String medicineId,  String unitId)?  $default,) {final _that = this;
switch (_that) {
case _SaleLine() when $default != null:
return $default(_that.medicineName,_that.unitName,_that.individual,_that.quantity,_that.subTotal,_that.unitCost,_that.medicineId,_that.unitId);case _:
  return null;

}
}

}

/// @nodoc


class _SaleLine implements SaleLine {
  const _SaleLine({required this.medicineName, required this.unitName, required this.individual, required this.quantity, required this.subTotal, this.unitCost = 0, this.medicineId = '', this.unitId = ''});
  

@override final  String medicineName;
@override final  String unitName;
@override final  double individual;
@override final  double quantity;
@override final  double subTotal;
@override@JsonKey() final  double unitCost;
@override@JsonKey() final  String medicineId;
@override@JsonKey() final  String unitId;

/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleLineCopyWith<_SaleLine> get copyWith => __$SaleLineCopyWithImpl<_SaleLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleLine&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.individual, individual) || other.individual == individual)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.unitId, unitId) || other.unitId == unitId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineName,unitName,individual,quantity,subTotal,unitCost,medicineId,unitId);
}

@override
String toString() {
    return 'SaleLine(medicineName: $medicineName, unitName: $unitName, individual: $individual, quantity: $quantity, subTotal: $subTotal, unitCost: $unitCost, medicineId: $medicineId, unitId: $unitId)';
}


}

/// @nodoc
abstract mixin class _$SaleLineCopyWith<$Res> implements $SaleLineCopyWith<$Res> {
  factory _$SaleLineCopyWith(_SaleLine value, $Res Function(_SaleLine) _then) = __$SaleLineCopyWithImpl;
@override @useResult
$Res call({
 String medicineName, String unitName, double individual, double quantity, double subTotal, double unitCost, String medicineId, String unitId
});




}
/// @nodoc
class __$SaleLineCopyWithImpl<$Res>
    implements _$SaleLineCopyWith<$Res> {
  __$SaleLineCopyWithImpl(this._self, this._then);

  final _SaleLine _self;
  final $Res Function(_SaleLine) _then;

/// Create a copy of SaleLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineName = null,Object? unitName = null,Object? individual = null,Object? quantity = null,Object? subTotal = null,Object? unitCost = null,Object? medicineId = null,Object? unitId = null,}) {
  return _then(_SaleLine(
medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,individual: null == individual ? _self.individual : individual // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
