// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternatives_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alternativesRemoteDataSource)
final alternativesRemoteDataSourceProvider =
    AlternativesRemoteDataSourceProvider._();

final class AlternativesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AlternativesRemoteDataSource,
          AlternativesRemoteDataSource,
          AlternativesRemoteDataSource
        >
    with $Provider<AlternativesRemoteDataSource> {
  AlternativesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alternativesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alternativesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AlternativesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlternativesRemoteDataSource create(Ref ref) {
    return alternativesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlternativesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlternativesRemoteDataSource>(value),
    );
  }
}

String _$alternativesRemoteDataSourceHash() =>
    r'32a14d397ee33d36025928496baea597f8642c56';

/// The alternatives of a medicine (same active ingredient), decoded to [Medicine]
/// so the UI reuses the existing model (brand name, manufacturer, priced units).

@ProviderFor(medicineAlternatives)
final medicineAlternativesProvider = MedicineAlternativesFamily._();

/// The alternatives of a medicine (same active ingredient), decoded to [Medicine]
/// so the UI reuses the existing model (brand name, manufacturer, priced units).

final class MedicineAlternativesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Medicine>>,
          List<Medicine>,
          FutureOr<List<Medicine>>
        >
    with $FutureModifier<List<Medicine>>, $FutureProvider<List<Medicine>> {
  /// The alternatives of a medicine (same active ingredient), decoded to [Medicine]
  /// so the UI reuses the existing model (brand name, manufacturer, priced units).
  MedicineAlternativesProvider._({
    required MedicineAlternativesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicineAlternativesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicineAlternativesHash();

  @override
  String toString() {
    return r'medicineAlternativesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Medicine>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Medicine>> create(Ref ref) {
    final argument = this.argument as String;
    return medicineAlternatives(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicineAlternativesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicineAlternativesHash() =>
    r'297b79fd85fb84add1e9047eea7c92ab040a08cc';

/// The alternatives of a medicine (same active ingredient), decoded to [Medicine]
/// so the UI reuses the existing model (brand name, manufacturer, priced units).

final class MedicineAlternativesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Medicine>>, String> {
  MedicineAlternativesFamily._()
    : super(
        retry: null,
        name: r'medicineAlternativesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The alternatives of a medicine (same active ingredient), decoded to [Medicine]
  /// so the UI reuses the existing model (brand name, manufacturer, priced units).

  MedicineAlternativesProvider call(String medicineId) =>
      MedicineAlternativesProvider._(argument: medicineId, from: this);

  @override
  String toString() => r'medicineAlternativesProvider';
}
