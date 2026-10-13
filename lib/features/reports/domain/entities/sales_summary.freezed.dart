// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesSummary {

 double get totalRevenue; int get invoicesCount; double get costOfGoods; double get grossProfit; List<PaymentMethodBucket> get byPaymentMethod; List<TopMedicineSales> get topMedicines;
/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesSummaryCopyWith<SalesSummary> get copyWith => _$SalesSummaryCopyWithImpl<SalesSummary>(this as SalesSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesSummary&&(identical(other.totalRevenue, _this.totalRevenue) || other.totalRevenue == _this.totalRevenue)&&(identical(other.invoicesCount, _this.invoicesCount) || other.invoicesCount == _this.invoicesCount)&&(identical(other.costOfGoods, _this.costOfGoods) || other.costOfGoods == _this.costOfGoods)&&(identical(other.grossProfit, _this.grossProfit) || other.grossProfit == _this.grossProfit)&&const DeepCollectionEquality().equals(other.byPaymentMethod, _this.byPaymentMethod)&&const DeepCollectionEquality().equals(other.topMedicines, _this.topMedicines));
}


@override
int get hashCode {
  final _this = this as SalesSummary;
  return Object.hash(runtimeType,_this.totalRevenue,_this.invoicesCount,_this.costOfGoods,_this.grossProfit,const DeepCollectionEquality().hash(_this.byPaymentMethod),const DeepCollectionEquality().hash(_this.topMedicines));
}

@override
String toString() {
  final _this = this as SalesSummary;
  return 'SalesSummary(totalRevenue: ${_this.totalRevenue}, invoicesCount: ${_this.invoicesCount}, costOfGoods: ${_this.costOfGoods}, grossProfit: ${_this.grossProfit}, byPaymentMethod: ${_this.byPaymentMethod}, topMedicines: ${_this.topMedicines})';
}


}

/// @nodoc
abstract mixin class $SalesSummaryCopyWith<$Res>  {
  factory $SalesSummaryCopyWith(SalesSummary value, $Res Function(SalesSummary) _then) = _$SalesSummaryCopyWithImpl;
@useResult
$Res call({
 double totalRevenue, int invoicesCount, double costOfGoods, double grossProfit, List<PaymentMethodBucket> byPaymentMethod, List<TopMedicineSales> topMedicines
});




}
/// @nodoc
class _$SalesSummaryCopyWithImpl<$Res>
    implements $SalesSummaryCopyWith<$Res> {
  _$SalesSummaryCopyWithImpl(this._self, this._then);

  final SalesSummary _self;
  final $Res Function(SalesSummary) _then;

/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRevenue = null,Object? invoicesCount = null,Object? costOfGoods = null,Object? grossProfit = null,Object? byPaymentMethod = null,Object? topMedicines = null,}) {
  return _then(SalesSummary(
totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,costOfGoods: null == costOfGoods ? _self.costOfGoods : costOfGoods // ignore: cast_nullable_to_non_nullable
as double,grossProfit: null == grossProfit ? _self.grossProfit : grossProfit // ignore: cast_nullable_to_non_nullable
as double,byPaymentMethod: null == byPaymentMethod ? _self.byPaymentMethod : byPaymentMethod // ignore: cast_nullable_to_non_nullable
as List<PaymentMethodBucket>,topMedicines: null == topMedicines ? _self.topMedicines : topMedicines // ignore: cast_nullable_to_non_nullable
as List<TopMedicineSales>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesSummary].
extension SalesSummaryPatterns on SalesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesSummary value)  $default,){
final _that = this;
switch (_that) {
case _SalesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalRevenue,  int invoicesCount,  double costOfGoods,  double grossProfit,  List<PaymentMethodBucket> byPaymentMethod,  List<TopMedicineSales> topMedicines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
return $default(_that.totalRevenue,_that.invoicesCount,_that.costOfGoods,_that.grossProfit,_that.byPaymentMethod,_that.topMedicines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalRevenue,  int invoicesCount,  double costOfGoods,  double grossProfit,  List<PaymentMethodBucket> byPaymentMethod,  List<TopMedicineSales> topMedicines)  $default,) {final _that = this;
switch (_that) {
case _SalesSummary():
return $default(_that.totalRevenue,_that.invoicesCount,_that.costOfGoods,_that.grossProfit,_that.byPaymentMethod,_that.topMedicines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalRevenue,  int invoicesCount,  double costOfGoods,  double grossProfit,  List<PaymentMethodBucket> byPaymentMethod,  List<TopMedicineSales> topMedicines)?  $default,) {final _that = this;
switch (_that) {
case _SalesSummary() when $default != null:
return $default(_that.totalRevenue,_that.invoicesCount,_that.costOfGoods,_that.grossProfit,_that.byPaymentMethod,_that.topMedicines);case _:
  return null;

}
}

}

/// @nodoc


class _SalesSummary implements SalesSummary {
  const _SalesSummary({required this.totalRevenue, required this.invoicesCount, this.costOfGoods = 0, this.grossProfit = 0,  List<PaymentMethodBucket> byPaymentMethod = const <PaymentMethodBucket>[],  List<TopMedicineSales> topMedicines = const <TopMedicineSales>[]}): _byPaymentMethod = byPaymentMethod,_topMedicines = topMedicines;
  

@override final  double totalRevenue;
@override final  int invoicesCount;
@override@JsonKey() final  double costOfGoods;
@override@JsonKey() final  double grossProfit;
 final  List<PaymentMethodBucket> _byPaymentMethod;
@override@JsonKey() List<PaymentMethodBucket> get byPaymentMethod {
  if (_byPaymentMethod is EqualUnmodifiableListView) return _byPaymentMethod;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byPaymentMethod);
}

