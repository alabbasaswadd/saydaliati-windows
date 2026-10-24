// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogRemoteDataSource)
final catalogRemoteDataSourceProvider = CatalogRemoteDataSourceProvider._();

final class CatalogRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CatalogRemoteDataSource,
          CatalogRemoteDataSource,
          CatalogRemoteDataSource
        >
    with $Provider<CatalogRemoteDataSource> {
  CatalogRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CatalogRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRemoteDataSource create(Ref ref) {
    return catalogRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRemoteDataSource>(value),
    );
  }
}

String _$catalogRemoteDataSourceHash() =>
    r'158fb09262c4bff4254c368e373ad2f9bd67d7c1';

/// On-device mirror of the global catalog (shared 'global' key).

@ProviderFor(catalogLocalDataSource)
final catalogLocalDataSourceProvider = CatalogLocalDataSourceProvider._();

/// On-device mirror of the global catalog (shared 'global' key).

final class CatalogLocalDataSourceProvider
    extends
        $FunctionalProvider<
          CatalogLocalDataSource,
          CatalogLocalDataSource,
          CatalogLocalDataSource
        >
    with $Provider<CatalogLocalDataSource> {
  /// On-device mirror of the global catalog (shared 'global' key).
  CatalogLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CatalogLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogLocalDataSource create(Ref ref) {
    return catalogLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogLocalDataSource>(value),
    );
  }
}

String _$catalogLocalDataSourceHash() =>
    r'090d54a683660dd88240542f63f379ecfb8ed1ed';

/// Throttled (6h) sync service that mirrors the catalog into the local DB.

@ProviderFor(catalogSyncService)
final catalogSyncServiceProvider = CatalogSyncServiceProvider._();

/// Throttled (6h) sync service that mirrors the catalog into the local DB.

final class CatalogSyncServiceProvider
    extends
        $FunctionalProvider<
          CatalogSyncService,
          CatalogSyncService,
          CatalogSyncService
        >
    with $Provider<CatalogSyncService> {
  /// Throttled (6h) sync service that mirrors the catalog into the local DB.
  CatalogSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogSyncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogSyncServiceHash();

  @$internal
  @override
  $ProviderElement<CatalogSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogSyncService create(Ref ref) {
    return catalogSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogSyncService>(value),
    );
  }
}

String _$catalogSyncServiceHash() =>
    r'66428ddfa6277a4ee5f5aa2038fc4de9b1402cb2';

/// Whether the on-device global-catalog mirror is still empty (never downloaded
/// on this device). Drives the **one-time** first-load overlay: it is `true`
/// only before the very first catalog download, and `false` on every later
/// launch (the mirror persists on disk). Invalidated after a sync fills it.

@ProviderFor(catalogMirrorEmpty)
final catalogMirrorEmptyProvider = CatalogMirrorEmptyProvider._();

/// Whether the on-device global-catalog mirror is still empty (never downloaded
/// on this device). Drives the **one-time** first-load overlay: it is `true`
/// only before the very first catalog download, and `false` on every later
/// launch (the mirror persists on disk). Invalidated after a sync fills it.

final class CatalogMirrorEmptyProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the on-device global-catalog mirror is still empty (never downloaded
  /// on this device). Drives the **one-time** first-load overlay: it is `true`
  /// only before the very first catalog download, and `false` on every later
  /// launch (the mirror persists on disk). Invalidated after a sync fills it.
  CatalogMirrorEmptyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogMirrorEmptyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogMirrorEmptyHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return catalogMirrorEmpty(ref);
  }
}

String _$catalogMirrorEmptyHash() =>
    r'7b9f14a78547c1520b76e700416ddc27b2942c46';

/// Search the catalog. **Offline-first**: if the local mirror is warm it serves
/// from the device (works with no network); otherwise it falls back to the API.

@ProviderFor(catalogSearch)
final catalogSearchProvider = CatalogSearchFamily._();

