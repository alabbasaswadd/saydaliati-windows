// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchases_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchasesSummary {

 double get totalCost; int get invoicesCount; List<PurchaseMedicineBucket> get topMedicines; List<PurchaseInvoice> get invoices;
/// Create a copy of PurchasesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchasesSummaryCopyWith<PurchasesSummary> get copyWith => _$PurchasesSummaryCopyWithImpl<PurchasesSummary>(this as PurchasesSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchasesSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchasesSummary&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.invoicesCount, _this.invoicesCount) || other.invoicesCount == _this.invoicesCount)&&const DeepCollectionEquality().equals(other.topMedicines, _this.topMedicines)&&const DeepCollectionEquality().equals(other.invoices, _this.invoices));
}


@override
int get hashCode {
  final _this = this as PurchasesSummary;
  return Object.hash(runtimeType,_this.totalCost,_this.invoicesCount,const DeepCollectionEquality().hash(_this.topMedicines),const DeepCollectionEquality().hash(_this.invoices));
}

@override
String toString() {
  final _this = this as PurchasesSummary;
  return 'PurchasesSummary(totalCost: ${_this.totalCost}, invoicesCount: ${_this.invoicesCount}, topMedicines: ${_this.topMedicines}, invoices: ${_this.invoices})';
}


}

/// @nodoc
abstract mixin class $PurchasesSummaryCopyWith<$Res>  {
  factory $PurchasesSummaryCopyWith(PurchasesSummary value, $Res Function(PurchasesSummary) _then) = _$PurchasesSummaryCopyWithImpl;
@useResult
$Res call({
 double totalCost, int invoicesCount, List<PurchaseMedicineBucket> topMedicines, List<PurchaseInvoice> invoices
});




}
/// @nodoc
class _$PurchasesSummaryCopyWithImpl<$Res>
    implements $PurchasesSummaryCopyWith<$Res> {
  _$PurchasesSummaryCopyWithImpl(this._self, this._then);

  final PurchasesSummary _self;
  final $Res Function(PurchasesSummary) _then;

/// Create a copy of PurchasesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCost = null,Object? invoicesCount = null,Object? topMedicines = null,Object? invoices = null,}) {
  return _then(PurchasesSummary(
totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,topMedicines: null == topMedicines ? _self.topMedicines : topMedicines // ignore: cast_nullable_to_non_nullable
as List<PurchaseMedicineBucket>,invoices: null == invoices ? _self.invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<PurchaseInvoice>,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchasesSummary].
extension PurchasesSummaryPatterns on PurchasesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchasesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchasesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchasesSummary value)  $default,){
final _that = this;
switch (_that) {
case _PurchasesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchasesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PurchasesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalCost,  int invoicesCount,  List<PurchaseMedicineBucket> topMedicines,  List<PurchaseInvoice> invoices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchasesSummary() when $default != null:
return $default(_that.totalCost,_that.invoicesCount,_that.topMedicines,_that.invoices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalCost,  int invoicesCount,  List<PurchaseMedicineBucket> topMedicines,  List<PurchaseInvoice> invoices)  $default,) {final _that = this;
switch (_that) {
case _PurchasesSummary():
return $default(_that.totalCost,_that.invoicesCount,_that.topMedicines,_that.invoices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalCost,  int invoicesCount,  List<PurchaseMedicineBucket> topMedicines,  List<PurchaseInvoice> invoices)?  $default,) {final _that = this;
switch (_that) {
case _PurchasesSummary() when $default != null:
return $default(_that.totalCost,_that.invoicesCount,_that.topMedicines,_that.invoices);case _:
  return null;

}
}

}

/// @nodoc


class _PurchasesSummary implements PurchasesSummary {
  const _PurchasesSummary({required this.totalCost, required this.invoicesCount,  List<PurchaseMedicineBucket> topMedicines = const <PurchaseMedicineBucket>[],  List<PurchaseInvoice> invoices = const <PurchaseInvoice>[]}): _topMedicines = topMedicines,_invoices = invoices;
  

@override final  double totalCost;
@override final  int invoicesCount;
 final  List<PurchaseMedicineBucket> _topMedicines;
@override@JsonKey() List<PurchaseMedicineBucket> get topMedicines {
  if (_topMedicines is EqualUnmodifiableListView) return _topMedicines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topMedicines);
}