 final  List<TopMedicineSales> _topMedicines;
@override@JsonKey() List<TopMedicineSales> get topMedicines {
  if (_topMedicines is EqualUnmodifiableListView) return _topMedicines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topMedicines);
}


/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesSummaryCopyWith<_SalesSummary> get copyWith => __$SalesSummaryCopyWithImpl<_SalesSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesSummary&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.invoicesCount, invoicesCount) || other.invoicesCount == invoicesCount)&&(identical(other.costOfGoods, costOfGoods) || other.costOfGoods == costOfGoods)&&(identical(other.grossProfit, grossProfit) || other.grossProfit == grossProfit)&&const DeepCollectionEquality().equals(other.byPaymentMethod, _byPaymentMethod)&&const DeepCollectionEquality().equals(other.topMedicines, _topMedicines));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalRevenue,invoicesCount,costOfGoods,grossProfit,const DeepCollectionEquality().hash(_byPaymentMethod),const DeepCollectionEquality().hash(_topMedicines));
}

@override
String toString() {
    return 'SalesSummary(totalRevenue: $totalRevenue, invoicesCount: $invoicesCount, costOfGoods: $costOfGoods, grossProfit: $grossProfit, byPaymentMethod: $byPaymentMethod, topMedicines: $topMedicines)';
}


}

/// @nodoc
abstract mixin class _$SalesSummaryCopyWith<$Res> implements $SalesSummaryCopyWith<$Res> {
  factory _$SalesSummaryCopyWith(_SalesSummary value, $Res Function(_SalesSummary) _then) = __$SalesSummaryCopyWithImpl;
@override @useResult
$Res call({
 double totalRevenue, int invoicesCount, double costOfGoods, double grossProfit, List<PaymentMethodBucket> byPaymentMethod, List<TopMedicineSales> topMedicines
});




}
/// @nodoc
class __$SalesSummaryCopyWithImpl<$Res>
    implements _$SalesSummaryCopyWith<$Res> {
  __$SalesSummaryCopyWithImpl(this._self, this._then);

  final _SalesSummary _self;
  final $Res Function(_SalesSummary) _then;

/// Create a copy of SalesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRevenue = null,Object? invoicesCount = null,Object? costOfGoods = null,Object? grossProfit = null,Object? byPaymentMethod = null,Object? topMedicines = null,}) {
  return _then(_SalesSummary(
totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,invoicesCount: null == invoicesCount ? _self.invoicesCount : invoicesCount // ignore: cast_nullable_to_non_nullable
as int,costOfGoods: null == costOfGoods ? _self.costOfGoods : costOfGoods // ignore: cast_nullable_to_non_nullable
as double,grossProfit: null == grossProfit ? _self.grossProfit : grossProfit // ignore: cast_nullable_to_non_nullable
as double,byPaymentMethod: null == byPaymentMethod ? _self._byPaymentMethod : byPaymentMethod // ignore: cast_nullable_to_non_nullable
as List<PaymentMethodBucket>,topMedicines: null == topMedicines ? _self._topMedicines : topMedicines // ignore: cast_nullable_to_non_nullable
as List<TopMedicineSales>,
  ));
}


}

