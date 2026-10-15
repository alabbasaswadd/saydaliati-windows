import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/app/shell/tabs/app_tab.dart';
import 'package:saydaliati/app/shell/tabs/nav_catalog.dart';

part 'tabs_controller.g.dart';

/// حالة التابّات: القائمة والتابّ النشِط.
class TabsState {
  const TabsState({required this.tabs, required this.activeId});

  final List<AppTab> tabs;
  final String? activeId;

  AppTab? get active =>
      tabs.where((t) => t.id == activeId).firstOrNull;

  static const empty = TabsState(tabs: [], activeId: null);
}

/// التابّات المفتوحة على مستوى التطبيق.
///
/// **كيف تُحفظ البيانات:** كل فرع في `StatefulShellRoute.indexedStack` يبقى
/// حيّاً بحالته بعد أوّل زيارة — فالصفحة لا تُبنى من جديد عند العودة إليها.
/// التابّ ليس وعاءً للحالة بل **إشارة إلى صفحة ما زالت حيّة**، ولذلك
/// الانتقال فوريّ: لا إعادة بناء ولا إعادة تحميل، والمتحكّم يبقى قائمةً
/// خفيفة من المسارات.
///
/// **التابّ يُولَد فارغاً:** «+» يُنشئ تابّاً بلا صفحة، ثم يختار صاحبه ما
/// يشاء من القائمة الجانبية فيسكن التابَّ. وما يُنتقَل إليه بعد ذلك يحلّ
/// في **التابّ النشِط نفسه** لا في تابٍّ جديد — وإلّا تكاثرت التابّات بكل
/// نقرة.
@Riverpod(keepAlive: true)
class OpenTabs extends _$OpenTabs {
  var _seq = 0;

  @override
  TabsState build() => TabsState.empty;

  String _nextId() => 't${_seq++}';

  /// تابٌّ جديد فارغ، ويصبح النشِط.
  AppTab newTab() {
    final tab = AppTab(id: _nextId());
    state = TabsState(tabs: [...state.tabs, tab], activeId: tab.id);
    return tab;
  }

  /// يُنشّط تابّاً موجوداً.
  void activate(String id) {
    if (state.activeId == id) return;
    if (!state.tabs.any((t) => t.id == id)) return;
    state = TabsState(tabs: state.tabs, activeId: id);
  }

  /// تابٌّ يحمل صفحةً من الآن — يُستعمل لـ«Ctrl + نقر» (يُفتَح في الخلف
  /// فلا يُنشَّط) وللتابّ الأوّل عند الإقلاع.
  AppTab openWith(String location, {int? branchIndex, bool activate = true}) {
    final tab = _describe(AppTab(id: _nextId()), location, branchIndex);
    state = TabsState(
      tabs: [...state.tabs, tab],
      activeId: activate ? tab.id : state.activeId,
    );
    return tab;
  }

  /// يُسكِن المسارَ **التابَّ النشِط**: هذا ما يجعل التنقّل العادي يبقى داخل
  /// التابّ الواحد. يُنشئ تابّاً إن لم يكن ثمّة نشِط (أوّل إقلاع).
  void assignToActive(String location, {int? branchIndex}) {
    final active = state.active;
    if (active == null) {
      openWith(location, branchIndex: branchIndex);
      return;
    }

    if (active.location == location && active.branchIndex == branchIndex) return;

    final updated = _describe(active, location, branchIndex);
    state = TabsState(
      tabs: [
        for (final t in state.tabs) t.id == active.id ? updated : t,
      ],
      activeId: state.activeId,
    );
  }

  /// يُغلق تابّاً ويُنشّط جاره. يعيد التابّ الذي صار نشِطاً (أو `null`).
  ///
  /// الإغلاق يرفع الإشارة لا الصفحة: الفرع يبقى حيّاً بحالته، فلو أُعيد
  /// فتح الصفحة ظهرت كما تُركت. محو الحالة عند الإغلاق كان سيُفقد فاتورةً
  /// نصف مكتوبة بنقرةٍ لا رجعة فيها.
  AppTab? close(String id) {
    final index = state.tabs.indexWhere((t) => t.id == id);
    if (index < 0) return null;

    final remaining = [...state.tabs]..removeAt(index);
    if (remaining.isEmpty) {
      state = TabsState.empty;
      return null;
    }

    final wasActive = state.activeId == id;
    final neighbour = remaining[index > 0 ? index - 1 : 0];

    state = TabsState(
      tabs: remaining,
      activeId: wasActive ? neighbour.id : state.activeId,
    );

    return wasActive ? neighbour : null;
  }

  void closeOthers(String keepId) {
    final keep = state.tabs.where((t) => t.id == keepId).toList();
    if (keep.isEmpty) return;
    state = TabsState(tabs: keep, activeId: keepId);
  }

  void closeAll() => state = TabsState.empty;

  /// نقل تابّ — الترتيب جزء من الحالة لا من العرض (سحب وإفلات مستقبلاً).
  void reorder(int from, int to) {
    if (from == to) return;
    final list = [...state.tabs];
    final tab = list.removeAt(from);
    list.insert(to > from ? to - 1 : to, tab);
    state = TabsState(tabs: list, activeId: state.activeId);
  }

  /// يملأ عنوان التابّ وأيقونته من فهرس المسارات.
  static AppTab _describe(AppTab tab, String location, int? branchIndex) {
    final entry = navEntryFor(location);
    return AppTab(
      id: tab.id,
      location: location,
      // مسار بلا مدخل في الفهرس يأخذ آخر مقطع من عنوانه: عنوانٌ ناقص أهون
      // من تابٍّ بلا عنوان.
      title: entry?.title ?? _fallbackTitle(location),
      icon: entry?.icon,
      branchIndex: branchIndex ?? tab.branchIndex,
    );
  }

  static String _fallbackTitle(String location) {
    final parts = location.split('/').where((p) => p.isNotEmpty);
    return parts.isEmpty ? 'صفحة' : parts.last;
  }
}
