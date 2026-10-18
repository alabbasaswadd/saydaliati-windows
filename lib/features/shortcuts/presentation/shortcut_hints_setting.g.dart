// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_hints_setting.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// إظهار شريط تلميحات اختصارات الفاتورة على الشاشة.
///
/// **محلّي لا على الخادم** عن قصد: هذا تفضيل عرضٍ لجهازٍ بعينه لا سياسة
/// صيدلية. فكاشير جديد يُبقيه ظاهراً حتى يحفظ الاختصارات، وآخر مُتمكِّن
/// يُخفيه ليكسب سطراً من الشاشة — ولا معنى لمزامنة ذلك بين الأجهزة.
///
/// الافتراضي **ظاهر**: الاختصارات ميزةٌ لا يعرفها مَن لا يراها، وإخفاؤها
/// افتراضياً يجعلها حبيسة شاشة الإعدادات.

@ProviderFor(ShowShortcutHints)
final showShortcutHintsProvider = ShowShortcutHintsProvider._();

/// إظهار شريط تلميحات اختصارات الفاتورة على الشاشة.
///
/// **محلّي لا على الخادم** عن قصد: هذا تفضيل عرضٍ لجهازٍ بعينه لا سياسة
/// صيدلية. فكاشير جديد يُبقيه ظاهراً حتى يحفظ الاختصارات، وآخر مُتمكِّن
/// يُخفيه ليكسب سطراً من الشاشة — ولا معنى لمزامنة ذلك بين الأجهزة.
///
/// الافتراضي **ظاهر**: الاختصارات ميزةٌ لا يعرفها مَن لا يراها، وإخفاؤها
/// افتراضياً يجعلها حبيسة شاشة الإعدادات.
final class ShowShortcutHintsProvider
    extends $NotifierProvider<ShowShortcutHints, bool> {
  /// إظهار شريط تلميحات اختصارات الفاتورة على الشاشة.
  ///
  /// **محلّي لا على الخادم** عن قصد: هذا تفضيل عرضٍ لجهازٍ بعينه لا سياسة
  /// صيدلية. فكاشير جديد يُبقيه ظاهراً حتى يحفظ الاختصارات، وآخر مُتمكِّن
  /// يُخفيه ليكسب سطراً من الشاشة — ولا معنى لمزامنة ذلك بين الأجهزة.
  ///
  /// الافتراضي **ظاهر**: الاختصارات ميزةٌ لا يعرفها مَن لا يراها، وإخفاؤها
  /// افتراضياً يجعلها حبيسة شاشة الإعدادات.
  ShowShortcutHintsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showShortcutHintsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showShortcutHintsHash();

  @$internal
  @override
  ShowShortcutHints create() => ShowShortcutHints();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showShortcutHintsHash() => r'9afffd2e66c9206b9ef4a1774b34dafe390cf568';

/// إظهار شريط تلميحات اختصارات الفاتورة على الشاشة.
///
/// **محلّي لا على الخادم** عن قصد: هذا تفضيل عرضٍ لجهازٍ بعينه لا سياسة
/// صيدلية. فكاشير جديد يُبقيه ظاهراً حتى يحفظ الاختصارات، وآخر مُتمكِّن
/// يُخفيه ليكسب سطراً من الشاشة — ولا معنى لمزامنة ذلك بين الأجهزة.
///
/// الافتراضي **ظاهر**: الاختصارات ميزةٌ لا يعرفها مَن لا يراها، وإخفاؤها
/// افتراضياً يجعلها حبيسة شاشة الإعدادات.

abstract class _$ShowShortcutHints extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
