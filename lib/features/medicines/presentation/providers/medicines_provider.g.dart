// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicines_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The whole medicine catalog as an [AsyncValue] (cache-first). Shared by the
/// medicines list screen and the POS (scanning + manual picker). Kept alive so
/// the (now large) catalog stays warm in memory and isn't re-fetched on every
/// navigation; call [MedicineCatalog.refreshOne] to patch a single row after an
/// edit instead of invalidating (which would re-pull everything).

@ProviderFor(MedicineCatalog)
final medicineCatalogProvider = MedicineCatalogProvider._();

/// The whole medicine catalog as an [AsyncValue] (cache-first). Shared by the
/// medicines list screen and the POS (scanning + manual picker). Kept alive so
/// the (now large) catalog stays warm in memory and isn't re-fetched on every
/// navigation; call [MedicineCatalog.refreshOne] to patch a single row after an
/// edit instead of invalidating (which would re-pull everything).
final class MedicineCatalogProvider
    extends $AsyncNotifierProvider<MedicineCatalog, List<Medicine>> {
  /// The whole medicine catalog as an [AsyncValue] (cache-first). Shared by the
  /// medicines list screen and the POS (scanning + manual picker). Kept alive so
  /// the (now large) catalog stays warm in memory and isn't re-fetched on every
  /// navigation; call [MedicineCatalog.refreshOne] to patch a single row after an
  /// edit instead of invalidating (which would re-pull everything).
  MedicineCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineCatalogHash();

  @$internal
  @override
  MedicineCatalog create() => MedicineCatalog();
}

String _$medicineCatalogHash() => r'702bb6c20bd319aefc4e8d845f8d574485f5dca5';

/// The whole medicine catalog as an [AsyncValue] (cache-first). Shared by the
/// medicines list screen and the POS (scanning + manual picker). Kept alive so
/// the (now large) catalog stays warm in memory and isn't re-fetched on every
/// navigation; call [MedicineCatalog.refreshOne] to patch a single row after an
/// edit instead of invalidating (which would re-pull everything).

abstract class _$MedicineCatalog extends $AsyncNotifier<List<Medicine>> {
  FutureOr<List<Medicine>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Medicine>>, List<Medicine>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Medicine>>, List<Medicine>>,
              AsyncValue<List<Medicine>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
