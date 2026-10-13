// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Medicine {

 String get id; String get brandName; String get brandNameArabic; String get genericName; String get foreignName; String get barcode; DosageForm get dosageForm; String get categoryId; String? get categoryName; String? get manufacturerId; String? get manufacturerName; List<MedicineUnit> get units; double get purchaseCost; bool get autoPriceSync; String get currency;
/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineCopyWith<Medicine> get copyWith => _$MedicineCopyWithImpl<Medicine>(this as Medicine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Medicine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medicine&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.brandNameArabic, _this.brandNameArabic) || other.brandNameArabic == _this.brandNameArabic)&&(identical(other.genericName, _this.genericName) || other.genericName == _this.genericName)&&(identical(other.foreignName, _this.foreignName) || other.foreignName == _this.foreignName)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.dosageForm, _this.dosageForm) || other.dosageForm == _this.dosageForm)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.manufacturerId, _this.manufacturerId) || other.manufacturerId == _this.manufacturerId)&&(identical(other.manufacturerName, _this.manufacturerName) || other.manufacturerName == _this.manufacturerName)&&const DeepCollectionEquality().equals(other.units, _this.units)&&(identical(other.purchaseCost, _this.purchaseCost) || other.purchaseCost == _this.purchaseCost)&&(identical(other.autoPriceSync, _this.autoPriceSync) || other.autoPriceSync == _this.autoPriceSync)&&(identical(other.currency, _this.currency) || other.currency == _this.currency));
}


@override
int get hashCode {
  final _this = this as Medicine;
  return Object.hash(runtimeType,_this.id,_this.brandName,_this.brandNameArabic,_this.genericName,_this.foreignName,_this.barcode,_this.dosageForm,_this.categoryId,_this.categoryName,_this.manufacturerId,_this.manufacturerName,const DeepCollectionEquality().hash(_this.units),_this.purchaseCost,_this.autoPriceSync,_this.currency);
}

@override
String toString() {
  final _this = this as Medicine;
  return 'Medicine(id: ${_this.id}, brandName: ${_this.brandName}, brandNameArabic: ${_this.brandNameArabic}, genericName: ${_this.genericName}, foreignName: ${_this.foreignName}, barcode: ${_this.barcode}, dosageForm: ${_this.dosageForm}, categoryId: ${_this.categoryId}, categoryName: ${_this.categoryName}, manufacturerId: ${_this.manufacturerId}, manufacturerName: ${_this.manufacturerName}, units: ${_this.units}, purchaseCost: ${_this.purchaseCost}, autoPriceSync: ${_this.autoPriceSync}, currency: ${_this.currency})';
}


}

