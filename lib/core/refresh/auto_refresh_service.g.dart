// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_refresh_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// يُعيد تحميل البيانات المالية والإدارية كل 5 دقائق تلقائياً ما دام التطبيق
/// مفتوحاً، دون الحاجة لأي تدخّل من المستخدم.
///
/// البيانات الثقيلة (الأدوية/المخزون) تُحدَّث بالمزامنة الكاملة [DataSyncController]
/// ولا تُكرَّر هنا — ما يُحدَّث هنا فقط ما يتغيّر بكثرة خلال ساعات العمل.

@ProviderFor(AutoRefreshService)
final autoRefreshServiceProvider = AutoRefreshServiceProvider._();

/// يُعيد تحميل البيانات المالية والإدارية كل 5 دقائق تلقائياً ما دام التطبيق
/// مفتوحاً، دون الحاجة لأي تدخّل من المستخدم.
///
/// البيانات الثقيلة (الأدوية/المخزون) تُحدَّث بالمزامنة الكاملة [DataSyncController]
/// ولا تُكرَّر هنا — ما يُحدَّث هنا فقط ما يتغيّر بكثرة خلال ساعات العمل.
final class AutoRefreshServiceProvider
    extends $NotifierProvider<AutoRefreshService, void> {
  /// يُعيد تحميل البيانات المالية والإدارية كل 5 دقائق تلقائياً ما دام التطبيق
  /// مفتوحاً، دون الحاجة لأي تدخّل من المستخدم.
  ///
  /// البيانات الثقيلة (الأدوية/المخزون) تُحدَّث بالمزامنة الكاملة [DataSyncController]
  /// ولا تُكرَّر هنا — ما يُحدَّث هنا فقط ما يتغيّر بكثرة خلال ساعات العمل.
  AutoRefreshServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoRefreshServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoRefreshServiceHash();

  @$internal
  @override
  AutoRefreshService create() => AutoRefreshService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$autoRefreshServiceHash() =>
    r'7f66990f04e5d2792d3972825824f6e48e4b32c8';

/// يُعيد تحميل البيانات المالية والإدارية كل 5 دقائق تلقائياً ما دام التطبيق
/// مفتوحاً، دون الحاجة لأي تدخّل من المستخدم.
///
/// البيانات الثقيلة (الأدوية/المخزون) تُحدَّث بالمزامنة الكاملة [DataSyncController]
/// ولا تُكرَّر هنا — ما يُحدَّث هنا فقط ما يتغيّر بكثرة خلال ساعات العمل.

abstract class _$AutoRefreshService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
