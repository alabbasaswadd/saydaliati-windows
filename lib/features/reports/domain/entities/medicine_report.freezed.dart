// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicineReport {

 String get medicineId; String get name; String get code; String get category; String get manufacturerName; double get unitPrice; double get purchaseCost; double get stockQuantity; double get soldQuantity; double get reservedQuantity; double get totalSalesAmount; int get totalTransactions; bool get isNearExpiry; bool get isLowStock; String get notes; DateTime? get expiryDate; List<MedicineBatch> get batches;
/// Create a copy of MedicineReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineReportCopyWith<MedicineReport> get copyWith => _$MedicineReportCopyWithImpl<MedicineReport>(this as MedicineReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MedicineReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineReport&&(identical(other.medicineId, _this.medicineId) || other.medicineId == _this.medicineId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.manufacturerName, _this.manufacturerName) || other.manufacturerName == _this.manufacturerName)&&(identical(other.unitPrice, _this.unitPrice) || other.unitPrice == _this.unitPrice)&&(identical(other.purchaseCost, _this.purchaseCost) || other.purchaseCost == _this.purchaseCost)&&(identical(other.stockQuantity, _this.stockQuantity) || other.stockQuantity == _this.stockQuantity)&&(identical(other.soldQuantity, _this.soldQuantity) || other.soldQuantity == _this.soldQuantity)&&(identical(other.reservedQuantity, _this.reservedQuantity) || other.reservedQuantity == _this.reservedQuantity)&&(identical(other.totalSalesAmount, _this.totalSalesAmount) || other.totalSalesAmount == _this.totalSalesAmount)&&(identical(other.totalTransactions, _this.totalTransactions) || other.totalTransactions == _this.totalTransactions)&&(identical(other.isNearExpiry, _this.isNearExpiry) || other.isNearExpiry == _this.isNearExpiry)&&(identical(other.isLowStock, _this.isLowStock) || other.isLowStock == _this.isLowStock)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&const DeepCollectionEquality().equals(other.batches, _this.batches));
}


@override
int get hashCode {
  final _this = this as MedicineReport;
  return Object.hash(runtimeType,_this.medicineId,_this.name,_this.code,_this.category,_this.manufacturerName,_this.unitPrice,_this.purchaseCost,_this.stockQuantity,_this.soldQuantity,_this.reservedQuantity,_this.totalSalesAmount,_this.totalTransactions,_this.isNearExpiry,_this.isLowStock,_this.notes,_this.expiryDate,const DeepCollectionEquality().hash(_this.batches));
}

@override
String toString() {
  final _this = this as MedicineReport;
  return 'MedicineReport(medicineId: ${_this.medicineId}, name: ${_this.name}, code: ${_this.code}, category: ${_this.category}, manufacturerName: ${_this.manufacturerName}, unitPrice: ${_this.unitPrice}, purchaseCost: ${_this.purchaseCost}, stockQuantity: ${_this.stockQuantity}, soldQuantity: ${_this.soldQuantity}, reservedQuantity: ${_this.reservedQuantity}, totalSalesAmount: ${_this.totalSalesAmount}, totalTransactions: ${_this.totalTransactions}, isNearExpiry: ${_this.isNearExpiry}, isLowStock: ${_this.isLowStock}, notes: ${_this.notes}, expiryDate: ${_this.expiryDate}, batches: ${_this.batches})';
}


}

