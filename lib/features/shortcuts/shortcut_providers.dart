import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/shortcuts/data/shortcut_remote_data_source.dart';
import 'package:saydaliati/features/shortcuts/data/shortcut_repository_impl.dart';
import 'package:saydaliati/features/shortcuts/domain/entities/shortcut_binding.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/repositories/shortcut_repository.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcut_dispatcher.dart';

part 'shortcut_providers.g.dart';

/// جذر تركيب ميزة الاختصارات.

@riverpod
ShortcutRemoteDataSource shortcutRemoteDataSource(Ref ref) =>
    ShortcutRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
ShortcutRepository shortcutRepository(Ref ref) =>
    ShortcutRepositoryImpl(ref.watch(shortcutRemoteDataSourceProvider));

/// الاختصارات الفعّالة لكل الإجراءات (مدموجة مع الافتراضيات).
///
/// `keepAlive` لأن الموزِّع العام يقرأها على كل ضغطة مفتاح — لا نريد إعادة
/// تحميلها كلّما خرجت شاشة الإعدادات من الشجرة.
@Riverpod(keepAlive: true)
Future<List<ShortcutBinding>> shortcutBindings(Ref ref) async {
  final result = await ref.watch(shortcutRepositoryProvider).getBindings();
  return result.fold((list) => list, (failure) => throw failure);
}

/// خريطة التركيبة ← الإجراء، للبحث السريع داخل معالج المفاتيح.
/// المعطَّل لا يدخل الخريطة، فلا يستجيب لمفاتيحه.
@Riverpod(keepAlive: true)
Map<KeyCombo, ShortcutAction> shortcutLookup(Ref ref) {
  final bindings = ref.watch(shortcutBindingsProvider).value;
  if (bindings == null) {
    // قبل وصول الحالة من الخادم تعمل الافتراضيات — فلا فترة «ميتة» عند الإقلاع.
    return {
      for (final a in ShortcutAction.values) a.defaultKeyCombo: a,
    };
  }
  return {
    for (final b in bindings)
      if (b.isEnabled) b.combo: b.action,
  };
}

/// سجلّ معالجات الشاشات — حيّ طوال عمر التطبيق: تسجّل فيه الشاشات معالجاتها،
/// ويقرأه الموزِّع لحظة ضغط المفتاح. تخلُّصه من نفسه كان سيُفقد التسجيلات.
@Riverpod(keepAlive: true)
ShortcutHandlers shortcutHandlers(Ref ref) => ShortcutHandlers();
