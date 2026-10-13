// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcementRemoteDataSource)
final announcementRemoteDataSourceProvider =
    AnnouncementRemoteDataSourceProvider._();

final class AnnouncementRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AnnouncementRemoteDataSource,
          AnnouncementRemoteDataSource,
          AnnouncementRemoteDataSource
        >
    with $Provider<AnnouncementRemoteDataSource> {
  AnnouncementRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AnnouncementRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementRemoteDataSource create(Ref ref) {
    return announcementRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementRemoteDataSource>(value),
    );
  }
}

String _$announcementRemoteDataSourceHash() =>
    r'7065044ef8409291384605ceaa3e0cef1bcfb2e4';

/// Fetches the pending announcements once (on app open) and acknowledges them as
/// they're shown. Not kept alive — it's a transient, fire-once flow driven by the
/// shell; failures are swallowed so they never block the app.

@ProviderFor(PendingAnnouncements)
final pendingAnnouncementsProvider = PendingAnnouncementsProvider._();

/// Fetches the pending announcements once (on app open) and acknowledges them as
/// they're shown. Not kept alive — it's a transient, fire-once flow driven by the
/// shell; failures are swallowed so they never block the app.
final class PendingAnnouncementsProvider
    extends $AsyncNotifierProvider<PendingAnnouncements, List<Announcement>> {
  /// Fetches the pending announcements once (on app open) and acknowledges them as
  /// they're shown. Not kept alive — it's a transient, fire-once flow driven by the
  /// shell; failures are swallowed so they never block the app.
  PendingAnnouncementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingAnnouncementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingAnnouncementsHash();

  @$internal
  @override
  PendingAnnouncements create() => PendingAnnouncements();
}

String _$pendingAnnouncementsHash() =>
    r'eafedb194ba08580b7b7805ad6e3bca7d66e33ad';

/// Fetches the pending announcements once (on app open) and acknowledges them as
/// they're shown. Not kept alive — it's a transient, fire-once flow driven by the
/// shell; failures are swallowed so they never block the app.

abstract class _$PendingAnnouncements
    extends $AsyncNotifier<List<Announcement>> {
  FutureOr<List<Announcement>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Announcement>>, List<Announcement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Announcement>>, List<Announcement>>,
              AsyncValue<List<Announcement>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