 final  List<PurchaseInvoice> _invoices;
@override@JsonKey() List<PurchaseInvoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}


/// Create a copy of PurchasesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchasesSummaryCopyWith<_PurchasesSummary> get copyWith => __$PurchasesSummaryCopyWithImpl<_PurchasesSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchasesSummary&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.invoicesCount, invoicesCount) || other.invoicesCount == invoicesCount)&&const DeepCollectionEquality().equals(other.topMedicines, _topMedicines)&&const DeepCollectionEquality().equals(other.invoices, _invoices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalCost,invoicesCount,const DeepCollectionEquality().hash(_topMedicines),const DeepCollectionEquality().hash(_invoices));
}

@override
String toString() {
    return 'PurchasesSummary(totalCost: $totalCost, invoicesCount: $invoicesCount, topMedicines: $topMedicines, invoices: $invoices)';
}


}

/// @nodoc
abstract mixin class _$PurchasesSummaryCopyWith<$Res> implements $PurchasesSummaryCopyWith<$Res> {
  factory _$PurchasesSummaryCopyWith(_PurchasesSummary value, $Res Function(_PurchasesSummary) _then) = __$PurchasesSummaryCopyWithImpl;
@override @useResult
$Res call({
 double totalCost, int invoicesCount, List<PurchaseMedicineBucket> topMedicines, List<PurchaseInvoice> invoices
});




}
/// @nodoc
class __$PurchasesSummaryCopyWithImpl<$Res>
    implements _$PurchasesSummaryCopyWith<$Res> {
  __$PurchasesSummaryCopyWithImpl(this._self, this._then);

  final _PurchasesSummary _self;
  final $Res Function(_PurchasesSummary) _then;

/// Create a copy of PurchasesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCost = null,Object? invoicesCount = null,Object? topMedicines = null,Object? invoices = null,}) {
  return _then(_PurchasesSummary(
totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,topMedicines: null == topMedicines ? _self._topMedicines : topMedicines // ignore: cast_nullable_to_non_nullable
as List<PurchaseMedicineBucket>,invoices: null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<PurchaseInvoice>,
  ));
}


}

