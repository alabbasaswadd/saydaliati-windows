import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/errors/failure.dart';
import 'package:saydaliati/features/shortcuts/domain/entities/shortcut_binding.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/shortcut_providers.dart';

/// مسوّدة شاشة الاختصارات: تُحرَّر محلياً ثم تُحفظ دفعة واحدة.
class ShortcutsDraft {
  const ShortcutsDraft({
    this.bindings = const [],
    this.loading = true,
    this.saving = false,
    this.failure,
  });

  final List<ShortcutBinding> bindings;
  final bool loading;
  final bool saving;
  final Failure? failure;

  /// هل في المسوّدة تغييرٌ غير محفوظ؟
  bool dirtyAgainst(List<ShortcutBinding> saved) {
    if (saved.length != bindings.length) return true;
    final savedByAction = {for (final b in saved) b.action: b};
    for (final b in bindings) {
      if (savedByAction[b.action] != b) return true;
    }
    return false;
  }

  /// التركيبات المستخدَمة أكثر من مرّة — تمنع الحفظ وتُبرَز بالأحمر.
  Set<KeyCombo> get conflicts {
    final seen = <KeyCombo, int>{};
    for (final b in bindings.where((b) => b.isEnabled)) {
      seen[b.combo] = (seen[b.combo] ?? 0) + 1;
    }
    return {
      for (final e in seen.entries)
        if (e.value > 1) e.key,
    };
  }

  /// الإجراء الآخر الذي يستعمل [combo] (لعرض اسمه في رسالة التعارض).
  ShortcutAction? conflictingWith(ShortcutAction action, KeyCombo combo) {
    for (final b in bindings) {
      if (b.action != action && b.isEnabled && b.combo == combo) {
        return b.action;
      }
    }
    return null;
  }

  ShortcutsDraft copyWith({
    List<ShortcutBinding>? bindings,
    bool? loading,
    bool? saving,
    Failure? failure,
    bool clearFailure = false,
  }) =>
      ShortcutsDraft(
        bindings: bindings ?? this.bindings,
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        failure: clearFailure ? null : (failure ?? this.failure),
      );
}

class ShortcutsController extends Notifier<ShortcutsDraft> {
  @override
  ShortcutsDraft build() {
    _load();
    return const ShortcutsDraft();
  }

  Future<void> _load() async {
    try {
      final list = await ref.read(shortcutBindingsProvider.future);
      state = ShortcutsDraft(bindings: list, loading: false);
    } on Failure catch (f) {
      state = ShortcutsDraft(bindings: const [], loading: false, failure: f);
    }
  }

  /// يغيّر تركيبة إجراء. تطابُقها مع الافتراضي يُسقِط صفة «مخصَّص» فيُحذف
  /// تخصيصه عند الحفظ.
  void setCombo(ShortcutAction action, KeyCombo combo) {
    _update(action, (b) {
      final isDefault = combo == action.defaultKeyCombo && b.isEnabled;
      return b.copyWith(combo: combo, isCustom: !isDefault);
    });
  }

  void setEnabled(ShortcutAction action, bool enabled) {
    _update(action, (b) {
      final isDefault = enabled && b.combo == action.defaultKeyCombo;
      return b.copyWith(isEnabled: enabled, isCustom: !isDefault);
    });
  }

  /// يعيد إجراءً واحداً لافتراضيّه.
  void resetOne(ShortcutAction action) =>
      _update(action, (_) => ShortcutBinding.fromDefault(action));

  /// يعيد كل الإجراءات لافتراضيّها في المسوّدة (الحفظ هو ما يُثبّتها).
  void resetAll() {
    state = state.copyWith(
      bindings: [
        for (final a in ShortcutAction.values) ShortcutBinding.fromDefault(a),
      ],
      clearFailure: true,
    );
  }

  void _update(
      ShortcutAction action, ShortcutBinding Function(ShortcutBinding) change) {
    state = state.copyWith(
      bindings: [
        for (final b in state.bindings) b.action == action ? change(b) : b,
      ],
      clearFailure: true,
    );
  }

  /// يحفظ المسوّدة. يعيد `null` عند النجاح، أو سبب الفشل.
  Future<Failure?> save() async {
    if (state.conflicts.isNotEmpty) return null;

    state = state.copyWith(saving: true, clearFailure: true);
    final result =
        await ref.read(shortcutRepositoryProvider).save(state.bindings);

    return result.fold(
      (saved) {
        state = ShortcutsDraft(bindings: saved, loading: false);
        // الموزِّع العام يقرأ من هذا المزوِّد — تحديثه يُفعِّل الجديد فوراً.
        ref.invalidate(shortcutBindingsProvider);
        return null;
      },
      (failure) {
        state = state.copyWith(saving: false, failure: failure);
        return failure;
      },
    );
  }
}

/// Riverpod 3: المزوِّدات تتخلّص من نفسها تلقائياً عند انتهاء آخر مستمع —
/// فالمسوّدة تُبنى من جديد في كل زيارة للشاشة بلا بقايا تحرير سابق.
final shortcutsControllerProvider =
    NotifierProvider<ShortcutsController, ShortcutsDraft>(
  ShortcutsController.new,
);