/// @nodoc
abstract mixin class $MedicineCopyWith<$Res>  {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) _then) = _$MedicineCopyWithImpl;
@useResult
$Res call({
 String id, String brandName, String brandNameArabic, String genericName, String foreignName, String barcode, DosageForm dosageForm, String categoryId, String? categoryName, String? manufacturerId, String? manufacturerName, List<MedicineUnit> units, double purchaseCost, bool autoPriceSync, String currency
});




}
/// @nodoc
class _$MedicineCopyWithImpl<$Res>
    implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._self, this._then);

  final Medicine _self;
  final $Res Function(Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brandName = null,Object? brandNameArabic = null,Object? genericName = null,Object? foreignName = null,Object? barcode = null,Object? dosageForm = null,Object? categoryId = null,Object? categoryName = freezed,Object? manufacturerId = freezed,Object? manufacturerName = freezed,Object? units = null,Object? purchaseCost = null,Object? autoPriceSync = null,Object? currency = null,}) {
  return _then(Medicine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,brandNameArabic: null == brandNameArabic ? _self.brandNameArabic : brandNameArabic // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,foreignName: null == foreignName ? _self.foreignName : foreignName // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,dosageForm: null == dosageForm ? _self.dosageForm : dosageForm // ignore: cast_nullable_to_non_nullable
as DosageForm,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,manufacturerId: freezed == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String?,manufacturerName: freezed == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String?,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<MedicineUnit>,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,autoPriceSync: null == autoPriceSync ? _self.autoPriceSync : autoPriceSync // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Medicine].
extension MedicinePatterns on Medicine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medicine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medicine value)  $default,){
final _that = this;
switch (_that) {
case _Medicine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medicine value)?  $default,){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String brandName,  String brandNameArabic,  String genericName,  String foreignName,  String barcode,  DosageForm dosageForm,  String categoryId,  String? categoryName,  String? manufacturerId,  String? manufacturerName,  List<MedicineUnit> units,  double purchaseCost,  bool autoPriceSync,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.brandName,_that.brandNameArabic,_that.genericName,_that.foreignName,_that.barcode,_that.dosageForm,_that.categoryId,_that.categoryName,_that.manufacturerId,_that.manufacturerName,_that.units,_that.purchaseCost,_that.autoPriceSync,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String brandName,  String brandNameArabic,  String genericName,  String foreignName,  String barcode,  DosageForm dosageForm,  String categoryId,  String? categoryName,  String? manufacturerId,  String? manufacturerName,  List<MedicineUnit> units,  double purchaseCost,  bool autoPriceSync,  String currency)  $default,) {final _that = this;
switch (_that) {
case _Medicine():
return $default(_that.id,_that.brandName,_that.brandNameArabic,_that.genericName,_that.foreignName,_that.barcode,_that.dosageForm,_that.categoryId,_that.categoryName,_that.manufacturerId,_that.manufacturerName,_that.units,_that.purchaseCost,_that.autoPriceSync,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String brandName,  String brandNameArabic,  String genericName,  String foreignName,  String barcode,  DosageForm dosageForm,  String categoryId,  String? categoryName,  String? manufacturerId,  String? manufacturerName,  List<MedicineUnit> units,  double purchaseCost,  bool autoPriceSync,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.brandName,_that.brandNameArabic,_that.genericName,_that.foreignName,_that.barcode,_that.dosageForm,_that.categoryId,_that.categoryName,_that.manufacturerId,_that.manufacturerName,_that.units,_that.purchaseCost,_that.autoPriceSync,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _Medicine extends Medicine {
  const _Medicine({required this.id, required this.brandName, this.brandNameArabic = '', required this.genericName, this.foreignName = '', required this.barcode, required this.dosageForm, required this.categoryId, this.categoryName, this.manufacturerId, this.manufacturerName,  List<MedicineUnit> units = const <MedicineUnit>[], this.purchaseCost = 0, this.autoPriceSync = true, this.currency = 'SYP'}): _units = units,super._();
  

@override final  String id;
@override final  String brandName;
@override@JsonKey() final  String brandNameArabic;
@override final  String genericName;
@override@JsonKey() final  String foreignName;
@override final  String barcode;
@override final  DosageForm dosageForm;
@override final  String categoryId;
@override final  String? categoryName;
@override final  String? manufacturerId;
@override final  String? manufacturerName;
 final  List<MedicineUnit> _units;
@override@JsonKey() List<MedicineUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

@override@JsonKey() final  double purchaseCost;
@override@JsonKey() final  bool autoPriceSync;
@override@JsonKey() final  String currency;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineCopyWith<_Medicine> get copyWith => __$MedicineCopyWithImpl<_Medicine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medicine&&(identical(other.id, id) || other.id == id)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.brandNameArabic, brandNameArabic) || other.brandNameArabic == brandNameArabic)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.foreignName, foreignName) || other.foreignName == foreignName)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.dosageForm, dosageForm) || other.dosageForm == dosageForm)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&const DeepCollectionEquality().equals(other.units, _units)&&(identical(other.purchaseCost, purchaseCost) || other.purchaseCost == purchaseCost)&&(identical(other.autoPriceSync, autoPriceSync) || other.autoPriceSync == autoPriceSync)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,brandName,brandNameArabic,genericName,foreignName,barcode,dosageForm,categoryId,categoryName,manufacturerId,manufacturerName,const DeepCollectionEquality().hash(_units),purchaseCost,autoPriceSync,currency);
}