/// Search the catalog. **Offline-first**: if the local mirror is warm it serves
/// from the device (works with no network); otherwise it falls back to the API.

final class CatalogSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogItem>>,
          List<CatalogItem>,
          FutureOr<List<CatalogItem>>
        >
    with
        $FutureModifier<List<CatalogItem>>,
        $FutureProvider<List<CatalogItem>> {
  /// Search the catalog. **Offline-first**: if the local mirror is warm it serves
  /// from the device (works with no network); otherwise it falls back to the API.
  CatalogSearchProvider._({
    required CatalogSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catalogSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogSearchHash();

  @override
  String toString() {
    return r'catalogSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogItem>> create(Ref ref) {
    final argument = this.argument as String;
    return catalogSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogSearchHash() => r'3a669ddaa05c62acb73dac869cd762c1d3f44d3e';

/// Search the catalog. **Offline-first**: if the local mirror is warm it serves
/// from the device (works with no network); otherwise it falls back to the API.

final class CatalogSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CatalogItem>>, String> {
  CatalogSearchFamily._()
    : super(
        retry: null,
        name: r'catalogSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Search the catalog. **Offline-first**: if the local mirror is warm it serves
  /// from the device (works with no network); otherwise it falls back to the API.

  CatalogSearchProvider call(String query) =>
      CatalogSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'catalogSearchProvider';
}

/// Manufacturers (الشركات) with counts, for the "group by company" view.
/// **Offline-first**: served from the local mirror when warm, else the API.

@ProviderFor(catalogManufacturers)
final catalogManufacturersProvider = CatalogManufacturersProvider._();

/// Manufacturers (الشركات) with counts, for the "group by company" view.
/// **Offline-first**: served from the local mirror when warm, else the API.

final class CatalogManufacturersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogManufacturer>>,
          List<CatalogManufacturer>,
          FutureOr<List<CatalogManufacturer>>
        >
    with
        $FutureModifier<List<CatalogManufacturer>>,
        $FutureProvider<List<CatalogManufacturer>> {
  /// Manufacturers (الشركات) with counts, for the "group by company" view.
  /// **Offline-first**: served from the local mirror when warm, else the API.
  CatalogManufacturersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogManufacturersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogManufacturersHash();

  @$internal
  @override
  $FutureProviderElement<List<CatalogManufacturer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogManufacturer>> create(Ref ref) {
    return catalogManufacturers(ref);
  }
}

String _$catalogManufacturersHash() =>
    r'4b0eac8f5cac543d55ebdc31731eec7caba5a111';

/// All catalog items for one manufacturer. **Offline-first**.

@ProviderFor(catalogByManufacturer)
final catalogByManufacturerProvider = CatalogByManufacturerFamily._();

/// All catalog items for one manufacturer. **Offline-first**.

final class CatalogByManufacturerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogItem>>,
          List<CatalogItem>,
          FutureOr<List<CatalogItem>>
        >
    with
        $FutureModifier<List<CatalogItem>>,
        $FutureProvider<List<CatalogItem>> {
  /// All catalog items for one manufacturer. **Offline-first**.
  CatalogByManufacturerProvider._({
    required CatalogByManufacturerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catalogByManufacturerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogByManufacturerHash();

  @override
  String toString() {
    return r'catalogByManufacturerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogItem>> create(Ref ref) {
    final argument = this.argument as String;
    return catalogByManufacturer(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogByManufacturerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogByManufacturerHash() =>
    r'4d0a4c5d19029965c980e793efddc3410dbeeb51';

/// All catalog items for one manufacturer. **Offline-first**.

final class CatalogByManufacturerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CatalogItem>>, String> {
  CatalogByManufacturerFamily._()
    : super(
        retry: null,
        name: r'catalogByManufacturerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All catalog items for one manufacturer. **Offline-first**.

  CatalogByManufacturerProvider call(String manufacturer) =>
      CatalogByManufacturerProvider._(argument: manufacturer, from: this);

  @override
  String toString() => r'catalogByManufacturerProvider';
}

/// Alternatives (same active ingredient) of a catalog item, from the catalog.

@ProviderFor(catalogItemAlternatives)
final catalogItemAlternativesProvider = CatalogItemAlternativesFamily._();

/// Alternatives (same active ingredient) of a catalog item, from the catalog.

final class CatalogItemAlternativesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogItem>>,
          List<CatalogItem>,
          FutureOr<List<CatalogItem>>
        >
    with
        $FutureModifier<List<CatalogItem>>,
        $FutureProvider<List<CatalogItem>> {
  /// Alternatives (same active ingredient) of a catalog item, from the catalog.
  CatalogItemAlternativesProvider._({
    required CatalogItemAlternativesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catalogItemAlternativesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogItemAlternativesHash();

  @override
  String toString() {
    return r'catalogItemAlternativesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogItem>> create(Ref ref) {
    final argument = this.argument as String;
    return catalogItemAlternatives(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogItemAlternativesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogItemAlternativesHash() =>
    r'79d9ad4911e556fdde716d8b36b1b90f8c91f7b6';

/// Alternatives (same active ingredient) of a catalog item, from the catalog.

final class CatalogItemAlternativesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CatalogItem>>, String> {
  CatalogItemAlternativesFamily._()
    : super(
        retry: null,
        name: r'catalogItemAlternativesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Alternatives (same active ingredient) of a catalog item, from the catalog.

  CatalogItemAlternativesProvider call(String id) =>
      CatalogItemAlternativesProvider._(argument: id, from: this);

  @override
  String toString() => r'catalogItemAlternativesProvider';
}

/// باركودات أدويتي الخاصة — مفروزة من قيم `Medicine.barcode` (قد يحمل الحقل
/// عدّة رموز مفصولة بفاصلة لدواء واحد، انظر `AddCatalogToStockHandler`
/// بالخادم) — لمطابقة أصناف الكاتلوغ المضافة أصلاً إلى أدويتي.

@ProviderFor(myMedicineBarcodes)
final myMedicineBarcodesProvider = MyMedicineBarcodesProvider._();

/// باركودات أدويتي الخاصة — مفروزة من قيم `Medicine.barcode` (قد يحمل الحقل
/// عدّة رموز مفصولة بفاصلة لدواء واحد، انظر `AddCatalogToStockHandler`
/// بالخادم) — لمطابقة أصناف الكاتلوغ المضافة أصلاً إلى أدويتي.

final class MyMedicineBarcodesProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// باركودات أدويتي الخاصة — مفروزة من قيم `Medicine.barcode` (قد يحمل الحقل
  /// عدّة رموز مفصولة بفاصلة لدواء واحد، انظر `AddCatalogToStockHandler`
  /// بالخادم) — لمطابقة أصناف الكاتلوغ المضافة أصلاً إلى أدويتي.
  MyMedicineBarcodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myMedicineBarcodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myMedicineBarcodesHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return myMedicineBarcodes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$myMedicineBarcodesHash() =>
    r'18d30b2c05e29cc525763df33c7023af6fea6599';

/// مفاتيح «اسم+شركة» مطبَّعة لأدويتي — احتياطيّ المطابقة حين لا باركود (شائع
/// فعلاً بالكاتلوغ). كل اسم غير فارغ لدواءٍ (التجاري، العربي، الأجنبي،
/// العلمي) يُولِّد مفتاحاً مستقلاً مقروناً بالشركة، فتكفي مطابقة أيٍّ منها.

@ProviderFor(myMedicineNameManufacturerKeys)
final myMedicineNameManufacturerKeysProvider =
    MyMedicineNameManufacturerKeysProvider._();

/// مفاتيح «اسم+شركة» مطبَّعة لأدويتي — احتياطيّ المطابقة حين لا باركود (شائع
/// فعلاً بالكاتلوغ). كل اسم غير فارغ لدواءٍ (التجاري، العربي، الأجنبي،
/// العلمي) يُولِّد مفتاحاً مستقلاً مقروناً بالشركة، فتكفي مطابقة أيٍّ منها.

final class MyMedicineNameManufacturerKeysProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// مفاتيح «اسم+شركة» مطبَّعة لأدويتي — احتياطيّ المطابقة حين لا باركود (شائع
  /// فعلاً بالكاتلوغ). كل اسم غير فارغ لدواءٍ (التجاري، العربي، الأجنبي،
  /// العلمي) يُولِّد مفتاحاً مستقلاً مقروناً بالشركة، فتكفي مطابقة أيٍّ منها.
  MyMedicineNameManufacturerKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myMedicineNameManufacturerKeysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myMedicineNameManufacturerKeysHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return myMedicineNameManufacturerKeys(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$myMedicineNameManufacturerKeysHash() =>
    r'dcbba7b65acded0e7e8a713f9282dc8e4328b7e7';

/// تقدّم «المضاف من الكاتلوغ إلى أدويتي» — عدد أصناف الكتالوغ المحلي
/// المطابقة لأحد أدويتي (بالباركود أو بالاسم والشركة)، من أصل حجم الكتالوغ
/// المحلي الكامل. `null` إن لم تُزامَن النسخة المحلية بعد (لا معنى لنسبة من
/// صفر).
///
/// يفكّ كامل الكتالوغ المحلي (~٢٢ ألف صفّ) — نفس ما تحمّله شاشة «تصفّح
/// الكل» أصلاً بلا شكوى أداء — لأن مطابقة الاسم تحتاج الحقول منفردة (لا
/// العمود المفهرَس المُدمَج للبحث النصّي).

@ProviderFor(catalogAddedProgress)
final catalogAddedProgressProvider = CatalogAddedProgressProvider._();

/// تقدّم «المضاف من الكاتلوغ إلى أدويتي» — عدد أصناف الكتالوغ المحلي
/// المطابقة لأحد أدويتي (بالباركود أو بالاسم والشركة)، من أصل حجم الكتالوغ
/// المحلي الكامل. `null` إن لم تُزامَن النسخة المحلية بعد (لا معنى لنسبة من
/// صفر).
///
/// يفكّ كامل الكتالوغ المحلي (~٢٢ ألف صفّ) — نفس ما تحمّله شاشة «تصفّح
/// الكل» أصلاً بلا شكوى أداء — لأن مطابقة الاسم تحتاج الحقول منفردة (لا
/// العمود المفهرَس المُدمَج للبحث النصّي).

final class CatalogAddedProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<({int added, int total})?>,
          ({int added, int total})?,
          FutureOr<({int added, int total})?>
        >
    with
        $FutureModifier<({int added, int total})?>,
        $FutureProvider<({int added, int total})?> {
  /// تقدّم «المضاف من الكاتلوغ إلى أدويتي» — عدد أصناف الكتالوغ المحلي
  /// المطابقة لأحد أدويتي (بالباركود أو بالاسم والشركة)، من أصل حجم الكتالوغ
  /// المحلي الكامل. `null` إن لم تُزامَن النسخة المحلية بعد (لا معنى لنسبة من
  /// صفر).
  ///
  /// يفكّ كامل الكتالوغ المحلي (~٢٢ ألف صفّ) — نفس ما تحمّله شاشة «تصفّح
  /// الكل» أصلاً بلا شكوى أداء — لأن مطابقة الاسم تحتاج الحقول منفردة (لا
  /// العمود المفهرَس المُدمَج للبحث النصّي).
  CatalogAddedProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogAddedProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogAddedProgressHash();

  @$internal
  @override
  $FutureProviderElement<({int added, int total})?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({int added, int total})?> create(Ref ref) {
    return catalogAddedProgress(ref);
  }
}

String _$catalogAddedProgressHash() =>
    r'f6a117f6dbb503cf92c94667b5d34ce00587393a';
