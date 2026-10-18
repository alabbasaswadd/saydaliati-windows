import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/cache/json_entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// نسخةٌ محلّية من دليل الحسابات (خرائط السلك كما جاءت).
///
/// الدليل مطلوبٌ في كل سندٍ وفاتورةٍ آجلة لاختيار حساب الصندوق أو الطرف،
/// فانقطاعُ الشبكة كان يُفرِغ قائمة الحسابات ويُعطّل الشاشات التي تعتمدها.
/// ويُخزَّن في جدول الكاش العامّ نفسه ([CacheEntries]) فلا يحتاج ترقية
/// مخطَّطٍ ولا جدولاً جديداً.
class AccountLocalDataSource {
  AccountLocalDataSource({required AppDatabase db, required String tenantId})
      : _cache = jsonEntityCache(
          db: db,
          tenantId: tenantId,
          entityType: 'accounts',
          nameOf: (m) => m['name'] as String?,
          codeOf: (m) => m['code'] as String?,
          parentOf: (m) => m['parentId'] as String?,
        );

  final EntityCache<Map<String, dynamic>> _cache;

  Future<List<Map<String, dynamic>>> getAll() => _cache.getAll();

  Future<void> replaceAll(List<Map<String, dynamic>> items) =>
      _cache.replaceAll(items);
}
