import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';

part 'medicines_provider.g.dart';

/// The whole medicine catalog as an [AsyncValue] (cache-first). Shared by the
/// medicines list screen and the POS (scanning + manual picker). Kept alive so
/// the (now large) catalog stays warm in memory and isn't re-fetched on every
/// navigation; call [MedicineCatalog.refreshOne] to patch a single row after an
/// edit instead of invalidating (which would re-pull everything).
@Riverpod(keepAlive: true)
class MedicineCatalog extends _$MedicineCatalog {
  @override
  Future<List<Medicine>> build() async {
    final repo = ref.watch(medicineRepositoryProvider);
    // Cache-first: if the catalog was already synced once, show it INSTANTLY from
    // the local cache (no loading screen) and refresh from the server silently in
    // the background. The big first-load screen only appears when the cache is
    // empty (the very first time after login).
    final cached = await repo.cachedCatalog();
    if (cached.isNotEmpty) {
      Future.microtask(() async {
        final res = await repo.getCatalog();
        res.fold((list) {
          try {
            state = AsyncData(list);
          } catch (_) {/* provider disposed */}
        }, (_) {/* keep cached on failure */});
      });
      return cached;
    }
    final result = await repo.getCatalog();
    return result.fold((list) => list, (failure) => throw failure);
  }

  /// Refresh ONE medicine after an edit/pricing: fetch just that medicine (and
  /// write it through the cache), then replace it in the in-memory list — no
  /// full-catalog network call. Falls back to a full refresh if it isn't loaded
  /// yet or the single fetch fails.
  Future<void> refreshOne(String id) async {
    final current = state.asData?.value;
    final updated = await ref.read(medicineRepositoryProvider).fetchOne(id);
    if (current == null || updated == null) {
      ref.invalidateSelf();
      return;
    }
    state = AsyncData(_sorted([
      for (final m in current) if (m.id == id) updated else m,
    ]));
  }

  /// After creating a NEW medicine: fetch it from the server (write-through to
  /// the cache) and insert it into the in-memory catalog — no full re-pull — so
  /// it shows immediately and is saved locally. Falls back to a full refresh.
  Future<void> insertNew(String id) async {
    if (id.isEmpty) {
      ref.invalidateSelf();
      return;
    }
    final created = await ref.read(medicineRepositoryProvider).fetchOne(id);
    if (created == null) {
      ref.invalidateSelf();
      return;
    }
    upsert(created);
  }

  /// Patch the in-memory list immediately with an already-known medicine (e.g.
  /// just after linking a barcode or adding one) — no network. Replaces by id or
  /// appends if new, keeping the list sorted by display name.
  void upsert(Medicine medicine) {
    final current = state.asData?.value;
    if (current == null) return;
    final idx = current.indexWhere((m) => m.id == medicine.id);
    final list = [...current];
    if (idx >= 0) {
      list[idx] = medicine;
    } else {
      list.add(medicine);
    }
    state = AsyncData(_sorted(list));
  }

  List<Medicine> _sorted(List<Medicine> list) =>
      list..sort((a, b) => a.displayName.compareTo(b.displayName));

  /// فرض جلب الكتالوغ كاملاً من الخادم الآن (لا يُرضى بالنسخة المحلية
  /// المخزَّنة كما يفعل [build] عادة) ثم كتابته محلياً — زرّ "تحديث" اليدوي
  /// ببوب أب اختيار الدواء، لحالات تغيّر فعلي بمكان آخر لم يصل بعد لهذا الجهاز.
  Future<List<Medicine>> forceRefresh() async {
    final result = await ref.read(medicineRepositoryProvider).getCatalog();
    return result.fold((list) {
      final sorted = _sorted(list);
      state = AsyncData(sorted);
      return sorted;
    }, (failure) => throw failure);
  }
}