/// @nodoc
mixin _$PaymentMethodBucket {

 int get paymentMethod; int get count; double get total;
/// Create a copy of PaymentMethodBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodBucketCopyWith<PaymentMethodBucket> get copyWith => _$PaymentMethodBucketCopyWithImpl<PaymentMethodBucket>(this as PaymentMethodBucket, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentMethodBucket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodBucket&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as PaymentMethodBucket;
  return Object.hash(runtimeType,_this.paymentMethod,_this.count,_this.total);
}

@override
String toString() {
  final _this = this as PaymentMethodBucket;
  return 'PaymentMethodBucket(paymentMethod: ${_this.paymentMethod}, count: ${_this.count}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $PaymentMethodBucketCopyWith<$Res>  {
  factory $PaymentMethodBucketCopyWith(PaymentMethodBucket value, $Res Function(PaymentMethodBucket) _then) = _$PaymentMethodBucketCopyWithImpl;
@useResult
$Res call({
 int paymentMethod, int count, double total
});




}
/// @nodoc
class _$PaymentMethodBucketCopyWithImpl<$Res>
    implements $PaymentMethodBucketCopyWith<$Res> {
  _$PaymentMethodBucketCopyWithImpl(this._self, this._then);

  final PaymentMethodBucket _self;
  final $Res Function(PaymentMethodBucket) _then;

/// Create a copy of PaymentMethodBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentMethod = null,Object? count = null,Object? total = null,}) {
  return _then(PaymentMethodBucket(
paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodBucket].
extension PaymentMethodBucketPatterns on PaymentMethodBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodBucket value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodBucket value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int paymentMethod,  int count,  double total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodBucket() when $default != null:
return $default(_that.paymentMethod,_that.count,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int paymentMethod,  int count,  double total)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodBucket():
return $default(_that.paymentMethod,_that.count,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int paymentMethod,  int count,  double total)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodBucket() when $default != null:
return $default(_that.paymentMethod,_that.count,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentMethodBucket implements PaymentMethodBucket {
  const _PaymentMethodBucket({required this.paymentMethod, required this.count, required this.total});
  

@override final  int paymentMethod;
@override final  int count;
@override final  double total;

/// Create a copy of PaymentMethodBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodBucketCopyWith<_PaymentMethodBucket> get copyWith => __$PaymentMethodBucketCopyWithImpl<_PaymentMethodBucket>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodBucket&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,paymentMethod,count,total);
}

@override
String toString() {
    return 'PaymentMethodBucket(paymentMethod: $paymentMethod, count: $count, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodBucketCopyWith<$Res> implements $PaymentMethodBucketCopyWith<$Res> {
  factory _$PaymentMethodBucketCopyWith(_PaymentMethodBucket value, $Res Function(_PaymentMethodBucket) _then) = __$PaymentMethodBucketCopyWithImpl;
@override @useResult
$Res call({
 int paymentMethod, int count, double total
});




}
/// @nodoc
class __$PaymentMethodBucketCopyWithImpl<$Res>
    implements _$PaymentMethodBucketCopyWith<$Res> {
  __$PaymentMethodBucketCopyWithImpl(this._self, this._then);

  final _PaymentMethodBucket _self;
  final $Res Function(_PaymentMethodBucket) _then;

/// Create a copy of PaymentMethodBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentMethod = null,Object? count = null,Object? total = null,}) {
  return _then(_PaymentMethodBucket(
paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$TopMedicineSales {

 String get medicineId; String get brandName; double get quantitySold; double get revenue;
/// Create a copy of TopMedicineSales
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopMedicineSalesCopyWith<TopMedicineSales> get copyWith => _$TopMedicineSalesCopyWithImpl<TopMedicineSales>(this as TopMedicineSales, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TopMedicineSales;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopMedicineSales&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.quantitySold, _this.quantitySold) || other.quantitySold == _this.quantitySold)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue));
}


@override
int get hashCode {
  final _this = this as TopMedicineSales;
  return Object.hash(runtimeType,_this.medicineId,_this.brandName,_this.quantitySold,_this.revenue);
}

@override
String toString() {
  final _this = this as TopMedicineSales;
  return 'TopMedicineSales(medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, quantitySold: ${_this.quantitySold}, revenue: ${_this.revenue})';
}


}

/// @nodoc
abstract mixin class $TopMedicineSalesCopyWith<$Res>  {
  factory $TopMedicineSalesCopyWith(TopMedicineSales value, $Res Function(TopMedicineSales) _then) = _$TopMedicineSalesCopyWithImpl;
@useResult
$Res call({
 String medicineId, String brandName, double quantitySold, double revenue
});




}
/// @nodoc
class _$TopMedicineSalesCopyWithImpl<$Res>
    implements $TopMedicineSalesCopyWith<$Res> {
  _$TopMedicineSalesCopyWithImpl(this._self, this._then);

  final TopMedicineSales _self;
  final $Res Function(TopMedicineSales) _then;

/// Create a copy of TopMedicineSales
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? brandName = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(TopMedicineSales(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as double,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TopMedicineSales].
extension TopMedicineSalesPatterns on TopMedicineSales {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopMedicineSales value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopMedicineSales() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopMedicineSales value)  $default,){
final _that = this;
switch (_that) {
case _TopMedicineSales():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopMedicineSales value)?  $default,){
final _that = this;
switch (_that) {
case _TopMedicineSales() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantitySold,  double revenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopMedicineSales() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String brandName,  double quantitySold,  double revenue)  $default,) {final _that = this;
switch (_that) {
case _TopMedicineSales():
return $default(_that.medicineId,_that.brandName,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String brandName,  double quantitySold,  double revenue)?  $default,) {final _that = this;
switch (_that) {
case _TopMedicineSales() when $default != null:
return $default(_that.medicineId,_that.brandName,_that.quantitySold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc


class _TopMedicineSales implements TopMedicineSales {
  const _TopMedicineSales({required this.medicineId, required this.brandName, required this.quantitySold, required this.revenue});
  

@override final  String medicineId;
@override final  String brandName;
@override final  double quantitySold;
@override final  double revenue;

/// Create a copy of TopMedicineSales
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopMedicineSalesCopyWith<_TopMedicineSales> get copyWith => __$TopMedicineSalesCopyWithImpl<_TopMedicineSales>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopMedicineSales&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,brandName,quantitySold,revenue);
}

@override
String toString() {
    return 'TopMedicineSales(medicineId: $medicineId, brandName: $brandName, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$TopMedicineSalesCopyWith<$Res> implements $TopMedicineSalesCopyWith<$Res> {
  factory _$TopMedicineSalesCopyWith(_TopMedicineSales value, $Res Function(_TopMedicineSales) _then) = __$TopMedicineSalesCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String brandName, double quantitySold, double revenue
});




}
/// @nodoc
class __$TopMedicineSalesCopyWithImpl<$Res>
    implements _$TopMedicineSalesCopyWith<$Res> {
  __$TopMedicineSalesCopyWithImpl(this._self, this._then);

  final _TopMedicineSales _self;
  final $Res Function(_TopMedicineSales) _then;

/// Create a copy of TopMedicineSales
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? brandName = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_TopMedicineSales(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as double,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