/// @nodoc
mixin _$PurchaseInvoice {

 int get invoiceNumber; DateTime get purchaseDate; double get totalAmount; List<PurchaseInvoiceLine> get items;
/// Create a copy of PurchaseInvoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseInvoiceCopyWith<PurchaseInvoice> get copyWith => _$PurchaseInvoiceCopyWithImpl<PurchaseInvoice>(this as PurchaseInvoice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchaseInvoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseInvoice&&(identical(other.invoiceNumber, _this.invoiceNumber) || other.invoiceNumber == _this.invoiceNumber)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as PurchaseInvoice;
  return Object.hash(runtimeType,_this.invoiceNumber,_this.purchaseDate,_this.totalAmount,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as PurchaseInvoice;
  return 'PurchaseInvoice(invoiceNumber: ${_this.invoiceNumber}, purchaseDate: ${_this.purchaseDate}, totalAmount: ${_this.totalAmount}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $PurchaseInvoiceCopyWith<$Res>  {
  factory $PurchaseInvoiceCopyWith(PurchaseInvoice value, $Res Function(PurchaseInvoice) _then) = _$PurchaseInvoiceCopyWithImpl;
@useResult
$Res call({
 int invoiceNumber, DateTime purchaseDate, double totalAmount, List<PurchaseInvoiceLine> items
});




}
/// @nodoc
class _$PurchaseInvoiceCopyWithImpl<$Res>
    implements $PurchaseInvoiceCopyWith<$Res> {
  _$PurchaseInvoiceCopyWithImpl(this._self, this._then);

  final PurchaseInvoice _self;
  final $Res Function(PurchaseInvoice) _then;

/// Create a copy of PurchaseInvoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoiceNumber = null,Object? purchaseDate = null,Object? totalAmount = null,Object? items = null,}) {
  return _then(PurchaseInvoice(
invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseInvoiceLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseInvoice].
extension PurchaseInvoicePatterns on PurchaseInvoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseInvoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseInvoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseInvoice value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseInvoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseInvoice value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseInvoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int invoiceNumber,  DateTime purchaseDate,  double totalAmount,  List<PurchaseInvoiceLine> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseInvoice() when $default != null:
return $default(_that.invoiceNumber,_that.purchaseDate,_that.totalAmount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int invoiceNumber,  DateTime purchaseDate,  double totalAmount,  List<PurchaseInvoiceLine> items)  $default,) {final _that = this;
switch (_that) {
case _PurchaseInvoice():
return $default(_that.invoiceNumber,_that.purchaseDate,_that.totalAmount,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int invoiceNumber,  DateTime purchaseDate,  double totalAmount,  List<PurchaseInvoiceLine> items)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseInvoice() when $default != null:
return $default(_that.invoiceNumber,_that.purchaseDate,_that.totalAmount,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseInvoice implements PurchaseInvoice {
  const _PurchaseInvoice({required this.invoiceNumber, required this.purchaseDate, required this.totalAmount,  List<PurchaseInvoiceLine> items = const <PurchaseInvoiceLine>[]}): _items = items;
  

@override final  int invoiceNumber;
@override final  DateTime purchaseDate;
@override final  double totalAmount;
 final  List<PurchaseInvoiceLine> _items;
@override@JsonKey() List<PurchaseInvoiceLine> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PurchaseInvoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseInvoiceCopyWith<_PurchaseInvoice> get copyWith => __$PurchaseInvoiceCopyWithImpl<_PurchaseInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseInvoice&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,invoiceNumber,purchaseDate,totalAmount,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'PurchaseInvoice(invoiceNumber: $invoiceNumber, purchaseDate: $purchaseDate, totalAmount: $totalAmount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PurchaseInvoiceCopyWith<$Res> implements $PurchaseInvoiceCopyWith<$Res> {
  factory _$PurchaseInvoiceCopyWith(_PurchaseInvoice value, $Res Function(_PurchaseInvoice) _then) = __$PurchaseInvoiceCopyWithImpl;
@override @useResult
$Res call({
 int invoiceNumber, DateTime purchaseDate, double totalAmount, List<PurchaseInvoiceLine> items
});




}
/// @nodoc
class __$PurchaseInvoiceCopyWithImpl<$Res>
    implements _$PurchaseInvoiceCopyWith<$Res> {
  __$PurchaseInvoiceCopyWithImpl(this._self, this._then);

  final _PurchaseInvoice _self;
  final $Res Function(_PurchaseInvoice) _then;

/// Create a copy of PurchaseInvoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoiceNumber = null,Object? purchaseDate = null,Object? totalAmount = null,Object? items = null,}) {
  return _then(_PurchaseInvoice(
invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as int,purchaseDate: null == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseInvoiceLine>,
  ));
}


}

/// @nodoc
mixin _$PurchaseInvoiceLine {

 String get brandName; double get quantity; double get unitPrice; double get subTotal;
/// Create a copy of PurchaseInvoiceLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseInvoiceLineCopyWith<PurchaseInvoiceLine> get copyWith => _$PurchaseInvoiceLineCopyWithImpl<PurchaseInvoiceLine>(this as PurchaseInvoiceLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchaseInvoiceLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseInvoiceLine&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.subTotal, _this.subTotal) || other.subTotal == _this.subTotal));
}


@override
int get hashCode {
  final _this = this as PurchaseInvoiceLine;
  return Object.hash(runtimeType,_this.brandName,_this.quantity,_this.unitPrice,_this.subTotal);
}

@override
String toString() {
  final _this = this as PurchaseInvoiceLine;
  return 'PurchaseInvoiceLine(brandName: ${_this.brandName}, quantity: ${_this.quantity}, unitPrice: ${_this.unitPrice}, subTotal: ${_this.subTotal})';
}


}

/// @nodoc
abstract mixin class $PurchaseInvoiceLineCopyWith<$Res>  {
  factory $PurchaseInvoiceLineCopyWith(PurchaseInvoiceLine value, $Res Function(PurchaseInvoiceLine) _then) = _$PurchaseInvoiceLineCopyWithImpl;
@useResult
$Res call({
 String brandName, double quantity, double unitPrice, double subTotal
});




}
/// @nodoc
class _$PurchaseInvoiceLineCopyWithImpl<$Res>
    implements $PurchaseInvoiceLineCopyWith<$Res> {
  _$PurchaseInvoiceLineCopyWithImpl(this._self, this._then);

  final PurchaseInvoiceLine _self;
  final $Res Function(PurchaseInvoiceLine) _then;

/// Create a copy of PurchaseInvoiceLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brandName = null,Object? quantity = null,Object? unitPrice = null,Object? subTotal = null,}) {
  return _then(PurchaseInvoiceLine(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseInvoiceLine].
extension PurchaseInvoiceLinePatterns on PurchaseInvoiceLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseInvoiceLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseInvoiceLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseInvoiceLine value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseInvoiceLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseInvoiceLine value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseInvoiceLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brandName,  double quantity,  double unitPrice,  double subTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseInvoiceLine() when $default != null:
return $default(_that.brandName,_that.quantity,_that.unitPrice,_that.subTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brandName,  double quantity,  double unitPrice,  double subTotal)  $default,) {final _that = this;
switch (_that) {
case _PurchaseInvoiceLine():
return $default(_that.brandName,_that.quantity,_that.unitPrice,_that.subTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brandName,  double quantity,  double unitPrice,  double subTotal)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseInvoiceLine() when $default != null:
return $default(_that.brandName,_that.quantity,_that.unitPrice,_that.subTotal);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseInvoiceLine implements PurchaseInvoiceLine {
  const _PurchaseInvoiceLine({required this.brandName, required this.quantity, required this.unitPrice, required this.subTotal});
  

@override final  String brandName;
@override final  double quantity;
@override final  double unitPrice;
@override final  double subTotal;

/// Create a copy of PurchaseInvoiceLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseInvoiceLineCopyWith<_PurchaseInvoiceLine> get copyWith => __$PurchaseInvoiceLineCopyWithImpl<_PurchaseInvoiceLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseInvoiceLine&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,brandName,quantity,unitPrice,subTotal);
}

@override
String toString() {
    return 'PurchaseInvoiceLine(brandName: $brandName, quantity: $quantity, unitPrice: $unitPrice, subTotal: $subTotal)';
}


}

/// @nodoc
abstract mixin class _$PurchaseInvoiceLineCopyWith<$Res> implements $PurchaseInvoiceLineCopyWith<$Res> {
  factory _$PurchaseInvoiceLineCopyWith(_PurchaseInvoiceLine value, $Res Function(_PurchaseInvoiceLine) _then) = __$PurchaseInvoiceLineCopyWithImpl;
@override @useResult
$Res call({
 String brandName, double quantity, double unitPrice, double subTotal
});




}
/// @nodoc
class __$PurchaseInvoiceLineCopyWithImpl<$Res>
    implements _$PurchaseInvoiceLineCopyWith<$Res> {
  __$PurchaseInvoiceLineCopyWithImpl(this._self, this._then);

  final _PurchaseInvoiceLine _self;
  final $Res Function(_PurchaseInvoiceLine) _then;

/// Create a copy of PurchaseInvoiceLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brandName = null,Object? quantity = null,Object? unitPrice = null,Object? subTotal = null,}) {
  return _then(_PurchaseInvoiceLine(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$PurchaseMedicineBucket {

 String get medicineId; String get brandName; double get quantity; double get cost;
/// Create a copy of PurchaseMedicineBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseMedicineBucketCopyWith<PurchaseMedicineBucket> get copyWith => _$PurchaseMedicineBucketCopyWithImpl<PurchaseMedicineBucket>(this as PurchaseMedicineBucket, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PurchaseMedicineBucket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseMedicineBucket&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.cost, _this.cost) || other.cost == _this.cost));
}


@override
int get hashCode {
  final _this = this as PurchaseMedicineBucket;
  return Object.hash(runtimeType,_this.medicineId,_this.brandName,_this.quantity,_this.cost);
}

@override
String toString() {
  final _this = this as PurchaseMedicineBucket;
  return 'PurchaseMedicineBucket(medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, quantity: ${_this.quantity}, cost: ${_this.cost})';
}


}

/// @nodoc
abstract mixin class $PurchaseMedicineBucketCopyWith<$Res>  {
  factory $PurchaseMedicineBucketCopyWith(PurchaseMedicineBucket value, $Res Function(PurchaseMedicineBucket) _then) = _$PurchaseMedicineBucketCopyWithImpl;
@useResult
$Res call({
 String medicineId, String brandName, double quantity, double cost
});




}
/// @nodoc
class _$PurchaseMedicineBucketCopyWithImpl<$Res>
    implements $PurchaseMedicineBucketCopyWith<$Res> {
  _$PurchaseMedicineBucketCopyWithImpl(this._self, this._then);

  final PurchaseMedicineBucket _self;
  final $Res Function(PurchaseMedicineBucket) _then;

/// Create a copy of PurchaseMedicineBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? brandName = null,Object? quantity = null,Object? cost = null,}) {
  return _then(PurchaseMedicineBucket(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseMedicineBucket].
extension PurchaseMedicineBucketPatterns on PurchaseMedicineBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseMedicineBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseMedicineBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseMedicineBucket value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseMedicineBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseMedicineBucket value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseMedicineBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantity,  double cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseMedicineBucket() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantity,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantity,  double cost)  $default,) {final _that = this;
switch (_that) {
case _PurchaseMedicineBucket():
return $default(_that.medicineId,_that.brandName,_that.quantity,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String brandName,  double quantity,  double cost)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseMedicineBucket() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantity,_that.cost);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseMedicineBucket implements PurchaseMedicineBucket {
  const _PurchaseMedicineBucket({required this.medicineId, required this.brandName, required this.quantity, required this.cost});
  

@override final  String medicineId;
@override final  String brandName;
@override final  double quantity;
@override final  double cost;

/// Create a copy of PurchaseMedicineBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseMedicineBucketCopyWith<_PurchaseMedicineBucket> get copyWith => __$PurchaseMedicineBucketCopyWithImpl<_PurchaseMedicineBucket>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseMedicineBucket&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.cost, cost) || other.cost == cost));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,brandName,quantity,cost);
}

@override
String toString() {
    return 'PurchaseMedicineBucket(medicineId: $medicineId, brandName: $brandName, quantity: $quantity, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$PurchaseMedicineBucketCopyWith<$Res> implements $PurchaseMedicineBucketCopyWith<$Res> {
  factory _$PurchaseMedicineBucketCopyWith(_PurchaseMedicineBucket value, $Res Function(_PurchaseMedicineBucket) _then) = __$PurchaseMedicineBucketCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String brandName, double quantity, double cost
});




}
/// @nodoc
class __$PurchaseMedicineBucketCopyWithImpl<$Res>
    implements _$PurchaseMedicineBucketCopyWith<$Res> {
  __$PurchaseMedicineBucketCopyWithImpl(this._self, this._then);

  final _PurchaseMedicineBucket _self;
  final $Res Function(_PurchaseMedicineBucket) _then;

/// Create a copy of PurchaseMedicineBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? brandName = null,Object? quantity = null,Object? cost = null,}) {
  return _then(_PurchaseMedicineBucket(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
