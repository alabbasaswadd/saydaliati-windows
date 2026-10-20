// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// صلاحيات المستخدم الحالي — مُشتقّة من [currentUserProvider] (`/auth/me`)،
/// لا مصدرها الخاص. تتبع دورة حياة [currentUserProvider] تماماً: تُعاد
/// حسابها كل مرة يُعاد جلب أو إبطال ذلك المزوّد (تسجيل دخول جديد، تسجيل
/// خروج، أو استجابة 403 تستدعي تحديثاً — راجع [AuthInterceptor]).

@ProviderFor(currentUserPermissions)
final currentUserPermissionsProvider = CurrentUserPermissionsProvider._();

/// صلاحيات المستخدم الحالي — مُشتقّة من [currentUserProvider] (`/auth/me`)،
/// لا مصدرها الخاص. تتبع دورة حياة [currentUserProvider] تماماً: تُعاد
/// حسابها كل مرة يُعاد جلب أو إبطال ذلك المزوّد (تسجيل دخول جديد، تسجيل
/// خروج، أو استجابة 403 تستدعي تحديثاً — راجع [AuthInterceptor]).

final class CurrentUserPermissionsProvider
    extends
        $FunctionalProvider<
          CurrentUserPermissions,
          CurrentUserPermissions,
          CurrentUserPermissions
        >
    with $Provider<CurrentUserPermissions> {
  /// صلاحيات المستخدم الحالي — مُشتقّة من [currentUserProvider] (`/auth/me`)،
  /// لا مصدرها الخاص. تتبع دورة حياة [currentUserProvider] تماماً: تُعاد
  /// حسابها كل مرة يُعاد جلب أو إبطال ذلك المزوّد (تسجيل دخول جديد، تسجيل
  /// خروج، أو استجابة 403 تستدعي تحديثاً — راجع [AuthInterceptor]).
  CurrentUserPermissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserPermissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserPermissionsHash();

  @$internal
  @override
  $ProviderElement<CurrentUserPermissions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CurrentUserPermissions create(Ref ref) {
    return currentUserPermissions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrentUserPermissions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrentUserPermissions>(value),
    );
  }
}

String _$currentUserPermissionsHash() =>
    r'c09275d41e998655072af4d0afee08e0dca5879e';
