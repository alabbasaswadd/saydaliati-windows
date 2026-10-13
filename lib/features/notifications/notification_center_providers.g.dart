// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_center_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationRemoteDataSource)
final notificationRemoteDataSourceProvider =
    NotificationRemoteDataSourceProvider._();

final class NotificationRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          NotificationRemoteDataSource,
          NotificationRemoteDataSource,
          NotificationRemoteDataSource
        >
    with $Provider<NotificationRemoteDataSource> {
  NotificationRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<NotificationRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRemoteDataSource create(Ref ref) {
    return notificationRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRemoteDataSource>(value),
    );
  }
}

String _$notificationRemoteDataSourceHash() =>
    r'c6a024dca71ed4846160265214e7149af04f15db';

/// Loads notifications and applies read-state changes with optimistic local
/// updates (so the list/badge react instantly). Kept alive so the unread badge
/// stays warm across tab switches.

@ProviderFor(NotificationCenter)
final notificationCenterProvider = NotificationCenterProvider._();

/// Loads notifications and applies read-state changes with optimistic local
/// updates (so the list/badge react instantly). Kept alive so the unread badge
/// stays warm across tab switches.
final class NotificationCenterProvider
    extends
        $AsyncNotifierProvider<NotificationCenter, NotificationCenterState> {
  /// Loads notifications and applies read-state changes with optimistic local
  /// updates (so the list/badge react instantly). Kept alive so the unread badge
  /// stays warm across tab switches.
  NotificationCenterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCenterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCenterHash();

  @$internal
  @override
  NotificationCenter create() => NotificationCenter();
}

String _$notificationCenterHash() =>
    r'6775cde0c3404892ba9d0b8eba00503e541e67bb';

/// Loads notifications and applies read-state changes with optimistic local
/// updates (so the list/badge react instantly). Kept alive so the unread badge
/// stays warm across tab switches.

abstract class _$NotificationCenter
    extends $AsyncNotifier<NotificationCenterState> {
  FutureOr<NotificationCenterState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationCenterState>,
              NotificationCenterState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationCenterState>,
                NotificationCenterState
              >,
              AsyncValue<NotificationCenterState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Unread count for the bell badge — 0 while loading / on error.

@ProviderFor(notificationsUnreadCount)
final notificationsUnreadCountProvider = NotificationsUnreadCountProvider._();

/// Unread count for the bell badge — 0 while loading / on error.

final class NotificationsUnreadCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Unread count for the bell badge — 0 while loading / on error.
  NotificationsUnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsUnreadCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsUnreadCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return notificationsUnreadCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notificationsUnreadCountHash() =>
    r'a73e7c2fabff98e31a793228cbdd8c24d3c4cb16';
