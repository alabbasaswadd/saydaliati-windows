// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Currency {

 String get id; String get code; String get name; String get symbol; double get exchangeRate; bool get isBaseCurrency; bool get isActive; DateTime? get rateUpdatedOn;
/// Create a copy of Currency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrencyCopyWith<Currency> get copyWith => _$CurrencyCopyWithImpl<Currency>(this as Currency, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Currency;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Currency&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.exchangeRate, _this.exchangeRate) || other.exchangeRate == _this.exchangeRate)&&(identical(other.isBaseCurrency, _this.isBaseCurrency) || other.isBaseCurrency == _this.isBaseCurrency)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.rateUpdatedOn, _this.rateUpdatedOn) || other.rateUpdatedOn == _this.rateUpdatedOn));
}


@override
int get hashCode {
  final _this = this as Currency;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.symbol,_this.exchangeRate,_this.isBaseCurrency,_this.isActive,_this.rateUpdatedOn);
}

@override
String toString() {
  final _this = this as Currency;
  return 'Currency(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, symbol: ${_this.symbol}, exchangeRate: ${_this.exchangeRate}, isBaseCurrency: ${_this.isBaseCurrency}, isActive: ${_this.isActive}, rateUpdatedOn: ${_this.rateUpdatedOn})';
}


}

/// @nodoc
abstract mixin class $CurrencyCopyWith<$Res>  {
  factory $CurrencyCopyWith(Currency value, $Res Function(Currency) _then) = _$CurrencyCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String symbol, double exchangeRate, bool isBaseCurrency, bool isActive, DateTime? rateUpdatedOn
});




}
/// @nodoc
class _$CurrencyCopyWithImpl<$Res>
    implements $CurrencyCopyWith<$Res> {
  _$CurrencyCopyWithImpl(this._self, this._then);

  final Currency _self;
  final $Res Function(Currency) _then;

/// Create a copy of Currency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? symbol = null,Object? exchangeRate = null,Object? isBaseCurrency = null,Object? isActive = null,Object? rateUpdatedOn = freezed,}) {
  return _then(Currency(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,isBaseCurrency: null == isBaseCurrency ? _self.isBaseCurrency : isBaseCurrency // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,rateUpdatedOn: freezed == rateUpdatedOn ? _self.rateUpdatedOn : rateUpdatedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Currency].
extension CurrencyPatterns on Currency {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Currency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Currency() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Currency value)  $default,){
final _that = this;
switch (_that) {
case _Currency():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Currency value)?  $default,){
final _that = this;
switch (_that) {
case _Currency() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String symbol,  double exchangeRate,  bool isBaseCurrency,  bool isActive,  DateTime? rateUpdatedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Currency() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.symbol,_that.exchangeRate,_that.isBaseCurrency,_that.isActive,_that.rateUpdatedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String symbol,  double exchangeRate,  bool isBaseCurrency,  bool isActive,  DateTime? rateUpdatedOn)  $default,) {final _that = this;
switch (_that) {
case _Currency():
return $default(_that.id,_that.code,_that.name,_that.symbol,_that.exchangeRate,_that.isBaseCurrency,_that.isActive,_that.rateUpdatedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  String symbol,  double exchangeRate,  bool isBaseCurrency,  bool isActive,  DateTime? rateUpdatedOn)?  $default,) {final _that = this;
switch (_that) {
case _Currency() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.symbol,_that.exchangeRate,_that.isBaseCurrency,_that.isActive,_that.rateUpdatedOn);case _:
  return null;

}
}

}

/// @nodoc


class _Currency implements Currency {
  const _Currency({required this.id, required this.code, required this.name, required this.symbol, required this.exchangeRate, required this.isBaseCurrency, required this.isActive, this.rateUpdatedOn});
  

@override final  String id;
@override final  String code;
@override final  String name;
@override final  String symbol;
@override final  double exchangeRate;
@override final  bool isBaseCurrency;
@override final  bool isActive;
@override final  DateTime? rateUpdatedOn;

/// Create a copy of Currency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrencyCopyWith<_Currency> get copyWith => __$CurrencyCopyWithImpl<_Currency>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Currency&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.isBaseCurrency, isBaseCurrency) || other.isBaseCurrency == isBaseCurrency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.rateUpdatedOn, rateUpdatedOn) || other.rateUpdatedOn == rateUpdatedOn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,symbol,exchangeRate,isBaseCurrency,isActive,rateUpdatedOn);
}

@override
String toString() {
    return 'Currency(id: $id, code: $code, name: $name, symbol: $symbol, exchangeRate: $exchangeRate, isBaseCurrency: $isBaseCurrency, isActive: $isActive, rateUpdatedOn: $rateUpdatedOn)';
}


}

/// @nodoc
abstract mixin class _$CurrencyCopyWith<$Res> implements $CurrencyCopyWith<$Res> {
  factory _$CurrencyCopyWith(_Currency value, $Res Function(_Currency) _then) = __$CurrencyCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String symbol, double exchangeRate, bool isBaseCurrency, bool isActive, DateTime? rateUpdatedOn
});




}
/// @nodoc
class __$CurrencyCopyWithImpl<$Res>
    implements _$CurrencyCopyWith<$Res> {
  __$CurrencyCopyWithImpl(this._self, this._then);

  final _Currency _self;
  final $Res Function(_Currency) _then;

/// Create a copy of Currency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? symbol = null,Object? exchangeRate = null,Object? isBaseCurrency = null,Object? isActive = null,Object? rateUpdatedOn = freezed,}) {
  return _then(_Currency(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,isBaseCurrency: null == isBaseCurrency ? _self.isBaseCurrency : isBaseCurrency // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,rateUpdatedOn: freezed == rateUpdatedOn ? _self.rateUpdatedOn : rateUpdatedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
