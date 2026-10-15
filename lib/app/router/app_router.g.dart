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
///   7  /more/returns          – Sales/purchases returns (sibling routes)
///   8  /more/suppliers        – Suppliers
///   9  /more/customers        – Customers
///  10  /more/categories       – Categories
///  11  /more/manufacturers    – Manufacturers
///  12  /more/units            – Units
///  13  /more/currencies       – Currencies
///  14  /more/reports          – Reports hub
///  15  /more/expenses         – Expense categories/log (sibling routes)
///  16  /more/accounts         – Chart of accounts
///  17  /more/notifications    – Notifications
///  18  /more/tutorials        – Tutorials
///  19  /more/settings         – Settings
///  20  /more/profile          – Account / profile

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
///   7  /more/returns          – Sales/purchases returns (sibling routes)
///   8  /more/suppliers        – Suppliers
///   9  /more/customers        – Customers
///  10  /more/categories       – Categories
///  11  /more/manufacturers    – Manufacturers
///  12  /more/units            – Units
///  13  /more/currencies       – Currencies
///  14  /more/reports          – Reports hub
///  15  /more/expenses         – Expense categories/log (sibling routes)
///  16  /more/accounts         – Chart of accounts
///  17  /more/notifications    – Notifications
///  18  /more/tutorials        – Tutorials
///  19  /more/settings         – Settings
///  20  /more/profile          – Account / profile

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
  ///   7  /more/returns          – Sales/purchases returns (sibling routes)
  ///   8  /more/suppliers        – Suppliers
  ///   9  /more/customers        – Customers
  ///  10  /more/categories       – Categories
  ///  11  /more/manufacturers    – Manufacturers
  ///  12  /more/units            – Units
  ///  13  /more/currencies       – Currencies
  ///  14  /more/reports          – Reports hub
  ///  15  /more/expenses         – Expense categories/log (sibling routes)
  ///  16  /more/accounts         – Chart of accounts
  ///  17  /more/notifications    – Notifications
  ///  18  /more/tutorials        – Tutorials
  ///  19  /more/settings         – Settings
  ///  20  /more/profile          – Account / profile
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

String _$goRouterHash() => r'907eb087cc930f2d5b2d643ad6975c6bb41cfb34';
