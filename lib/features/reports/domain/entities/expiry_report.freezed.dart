// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expiry_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpiryReport {

 List<ExpiryBatch> get expiringSoon; List<ExpiryBatch> get expired;
/// Create a copy of ExpiryReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiryReportCopyWith<ExpiryReport> get copyWith => _$ExpiryReportCopyWithImpl<ExpiryReport>(this as ExpiryReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExpiryReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiryReport&&const DeepCollectionEquality().equals(other.expiringSoon, _this.expiringSoon)&&const DeepCollectionEquality().equals(other.expired, _this.expired));
}


@override
int get hashCode {
  final _this = this as ExpiryReport;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.expiringSoon),const DeepCollectionEquality().hash(_this.expired));
}

@override
String toString() {
  final _this = this as ExpiryReport;
  return 'ExpiryReport(expiringSoon: ${_this.expiringSoon}, expired: ${_this.expired})';
}


}

/// @nodoc
abstract mixin class $ExpiryReportCopyWith<$Res>  {
  factory $ExpiryReportCopyWith(ExpiryReport value, $Res Function(ExpiryReport) _then) = _$ExpiryReportCopyWithImpl;
@useResult
$Res call({
 List<ExpiryBatch> expiringSoon, List<ExpiryBatch> expired
});




}
/// @nodoc
class _$ExpiryReportCopyWithImpl<$Res>
    implements $ExpiryReportCopyWith<$Res> {
  _$ExpiryReportCopyWithImpl(this._self, this._then);

  final ExpiryReport _self;
  final $Res Function(ExpiryReport) _then;

/// Create a copy of ExpiryReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiringSoon = null,Object? expired = null,}) {
  return _then(ExpiryReport(
expiringSoon: null == expiringSoon ? _self.expiringSoon : expiringSoon // ignore: cast_nullable_to_non_nullable
as List<ExpiryBatch>,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as List<ExpiryBatch>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpiryReport].
extension ExpiryReportPatterns on ExpiryReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiryReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiryReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiryReport value)  $default,){
final _that = this;
switch (_that) {
case _ExpiryReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiryReport value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiryReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ExpiryBatch> expiringSoon,  List<ExpiryBatch> expired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiryReport() when $default != null:
return $default(_that.expiringSoon,_that.expired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ExpiryBatch> expiringSoon,  List<ExpiryBatch> expired)  $default,) {final _that = this;
switch (_that) {
case _ExpiryReport():
return $default(_that.expiringSoon,_that.expired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ExpiryBatch> expiringSoon,  List<ExpiryBatch> expired)?  $default,) {final _that = this;
switch (_that) {
case _ExpiryReport() when $default != null:
return $default(_that.expiringSoon,_that.expired);case _:
  return null;

}
}

}

/// @nodoc


class _ExpiryReport implements ExpiryReport {
  const _ExpiryReport({ List<ExpiryBatch> expiringSoon = const <ExpiryBatch>[],  List<ExpiryBatch> expired = const <ExpiryBatch>[]}): _expiringSoon = expiringSoon,_expired = expired;
  

 final  List<ExpiryBatch> _expiringSoon;
@override@JsonKey() List<ExpiryBatch> get expiringSoon {
  if (_expiringSoon is EqualUnmodifiableListView) return _expiringSoon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expiringSoon);
}

 final  List<ExpiryBatch> _expired;
@override@JsonKey() List<ExpiryBatch> get expired {
  if (_expired is EqualUnmodifiableListView) return _expired;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expired);
}


/// Create a copy of ExpiryReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiryReportCopyWith<_ExpiryReport> get copyWith => __$ExpiryReportCopyWithImpl<_ExpiryReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiryReport&&const DeepCollectionEquality().equals(other.expiringSoon, _expiringSoon)&&const DeepCollectionEquality().equals(other.expired, _expired));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_expiringSoon),const DeepCollectionEquality().hash(_expired));
}

@override
String toString() {
    return 'ExpiryReport(expiringSoon: $expiringSoon, expired: $expired)';
}


}

/// @nodoc
abstract mixin class _$ExpiryReportCopyWith<$Res> implements $ExpiryReportCopyWith<$Res> {
  factory _$ExpiryReportCopyWith(_ExpiryReport value, $Res Function(_ExpiryReport) _then) = __$ExpiryReportCopyWithImpl;
@override @useResult
$Res call({
 List<ExpiryBatch> expiringSoon, List<ExpiryBatch> expired
});




}
/// @nodoc
class __$ExpiryReportCopyWithImpl<$Res>
    implements _$ExpiryReportCopyWith<$Res> {
  __$ExpiryReportCopyWithImpl(this._self, this._then);

  final _ExpiryReport _self;
  final $Res Function(_ExpiryReport) _then;

/// Create a copy of ExpiryReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiringSoon = null,Object? expired = null,}) {
  return _then(_ExpiryReport(
expiringSoon: null == expiringSoon ? _self._expiringSoon : expiringSoon // ignore: cast_nullable_to_non_nullable
as List<ExpiryBatch>,expired: null == expired ? _self._expired : expired // ignore: cast_nullable_to_non_nullable
as List<ExpiryBatch>,
  ));
}


}

/// @nodoc
mixin _$ExpiryBatch {

 String get stockId; String get medicineId; String get brandName; String get warehouseName; DateTime get expiryDate; double get quantityAvailable; int get daysLeft;
/// Create a copy of ExpiryBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiryBatchCopyWith<ExpiryBatch> get copyWith => _$ExpiryBatchCopyWithImpl<ExpiryBatch>(this as ExpiryBatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExpiryBatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiryBatch&&(identical(other.stockId, _this.stockId) || other.stockId == _this.stockId)&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.quantityAvailable, _this.quantityAvailable) || other.quantityAvailable == _this.quantityAvailable)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft));
}


