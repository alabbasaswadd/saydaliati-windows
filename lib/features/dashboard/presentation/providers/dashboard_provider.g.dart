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

/// Net profit for one period (day/week/month/year) — refetches on its own
/// when the dashboard's period selector changes, independent of [dashboard].

@ProviderFor(dashboardProfit)
final dashboardProfitProvider = DashboardProfitFamily._();

/// Net profit for one period (day/week/month/year) — refetches on its own
/// when the dashboard's period selector changes, independent of [dashboard].

final class DashboardProfitProvider
    extends
        $FunctionalProvider<
          AsyncValue<DashboardProfit>,
          DashboardProfit,
          FutureOr<DashboardProfit>
        >
    with $FutureModifier<DashboardProfit>, $FutureProvider<DashboardProfit> {
  /// Net profit for one period (day/week/month/year) — refetches on its own
  /// when the dashboard's period selector changes, independent of [dashboard].
  DashboardProfitProvider._({
    required DashboardProfitFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dashboardProfitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dashboardProfitHash();

  @override
  String toString() {
    return r'dashboardProfitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DashboardProfit> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardProfit> create(Ref ref) {
    final argument = this.argument as String;
    return dashboardProfit(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardProfitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dashboardProfitHash() => r'761854d3f0ce533d26270a1e3bfd27ce8a8bcbc6';

/// Net profit for one period (day/week/month/year) — refetches on its own
/// when the dashboard's period selector changes, independent of [dashboard].

final class DashboardProfitFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DashboardProfit>, String> {
  DashboardProfitFamily._()
    : super(
        retry: null,
        name: r'dashboardProfitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Net profit for one period (day/week/month/year) — refetches on its own
  /// when the dashboard's period selector changes, independent of [dashboard].

  DashboardProfitProvider call(String period) =>
      DashboardProfitProvider._(argument: period, from: this);

  @override
  String toString() => r'dashboardProfitProvider';
}
