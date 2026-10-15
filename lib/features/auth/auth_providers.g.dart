// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'c422628ad3ddd2cfd86926f22a881b68a524350a';

/// بيانات المستخدم والصيدلية الحالية.
///
/// مزوّد لا `FutureBuilder` في `initState`: الأوّل قابل للتحديث
/// (`ref.invalidate`) ومشترك بين الشاشات، والثاني يُعيد النداء مع كل إعادة
/// بناء للحالة ولا سبيل لتحديثه دون `setState`.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// بيانات المستخدم والصيدلية الحالية.
///
/// مزوّد لا `FutureBuilder` في `initState`: الأوّل قابل للتحديث
/// (`ref.invalidate`) ومشترك بين الشاشات، والثاني يُعيد النداء مع كل إعادة
/// بناء للحالة ولا سبيل لتحديثه دون `setState`.

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// بيانات المستخدم والصيدلية الحالية.
  ///
  /// مزوّد لا `FutureBuilder` في `initState`: الأوّل قابل للتحديث
  /// (`ref.invalidate`) ومشترك بين الشاشات، والثاني يُعيد النداء مع كل إعادة
  /// بناء للحالة ولا سبيل لتحديثه دون `setState`.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'05c517aa7d4240b5e6ba1c814c55262017831f9e';