/// @nodoc
abstract mixin class $MedicineReportCopyWith<$Res>  {
  factory $MedicineReportCopyWith(MedicineReport value, $Res Function(MedicineReport) _then) = _$MedicineReportCopyWithImpl;
@useResult
$Res call({
 String medicineId, String name, String code, String category, String manufacturerName, double unitPrice, double purchaseCost, double stockQuantity, double soldQuantity, double reservedQuantity, double totalSalesAmount, int totalTransactions, bool isNearExpiry, bool isLowStock, String notes, DateTime? expiryDate, List<MedicineBatch> batches
});




}
/// @nodoc
class _$MedicineReportCopyWithImpl<$Res>
    implements $MedicineReportCopyWith<$Res> {
  _$MedicineReportCopyWithImpl(this._self, this._then);

  final MedicineReport _self;
  final $Res Function(MedicineReport) _then;

/// Create a copy of MedicineReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = null,Object? name = null,Object? code = null,Object? category = null,Object? manufacturerName = null,Object? unitPrice = null,Object? purchaseCost = null,Object? stockQuantity = null,Object? soldQuantity = null,Object? reservedQuantity = null,Object? totalSalesAmount = null,Object? totalTransactions = null,Object? isNearExpiry = null,Object? isLowStock = null,Object? notes = null,Object? expiryDate = freezed,Object? batches = null,}) {
  return _then(MedicineReport(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,manufacturerName: null == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as double,soldQuantity: null == soldQuantity ? _self.soldQuantity : soldQuantity // ignore: cast_nullable_to_non_nullable
as double,reservedQuantity: null == reservedQuantity ? _self.reservedQuantity : reservedQuantity // ignore: cast_nullable_to_non_nullable
as double,totalSalesAmount: null == totalSalesAmount ? _self.totalSalesAmount : totalSalesAmount // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,isNearExpiry: null == isNearExpiry ? _self.isNearExpiry : isNearExpiry // ignore: cast_nullable_to_non_nullable
as bool,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<MedicineBatch>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineReport].
extension MedicineReportPatterns on MedicineReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineReport value)  $default,){
final _that = this;
switch (_that) {
case _MedicineReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineReport value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineId,  String name,  String code,  String category,  String manufacturerName,  double unitPrice,  double purchaseCost,  double stockQuantity,  double soldQuantity,  double reservedQuantity,  double totalSalesAmount,  int totalTransactions,  bool isNearExpiry,  bool isLowStock,  String notes,  DateTime? expiryDate,  List<MedicineBatch> batches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineReport() when $default != null:
return $default(_that.medicineId,_that.name,_that.code,_that.category,_that.manufacturerName,_that.unitPrice,_that.purchaseCost,_that.stockQuantity,_that.soldQuantity,_that.reservedQuantity,_that.totalSalesAmount,_that.totalTransactions,_that.isNearExpiry,_that.isLowStock,_that.notes,_that.expiryDate,_that.batches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineId,  String name,  String code,  String category,  String manufacturerName,  double unitPrice,  double purchaseCost,  double stockQuantity,  double soldQuantity,  double reservedQuantity,  double totalSalesAmount,  int totalTransactions,  bool isNearExpiry,  bool isLowStock,  String notes,  DateTime? expiryDate,  List<MedicineBatch> batches)  $default,) {final _that = this;
switch (_that) {
case _MedicineReport():
return $default(_that.medicineId,_that.name,_that.code,_that.category,_that.manufacturerName,_that.unitPrice,_that.purchaseCost,_that.stockQuantity,_that.soldQuantity,_that.reservedQuantity,_that.totalSalesAmount,_that.totalTransactions,_that.isNearExpiry,_that.isLowStock,_that.notes,_that.expiryDate,_that.batches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineId,  String name,  String code,  String category,  String manufacturerName,  double unitPrice,  double purchaseCost,  double stockQuantity,  double soldQuantity,  double reservedQuantity,  double totalSalesAmount,  int totalTransactions,  bool isNearExpiry,  bool isLowStock,  String notes,  DateTime? expiryDate,  List<MedicineBatch> batches)?  $default,) {final _that = this;
switch (_that) {
case _MedicineReport() when $default != null:
return $default(_that.medicineId,_that.name,_that.code,_that.category,_that.manufacturerName,_that.unitPrice,_that.purchaseCost,_that.stockQuantity,_that.soldQuantity,_that.reservedQuantity,_that.totalSalesAmount,_that.totalTransactions,_that.isNearExpiry,_that.isLowStock,_that.notes,_that.expiryDate,_that.batches);case _:
  return null;

}
}

}

/// @nodoc


class _MedicineReport implements MedicineReport {
  const _MedicineReport({required this.medicineId, required this.name, required this.code, required this.category, required this.manufacturerName, required this.unitPrice, required this.purchaseCost, required this.stockQuantity, required this.soldQuantity, required this.reservedQuantity, required this.totalSalesAmount, required this.totalTransactions, required this.isNearExpiry, required this.isLowStock, required this.notes, this.expiryDate,  List<MedicineBatch> batches = const <MedicineBatch>[]}): _batches = batches;
  

@override final  String medicineId;
@override final  String name;
@override final  String code;
@override final  String category;
@override final  String manufacturerName;
@override final  double unitPrice;
@override final  double purchaseCost;
@override final  double stockQuantity;
@override final  double soldQuantity;
@override final  double reservedQuantity;
@override final  double totalSalesAmount;
@override final  int totalTransactions;
@override final  bool isNearExpiry;
@override final  bool isLowStock;
@override final  String notes;
@override final  DateTime? expiryDate;
 final  List<MedicineBatch> _batches;
@override@JsonKey() List<MedicineBatch> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}


/// Create a copy of MedicineReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineReportCopyWith<_MedicineReport> get copyWith => __$MedicineReportCopyWithImpl<_MedicineReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineReport&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.category, category) || other.category == category)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.purchaseCost, purchaseCost) || other.purchaseCost == purchaseCost)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.soldQuantity, soldQuantity) || other.soldQuantity == soldQuantity)&&(identical(other.reservedQuantity, reservedQuantity) || other.reservedQuantity == reservedQuantity)&&(identical(other.totalSalesAmount, totalSalesAmount) || other.totalSalesAmount == totalSalesAmount)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.isNearExpiry, isNearExpiry) || other.isNearExpiry == isNearExpiry)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&const DeepCollectionEquality().equals(other.batches, _batches));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicineId,name,code,category,manufacturerName,unitPrice,purchaseCost,stockQuantity,soldQuantity,reservedQuantity,totalSalesAmount,totalTransactions,isNearExpiry,isLowStock,notes,expiryDate,const DeepCollectionEquality().hash(_batches));
}

