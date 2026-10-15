// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// جذر تركيب ميزة الاختصارات.

@ProviderFor(shortcutRemoteDataSource)
final shortcutRemoteDataSourceProvider = ShortcutRemoteDataSourceProvider._();

/// جذر تركيب ميزة الاختصارات.

final class ShortcutRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ShortcutRemoteDataSource,
          ShortcutRemoteDataSource,
          ShortcutRemoteDataSource
        >
    with $Provider<ShortcutRemoteDataSource> {
  /// جذر تركيب ميزة الاختصارات.
  ShortcutRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ShortcutRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShortcutRemoteDataSource create(Ref ref) {
    return shortcutRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShortcutRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShortcutRemoteDataSource>(value),
    );
  }
}

String _$shortcutRemoteDataSourceHash() =>
    r'3adab96d066fa3742899038c3abeff13e29e08ae';

@ProviderFor(shortcutRepository)
final shortcutRepositoryProvider = ShortcutRepositoryProvider._();

final class ShortcutRepositoryProvider
    extends
        $FunctionalProvider<
          ShortcutRepository,
          ShortcutRepository,
          ShortcutRepository
        >
    with $Provider<ShortcutRepository> {
  ShortcutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShortcutRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShortcutRepository create(Ref ref) {
    return shortcutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShortcutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShortcutRepository>(value),
    );
  }
}

String _$shortcutRepositoryHash() =>
    r'bd4a8b5371c6340ed69b5bca2160a02b263f1c27';

/// الاختصارات الفعّالة لكل الإجراءات (مدموجة مع الافتراضيات).
///
/// `keepAlive` لأن الموزِّع العام يقرأها على كل ضغطة مفتاح — لا نريد إعادة
/// تحميلها كلّما خرجت شاشة الإعدادات من الشجرة.

@ProviderFor(shortcutBindings)
final shortcutBindingsProvider = ShortcutBindingsProvider._();

/// الاختصارات الفعّالة لكل الإجراءات (مدموجة مع الافتراضيات).
///
/// `keepAlive` لأن الموزِّع العام يقرأها على كل ضغطة مفتاح — لا نريد إعادة
/// تحميلها كلّما خرجت شاشة الإعدادات من الشجرة.

final class ShortcutBindingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShortcutBinding>>,
          List<ShortcutBinding>,
          FutureOr<List<ShortcutBinding>>
        >
    with
        $FutureModifier<List<ShortcutBinding>>,
        $FutureProvider<List<ShortcutBinding>> {
  /// الاختصارات الفعّالة لكل الإجراءات (مدموجة مع الافتراضيات).
  ///
  /// `keepAlive` لأن الموزِّع العام يقرأها على كل ضغطة مفتاح — لا نريد إعادة
  /// تحميلها كلّما خرجت شاشة الإعدادات من الشجرة.
  ShortcutBindingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutBindingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutBindingsHash();

  @$internal
  @override
  $FutureProviderElement<List<ShortcutBinding>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShortcutBinding>> create(Ref ref) {
    return shortcutBindings(ref);
  }
}

String _$shortcutBindingsHash() => r'ecb2df562c6b70673f82f74f8b362f935734bfad';

/// خريطة التركيبة ← الإجراء، للبحث السريع داخل معالج المفاتيح.
/// المعطَّل لا يدخل الخريطة، فلا يستجيب لمفاتيحه.

@ProviderFor(shortcutLookup)
final shortcutLookupProvider = ShortcutLookupProvider._();

/// خريطة التركيبة ← الإجراء، للبحث السريع داخل معالج المفاتيح.
/// المعطَّل لا يدخل الخريطة، فلا يستجيب لمفاتيحه.

final class ShortcutLookupProvider
    extends
        $FunctionalProvider<
          Map<KeyCombo, ShortcutAction>,
          Map<KeyCombo, ShortcutAction>,
          Map<KeyCombo, ShortcutAction>
        >
    with $Provider<Map<KeyCombo, ShortcutAction>> {
  /// خريطة التركيبة ← الإجراء، للبحث السريع داخل معالج المفاتيح.
  /// المعطَّل لا يدخل الخريطة، فلا يستجيب لمفاتيحه.
  ShortcutLookupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutLookupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutLookupHash();

  @$internal
  @override
  $ProviderElement<Map<KeyCombo, ShortcutAction>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<KeyCombo, ShortcutAction> create(Ref ref) {
    return shortcutLookup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<KeyCombo, ShortcutAction> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<KeyCombo, ShortcutAction>>(
        value,
      ),
    );
  }
}

String _$shortcutLookupHash() => r'b0bd3a69aced1e682b20522db878f4895eb01bef';

/// سجلّ معالجات الشاشات — حيّ طوال عمر التطبيق: تسجّل فيه الشاشات معالجاتها،
/// ويقرأه الموزِّع لحظة ضغط المفتاح. تخلُّصه من نفسه كان سيُفقد التسجيلات.

@ProviderFor(shortcutHandlers)
final shortcutHandlersProvider = ShortcutHandlersProvider._();

/// سجلّ معالجات الشاشات — حيّ طوال عمر التطبيق: تسجّل فيه الشاشات معالجاتها،
/// ويقرأه الموزِّع لحظة ضغط المفتاح. تخلُّصه من نفسه كان سيُفقد التسجيلات.

final class ShortcutHandlersProvider
    extends
        $FunctionalProvider<
          ShortcutHandlers,
          ShortcutHandlers,
          ShortcutHandlers
        >
    with $Provider<ShortcutHandlers> {
  /// سجلّ معالجات الشاشات — حيّ طوال عمر التطبيق: تسجّل فيه الشاشات معالجاتها،
  /// ويقرأه الموزِّع لحظة ضغط المفتاح. تخلُّصه من نفسه كان سيُفقد التسجيلات.
  ShortcutHandlersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutHandlersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutHandlersHash();

  @$internal
  @override
  $ProviderElement<ShortcutHandlers> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShortcutHandlers create(Ref ref) {
    return shortcutHandlers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShortcutHandlers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShortcutHandlers>(value),
    );
  }
}

String _$shortcutHandlersHash() => r'b66d0f53d65a28e93f764ba312e1229c2b381165';
