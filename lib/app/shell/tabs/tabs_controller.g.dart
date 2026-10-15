// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(OpenTabs)
final openTabsProvider = OpenTabsProvider._();

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
final class OpenTabsProvider extends $NotifierProvider<OpenTabs, TabsState> {
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
  OpenTabsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openTabsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openTabsHash();

  @$internal
  @override
  OpenTabs create() => OpenTabs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TabsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TabsState>(value),
    );
  }
}

String _$openTabsHash() => r'75d76116bae781973574fb50e8cc1911e4a04de5';

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

abstract class _$OpenTabs extends $Notifier<TabsState> {
  TabsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TabsState, TabsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TabsState, TabsState>,
              TabsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