@override
int get hashCode {
  final _this = this as ExpiryBatch;
  return Object.hash(runtimeType,_this.stockId,_this.medicineId,_this.brandName,_this.warehouseName,_this.expiryDate,_this.quantityAvailable,_this.daysLeft);
}

@override
String toString() {
  final _this = this as ExpiryBatch;
  return 'ExpiryBatch(stockId: ${_this.stockId}, medicineId: ${_this.medicineId}, brandName: ${_this.brandName}, warehouseName: ${_this.warehouseName}, expiryDate: ${_this.expiryDate}, quantityAvailable: ${_this.quantityAvailable}, daysLeft: ${_this.daysLeft})';
}


}

/// @nodoc
abstract mixin class $ExpiryBatchCopyWith<$Res>  {
  factory $ExpiryBatchCopyWith(ExpiryBatch value, $Res Function(ExpiryBatch) _then) = _$ExpiryBatchCopyWithImpl;
@useResult
$Res call({
 String stockId, String medicineId, String brandName, String warehouseName, DateTime expiryDate, double quantityAvailable, int daysLeft
});




}
/// @nodoc
class _$ExpiryBatchCopyWithImpl<$Res>
    implements $ExpiryBatchCopyWith<$Res> {
  _$ExpiryBatchCopyWithImpl(this._self, this._then);

  final ExpiryBatch _self;
  final $Res Function(ExpiryBatch) _then;

/// Create a copy of ExpiryBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stockId = null,Object? medicineId = null,Object? brandName = null,Object? warehouseName = null,Object? expiryDate = null,Object? quantityAvailable = null,Object? daysLeft = null,}) {
  return _then(ExpiryBatch(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpiryBatch].
extension ExpiryBatchPatterns on ExpiryBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiryBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiryBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiryBatch value)  $default,){
final _that = this;
switch (_that) {
case _ExpiryBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiryBatch value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiryBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stockId,  String medicineId,  String brandName,  String warehouseName,  DateTime expiryDate,  double quantityAvailable,  int daysLeft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiryBatch() when $default != null:
return $default(_that.stockId,_that.medicineId,_that.brandName,_that.warehouseName,_that.expiryDate,_that.quantityAvailable,_that.daysLeft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stockId,  String medicineId,  String brandName,  String warehouseName,  DateTime expiryDate,  double quantityAvailable,  int daysLeft)  $default,) {final _that = this;
switch (_that) {
case _ExpiryBatch():
return $default(_that.stockId,_that.medicineId,_that.brandName,_that.warehouseName,_that.expiryDate,_that.quantityAvailable,_that.daysLeft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stockId,  String medicineId,  String brandName,  String warehouseName,  DateTime expiryDate,  double quantityAvailable,  int daysLeft)?  $default,) {final _that = this;
switch (_that) {
case _ExpiryBatch() when $default != null:
return $default(_that.stockId,_that.medicineId,_that.brandName,_that.warehouseName,_that.expiryDate,_that.quantityAvailable,_that.daysLeft);case _:
  return null;

}
}

}

/// @nodoc


class _ExpiryBatch implements ExpiryBatch {
  const _ExpiryBatch({required this.stockId, required this.medicineId, required this.brandName, required this.warehouseName, required this.expiryDate, required this.quantityAvailable, required this.daysLeft});
  

@override final  String stockId;
@override final  String medicineId;
@override final  String brandName;
@override final  String warehouseName;
@override final  DateTime expiryDate;
@override final  double quantityAvailable;
@override final  int daysLeft;

/// Create a copy of ExpiryBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiryBatchCopyWith<_ExpiryBatch> get copyWith => __$ExpiryBatchCopyWithImpl<_ExpiryBatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiryBatch&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.quantityAvailable, quantityAvailable) || other.quantityAvailable == quantityAvailable)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stockId,medicineId,brandName,warehouseName,expiryDate,quantityAvailable,daysLeft);
}

@override
String toString() {
    return 'ExpiryBatch(stockId: $stockId, medicineId: $medicineId, brandName: $brandName, warehouseName: $warehouseName, expiryDate: $expiryDate, quantityAvailable: $quantityAvailable, daysLeft: $daysLeft)';
}


}

/// @nodoc
abstract mixin class _$ExpiryBatchCopyWith<$Res> implements $ExpiryBatchCopyWith<$Res> {
  factory _$ExpiryBatchCopyWith(_ExpiryBatch value, $Res Function(_ExpiryBatch) _then) = __$ExpiryBatchCopyWithImpl;
@override @useResult
$Res call({
 String stockId, String medicineId, String brandName, String warehouseName, DateTime expiryDate, double quantityAvailable, int daysLeft
});




}
/// @nodoc
class __$ExpiryBatchCopyWithImpl<$Res>
    implements _$ExpiryBatchCopyWith<$Res> {
  __$ExpiryBatchCopyWithImpl(this._self, this._then);

  final _ExpiryBatch _self;
  final $Res Function(_ExpiryBatch) _then;

/// Create a copy of ExpiryBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stockId = null,Object? medicineId = null,Object? brandName = null,Object? warehouseName = null,Object? expiryDate = null,Object? quantityAvailable = null,Object? daysLeft = null,}) {
  return _then(_ExpiryBatch(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
