// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The home dashboard as an [AsyncValue]. It folds the repository's [Result]
/// into async state: a [Failure] is rethrown so it surfaces as `AsyncError`
/// (rendered by `ErrorState.fromError`, including the offline treatment).
///
/// Refresh with `ref.invalidate(dashboardProvider)` or pull-to-refresh.

@ProviderFor(dashboard)
final dashboardProvider = DashboardProvider._();

/// The home dashboard as an [AsyncValue]. It folds the repository's [Result]
/// into async state: a [Failure] is rethrown so it surfaces as `AsyncError`
/// (rendered by `ErrorState.fromError`, including the offline treatment).
///
/// Refresh with `ref.invalidate(dashboardProvider)` or pull-to-refresh.

final class DashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<DashboardSummary>,
          DashboardSummary,
          FutureOr<DashboardSummary>
        >
    with $FutureModifier<DashboardSummary>, $FutureProvider<DashboardSummary> {
  /// The home dashboard as an [AsyncValue]. It folds the repository's [Result]
  /// into async state: a [Failure] is rethrown so it surfaces as `AsyncError`
  /// (rendered by `ErrorState.fromError`, including the offline treatment).
  ///
  /// Refresh with `ref.invalidate(dashboardProvider)` or pull-to-refresh.
  DashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardHash();

  @$internal
  @override
  $FutureProviderElement<DashboardSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardSummary> create(Ref ref) {
    return dashboard(ref);
  }
}

String _$dashboardHash() => r'38bd270aa360fdc3b4987f07febe150d0315fb59';
