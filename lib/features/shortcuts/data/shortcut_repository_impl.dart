import 'dart:convert';

import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/shortcuts/data/shortcut_remote_data_source.dart';
import 'package:saydaliati/features/shortcuts/domain/entities/shortcut_binding.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/repositories/shortcut_repository.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortcutRepositoryImpl implements ShortcutRepository {
  const ShortcutRepositoryImpl(this._remote);

  final ShortcutRemoteDataSource _remote;

  /// مرآة محلّية صغيرة (JSON) حتى تعمل الاختصارات فوراً عند الإقلاع ودون اتصال
  /// — الحمولة بضعة أسطر، فلا داعي لجدول في قاعدة البيانات.
  static const _cacheKey = 'shortcuts_overrides_v1';

  @override
  Future<Result<List<ShortcutBinding>>> getBindings() async {
    try {
      final raw = await _remote.list();
      await _cache(raw);
      return Result.success(_merge(raw));
    } catch (error) {
      final cached = await _readCache();
      if (cached != null) return Result.success(_merge(cached));
      // لا خادم ولا نسخة محلّية: الافتراضيات تبقى صالحة للعمل.
      return Result.success(_merge(const []));
    }
  }

  @override
  Future<Result<List<ShortcutBinding>>> save(
      List<ShortcutBinding> bindings) async {
    // يُرسَل المخصَّص فقط؛ ما عاد لافتراضيّه يختفي من الدفعة فيُحذف على الخادم.
    final items = [
      for (final b in bindings.where((b) => b.isCustom))
        {
          'actionKey': b.action.id,
          'keys': b.combo.wire,
          'isEnabled': b.isEnabled,
        },
    ];

    try {
      final saved = await _remote.save(items);
      await _cache(saved);
      return Result.success(_merge(saved));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<List<ShortcutBinding>>> resetToDefaults() async {
    try {
      await _remote.reset();
      await _cache(const []);
      return Result.success(_merge(const []));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  // ─── الدمج: الكتالوغ كاملاً، والمخزَّن يَجُبّ الافتراضي ───────────────────

  List<ShortcutBinding> _merge(List<Map<String, dynamic>> stored) {
    final byAction = <String, Map<String, dynamic>>{
      for (final row in stored)
        if (row['actionKey'] is String) row['actionKey'] as String: row,
    };

    return [
      for (final action in ShortcutAction.values)
        _bindingFor(action, byAction[action.id]),
    ];
  }

  ShortcutBinding _bindingFor(ShortcutAction action, Map<String, dynamic>? row) {
    if (row == null) return ShortcutBinding.fromDefault(action);

    // تركيبة تالفة أو غير مدعومة ⇐ تُهمَل ويعود الإجراء لافتراضيّه بدل أن
    // يصبح بلا اختصار يعمل.
    final combo = KeyCombo.parse(row['keys'] as String?);
    if (combo == null) return ShortcutBinding.fromDefault(action);

    final enabled = row['isEnabled'] is bool ? row['isEnabled'] as bool : true;
    // صفّ مخزَّن يطابق الافتراضي (بعد تغيير الافتراضيات مثلاً) ليس تخصيصاً —
    // فلا يُعرَض بعلامة «مخصَّص» ولا بزر إرجاع لا يفعل شيئاً.
    final matchesDefault = enabled && combo == action.defaultKeyCombo;
    return ShortcutBinding(
      action: action,
      combo: combo,
      isEnabled: enabled,
      isCustom: !matchesDefault,
    );
  }

  // ─── المرآة المحلّية ─────────────────────────────────────────────────────

  Future<void> _cache(List<Map<String, dynamic>> rows) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(rows));
    } catch (_) {
      // التخزين المحلّي رفاهية هنا — فشله لا يمنع عمل الاختصارات.
    }
  }

  Future<List<Map<String, dynamic>>?> _readCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.whereType<Map<String, dynamic>>().toList();
    } catch (_) {
      return null;
    }
  }
}