@override
String toString() {
    return 'MedicineReport(medicineId: $medicineId, name: $name, code: $code, category: $category, manufacturerName: $manufacturerName, unitPrice: $unitPrice, purchaseCost: $purchaseCost, stockQuantity: $stockQuantity, soldQuantity: $soldQuantity, reservedQuantity: $reservedQuantity, totalSalesAmount: $totalSalesAmount, totalTransactions: $totalTransactions, isNearExpiry: $isNearExpiry, isLowStock: $isLowStock, notes: $notes, expiryDate: $expiryDate, batches: $batches)';
}


}

/// @nodoc
abstract mixin class _$MedicineReportCopyWith<$Res> implements $MedicineReportCopyWith<$Res> {
  factory _$MedicineReportCopyWith(_MedicineReport value, $Res Function(_MedicineReport) _then) = __$MedicineReportCopyWithImpl;
@override @useResult
$Res call({
 String medicineId, String name, String code, String category, String manufacturerName, double unitPrice, double purchaseCost, double stockQuantity, double soldQuantity, double reservedQuantity, double totalSalesAmount, int totalTransactions, bool isNearExpiry, bool isLowStock, String notes, DateTime? expiryDate, List<MedicineBatch> batches
});




}
/// @nodoc
class __$MedicineReportCopyWithImpl<$Res>
    implements _$MedicineReportCopyWith<$Res> {
  __$MedicineReportCopyWithImpl(this._self, this._then);

  final _MedicineReport _self;
  final $Res Function(_MedicineReport) _then;

/// Create a copy of MedicineReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = null,Object? name = null,Object? code = null,Object? category = null,Object? manufacturerName = null,Object? unitPrice = null,Object? purchaseCost = null,Object? stockQuantity = null,Object? soldQuantity = null,Object? reservedQuantity = null,Object? totalSalesAmount = null,Object? totalTransactions = null,Object? isNearExpiry = null,Object? isLowStock = null,Object? notes = null,Object? expiryDate = freezed,Object? batches = null,}) {
  return _then(_MedicineReport(
medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,manufacturerName: null == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as double,soldQuantity: null == soldQuantity ? _self.soldQuantity : soldQuantity // ignore: cast_nullable_to_non_nullable
as double,reservedQuantity: null == reservedQuantity ? _self.reservedQuantity : reservedQuantity // ignore: cast_nullable_to_non_nullable
as double,totalSalesAmount: null == totalSalesAmount ? _self.totalSalesAmount : totalSalesAmount // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,isNearExpiry: null == isNearExpiry ? _self.isNearExpiry : isNearExpiry // ignore: cast_nullable_to_non_nullable
as bool,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<MedicineBatch>,
  ));
}


}

/// @nodoc
mixin _$MedicineBatch {

 String get stockId; String get warehouseName; double get quantityAvailable; DateTime? get expiryDate; int? get daysLeft;
/// Create a copy of MedicineBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineBatchCopyWith<MedicineBatch> get copyWith => _$MedicineBatchCopyWithImpl<MedicineBatch>(this as MedicineBatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MedicineBatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineBatch&&(identical(other.stockId, _this.stockId) || other.stockId == _this.stockId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.quantityAvailable, _this.quantityAvailable) || other.quantityAvailable == _this.quantityAvailable)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft));
}


@override
int get hashCode {
  final _this = this as MedicineBatch;
  return Object.hash(runtimeType,_this.stockId,_this.warehouseName,_this.quantityAvailable,_this.expiryDate,_this.daysLeft);
}

