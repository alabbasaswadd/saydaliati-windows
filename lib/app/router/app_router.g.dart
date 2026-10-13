// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [GoRouter] — desktop edition.
///
/// All sections that were previously pushed on the root navigator ("More"
/// sub-pages) are now [StatefulShellBranch]es so the sidebar remains visible
/// while every part of the app is open.
///
/// Branch index → route map (must stay in sync with desktop_sidebar.dart):
///   0  /sales                 – POS / Sales
///   1  /products              – Medicines
///   2  /catalog               – Catalog
///   3  /home                  – Dashboard / quick actions
///   4  /more/inventory        – Stock
///   5  /more/stock-movements  – Stock movements
///   6  /more/purchases        – Purchases
///   7  /more/suppliers        – Suppliers
///   8  /more/customers        – Customers
///   9  /more/categories       – Categories
///  10  /more/manufacturers    – Manufacturers
///  11  /more/units            – Units
///  12  /more/currencies       – Currencies
///  13  /more/reports          – Reports hub
///  14  /more/notifications    – Notifications
///  15  /more/tutorials        – Tutorials
///  16  /more/settings         – Settings
///  17  /more/profile          – Account / profile

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

/// The app's [GoRouter] — desktop edition.
///
/// All sections that were previously pushed on the root navigator ("More"
/// sub-pages) are now [StatefulShellBranch]es so the sidebar remains visible
/// while every part of the app is open.
///
/// Branch index → route map (must stay in sync with desktop_sidebar.dart):
///   0  /sales                 – POS / Sales
///   1  /products              – Medicines
///   2  /catalog               – Catalog
///   3  /home                  – Dashboard / quick actions
///   4  /more/inventory        – Stock
///   5  /more/stock-movements  – Stock movements
///   6  /more/purchases        – Purchases
///   7  /more/suppliers        – Suppliers
///   8  /more/customers        – Customers
///   9  /more/categories       – Categories
///  10  /more/manufacturers    – Manufacturers
///  11  /more/units            – Units
///  12  /more/currencies       – Currencies
///  13  /more/reports          – Reports hub
///  14  /more/notifications    – Notifications
///  15  /more/tutorials        – Tutorials
///  16  /more/settings         – Settings
///  17  /more/profile          – Account / profile

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The app's [GoRouter] — desktop edition.
  ///
  /// All sections that were previously pushed on the root navigator ("More"
  /// sub-pages) are now [StatefulShellBranch]es so the sidebar remains visible
  /// while every part of the app is open.
  ///
  /// Branch index → route map (must stay in sync with desktop_sidebar.dart):
  ///   0  /sales                 – POS / Sales
  ///   1  /products              – Medicines
  ///   2  /catalog               – Catalog
  ///   3  /home                  – Dashboard / quick actions
  ///   4  /more/inventory        – Stock
  ///   5  /more/stock-movements  – Stock movements
  ///   6  /more/purchases        – Purchases
  ///   7  /more/suppliers        – Suppliers
  ///   8  /more/customers        – Customers
  ///   9  /more/categories       – Categories
  ///  10  /more/manufacturers    – Manufacturers
  ///  11  /more/units            – Units
  ///  12  /more/currencies       – Currencies
  ///  13  /more/reports          – Reports hub
  ///  14  /more/notifications    – Notifications
  ///  15  /more/tutorials        – Tutorials
  ///  16  /more/settings         – Settings
  ///  17  /more/profile          – Account / profile
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'7e0643589420b19183a78fa43ff613af6f067257';