@override
String toString() {
    return 'Medicine(id: $id, brandName: $brandName, brandNameArabic: $brandNameArabic, genericName: $genericName, foreignName: $foreignName, barcode: $barcode, dosageForm: $dosageForm, categoryId: $categoryId, categoryName: $categoryName, manufacturerId: $manufacturerId, manufacturerName: $manufacturerName, units: $units, purchaseCost: $purchaseCost, autoPriceSync: $autoPriceSync, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$MedicineCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$MedicineCopyWith(_Medicine value, $Res Function(_Medicine) _then) = __$MedicineCopyWithImpl;
@override @useResult
$Res call({
 String id, String brandName, String brandNameArabic, String genericName, String foreignName, String barcode, DosageForm dosageForm, String categoryId, String? categoryName, String? manufacturerId, String? manufacturerName, List<MedicineUnit> units, double purchaseCost, bool autoPriceSync, String currency
});




}
/// @nodoc
class __$MedicineCopyWithImpl<$Res>
    implements _$MedicineCopyWith<$Res> {
  __$MedicineCopyWithImpl(this._self, this._then);

  final _Medicine _self;
  final $Res Function(_Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brandName = null,Object? brandNameArabic = null,Object? genericName = null,Object? foreignName = null,Object? barcode = null,Object? dosageForm = null,Object? categoryId = null,Object? categoryName = freezed,Object? manufacturerId = freezed,Object? manufacturerName = freezed,Object? units = null,Object? purchaseCost = null,Object? autoPriceSync = null,Object? currency = null,}) {
  return _then(_Medicine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,brandNameArabic: null == brandNameArabic ? _self.brandNameArabic : brandNameArabic // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,foreignName: null == foreignName ? _self.foreignName : foreignName // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,dosageForm: null == dosageForm ? _self.dosageForm : dosageForm // ignore: cast_nullable_to_non_nullable
as DosageForm,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,manufacturerId: freezed == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String?,manufacturerName: freezed == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String?,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<MedicineUnit>,purchaseCost: null == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double,autoPriceSync: null == autoPriceSync ? _self.autoPriceSync : autoPriceSync // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MedicineUnit {

 String get unitId; String get unitName; double get salePrice; double get conversionFactor; bool get isBaseUnit; bool get isDefault;
/// Create a copy of MedicineUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineUnitCopyWith<MedicineUnit> get copyWith => _$MedicineUnitCopyWithImpl<MedicineUnit>(this as MedicineUnit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MedicineUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineUnit&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.unitName, _this.unitName) || other.unitName == _this.unitName)&&(identical(other.salePrice, _this.salePrice) || other.salePrice == _this.salePrice)&&(identical(other.conversionFactor, _this.conversionFactor) || other.conversionFactor == _this.conversionFactor)&&(identical(other.isBaseUnit, _this.isBaseUnit) || other.isBaseUnit == _this.isBaseUnit)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}


@override
int get hashCode {
  final _this = this as MedicineUnit;
  return Object.hash(runtimeType,_this.unitId,_this.unitName,_this.salePrice,_this.conversionFactor,_this.isBaseUnit,_this.isDefault);
}

@override
String toString() {
  final _this = this as MedicineUnit;
  return 'MedicineUnit(unitId: ${_this.unitId}, unitName: ${_this.unitName}, salePrice: ${_this.salePrice}, conversionFactor: ${_this.conversionFactor}, isBaseUnit: ${_this.isBaseUnit}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $MedicineUnitCopyWith<$Res>  {
  factory $MedicineUnitCopyWith(MedicineUnit value, $Res Function(MedicineUnit) _then) = _$MedicineUnitCopyWithImpl;
@useResult
$Res call({
 String unitId, String unitName, double salePrice, double conversionFactor, bool isBaseUnit, bool isDefault
});




}
/// @nodoc
class _$MedicineUnitCopyWithImpl<$Res>
    implements $MedicineUnitCopyWith<$Res> {
  _$MedicineUnitCopyWithImpl(this._self, this._then);

  final MedicineUnit _self;
  final $Res Function(MedicineUnit) _then;

/// Create a copy of MedicineUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unitId = null,Object? unitName = null,Object? salePrice = null,Object? conversionFactor = null,Object? isBaseUnit = null,Object? isDefault = null,}) {
  return _then(MedicineUnit(
unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as double,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineUnit].
extension MedicineUnitPatterns on MedicineUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineUnit value)  $default,){
final _that = this;
switch (_that) {
case _MedicineUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineUnit value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unitId,  String unitName,  double salePrice,  double conversionFactor,  bool isBaseUnit,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineUnit() when $default != null:
return $default(_that.unitId,_that.unitName,_that.salePrice,_that.conversionFactor,_that.isBaseUnit,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unitId,  String unitName,  double salePrice,  double conversionFactor,  bool isBaseUnit,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _MedicineUnit():
return $default(_that.unitId,_that.unitName,_that.salePrice,_that.conversionFactor,_that.isBaseUnit,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unitId,  String unitName,  double salePrice,  double conversionFactor,  bool isBaseUnit,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _MedicineUnit() when $default != null:
return $default(_that.unitId,_that.unitName,_that.salePrice,_that.conversionFactor,_that.isBaseUnit,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _MedicineUnit implements MedicineUnit {
  const _MedicineUnit({required this.unitId, required this.unitName, required this.salePrice, this.conversionFactor = 1, this.isBaseUnit = false, this.isDefault = false});
  

@override final  String unitId;
@override final  String unitName;
@override final  double salePrice;
@override@JsonKey() final  double conversionFactor;
@override@JsonKey() final  bool isBaseUnit;
@override@JsonKey() final  bool isDefault;

/// Create a copy of MedicineUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineUnitCopyWith<_MedicineUnit> get copyWith => __$MedicineUnitCopyWithImpl<_MedicineUnit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineUnit&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.conversionFactor, conversionFactor) || other.conversionFactor == conversionFactor)&&(identical(other.isBaseUnit, isBaseUnit) || other.isBaseUnit == isBaseUnit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode {
    return Object.hash(runtimeType,unitId,unitName,salePrice,conversionFactor,isBaseUnit,isDefault);
}

@override
String toString() {
    return 'MedicineUnit(unitId: $unitId, unitName: $unitName, salePrice: $salePrice, conversionFactor: $conversionFactor, isBaseUnit: $isBaseUnit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$MedicineUnitCopyWith<$Res> implements $MedicineUnitCopyWith<$Res> {
  factory _$MedicineUnitCopyWith(_MedicineUnit value, $Res Function(_MedicineUnit) _then) = __$MedicineUnitCopyWithImpl;
@override @useResult
$Res call({
 String unitId, String unitName, double salePrice, double conversionFactor, bool isBaseUnit, bool isDefault
});




}
/// @nodoc
class __$MedicineUnitCopyWithImpl<$Res>
    implements _$MedicineUnitCopyWith<$Res> {
  __$MedicineUnitCopyWithImpl(this._self, this._then);

  final _MedicineUnit _self;
  final $Res Function(_MedicineUnit) _then;

/// Create a copy of MedicineUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unitId = null,Object? unitName = null,Object? salePrice = null,Object? conversionFactor = null,Object? isBaseUnit = null,Object? isDefault = null,}) {
  return _then(_MedicineUnit(
unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,conversionFactor: null == conversionFactor ? _self.conversionFactor : conversionFactor // ignore: cast_nullable_to_non_nullable
as double,isBaseUnit: null == isBaseUnit ? _self.isBaseUnit : isBaseUnit // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