@override
String toString() {
  final _this = this as MedicineBatch;
  return 'MedicineBatch(stockId: ${_this.stockId}, warehouseName: ${_this.warehouseName}, quantityAvailable: ${_this.quantityAvailable}, expiryDate: ${_this.expiryDate}, daysLeft: ${_this.daysLeft})';
}


}

/// @nodoc
abstract mixin class $MedicineBatchCopyWith<$Res>  {
  factory $MedicineBatchCopyWith(MedicineBatch value, $Res Function(MedicineBatch) _then) = _$MedicineBatchCopyWithImpl;
@useResult
$Res call({
 String stockId, String warehouseName, double quantityAvailable, DateTime? expiryDate, int? daysLeft
});




}
/// @nodoc
class _$MedicineBatchCopyWithImpl<$Res>
    implements $MedicineBatchCopyWith<$Res> {
  _$MedicineBatchCopyWithImpl(this._self, this._then);

  final MedicineBatch _self;
  final $Res Function(MedicineBatch) _then;

/// Create a copy of MedicineBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stockId = null,Object? warehouseName = null,Object? quantityAvailable = null,Object? expiryDate = freezed,Object? daysLeft = freezed,}) {
  return _then(MedicineBatch(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineBatch].
extension MedicineBatchPatterns on MedicineBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineBatch value)  $default,){
final _that = this;
switch (_that) {
case _MedicineBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineBatch value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stockId,  String warehouseName,  double quantityAvailable,  DateTime? expiryDate,  int? daysLeft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineBatch() when $default != null:
return $default(_that.stockId,_that.warehouseName,_that.quantityAvailable,_that.expiryDate,_that.daysLeft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stockId,  String warehouseName,  double quantityAvailable,  DateTime? expiryDate,  int? daysLeft)  $default,) {final _that = this;
switch (_that) {
case _MedicineBatch():
return $default(_that.stockId,_that.warehouseName,_that.quantityAvailable,_that.expiryDate,_that.daysLeft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stockId,  String warehouseName,  double quantityAvailable,  DateTime? expiryDate,  int? daysLeft)?  $default,) {final _that = this;
switch (_that) {
case _MedicineBatch() when $default != null:
return $default(_that.stockId,_that.warehouseName,_that.quantityAvailable,_that.expiryDate,_that.daysLeft);case _:
  return null;

}
}

}

/// @nodoc


class _MedicineBatch implements MedicineBatch {
  const _MedicineBatch({required this.stockId, required this.warehouseName, required this.quantityAvailable, this.expiryDate, this.daysLeft});
  

@override final  String stockId;
@override final  String warehouseName;
@override final  double quantityAvailable;
@override final  DateTime? expiryDate;
@override final  int? daysLeft;

/// Create a copy of MedicineBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineBatchCopyWith<_MedicineBatch> get copyWith => __$MedicineBatchCopyWithImpl<_MedicineBatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineBatch&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.quantityAvailable, quantityAvailable) || other.quantityAvailable == quantityAvailable)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stockId,warehouseName,quantityAvailable,expiryDate,daysLeft);
}

@override
String toString() {
    return 'MedicineBatch(stockId: $stockId, warehouseName: $warehouseName, quantityAvailable: $quantityAvailable, expiryDate: $expiryDate, daysLeft: $daysLeft)';
}


}

/// @nodoc
abstract mixin class _$MedicineBatchCopyWith<$Res> implements $MedicineBatchCopyWith<$Res> {
  factory _$MedicineBatchCopyWith(_MedicineBatch value, $Res Function(_MedicineBatch) _then) = __$MedicineBatchCopyWithImpl;
@override @useResult
$Res call({
 String stockId, String warehouseName, double quantityAvailable, DateTime? expiryDate, int? daysLeft
});




}
/// @nodoc
class __$MedicineBatchCopyWithImpl<$Res>
    implements _$MedicineBatchCopyWith<$Res> {
  __$MedicineBatchCopyWithImpl(this._self, this._then);

  final _MedicineBatch _self;
  final $Res Function(_MedicineBatch) _then;

/// Create a copy of MedicineBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stockId = null,Object? warehouseName = null,Object? quantityAvailable = null,Object? expiryDate = freezed,Object? daysLeft = freezed,}) {
  return _then(_MedicineBatch(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,warehouseName: null == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String,quantityAvailable: null == quantityAvailable ? _self.quantityAvailable : quantityAvailable // ignore: cast_nullable_to_non_nullable
as double,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
