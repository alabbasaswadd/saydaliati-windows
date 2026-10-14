import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/app/shell/desktop_shell.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/session/session_state.dart';
import 'package:saydaliati/features/about/presentation/pages/about_page.dart';
import 'package:saydaliati/features/auth/presentation/pages/account_page.dart';
import 'package:saydaliati/features/auth/presentation/pages/login_page.dart';
import 'package:saydaliati/features/auth/presentation/pages/register_page.dart';
import 'package:saydaliati/features/catalog/presentation/pages/catalog_page.dart';
import 'package:saydaliati/features/categories/presentation/pages/categories_page.dart';
import 'package:saydaliati/features/currencies/presentation/pages/currencies_page.dart';
import 'package:saydaliati/features/customers/presentation/pages/customers_page.dart';
import 'package:saydaliati/features/home/presentation/pages/home_page.dart';
import 'package:saydaliati/features/intro/intro_providers.dart';
import 'package:saydaliati/features/intro/presentation/intro_page.dart';
import 'package:saydaliati/features/manufacturers/presentation/pages/manufacturers_page.dart';
import 'package:saydaliati/features/medicine_units/presentation/pages/units_page.dart';
import 'package:saydaliati/features/medicines/presentation/pages/medicines_page.dart';
import 'package:saydaliati/features/notifications/presentation/pages/notifications_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_returns_list_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchases_page.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/pages/expiry_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/inventory_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/prescriptions_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/profit_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/purchases_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/sales_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/stocktake_report_page.dart';
import 'package:saydaliati/features/sales/presentation/pages/sale_returns_list_page.dart';
import 'package:saydaliati/features/sales/presentation/pages/sales_page.dart';
import 'package:saydaliati/features/settings/presentation/pages/settings_page.dart';
import 'package:saydaliati/features/splash/splash_page.dart';
import 'package:saydaliati/features/stock/presentation/pages/stock_page.dart';
import 'package:saydaliati/features/stock_movements/presentation/pages/stock_movements_page.dart';
import 'package:saydaliati/features/suppliers/presentation/pages/suppliers_page.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorials_page.dart';

part 'app_router.g.dart';

final _rootKey = GlobalKey<NavigatorState>();

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
///  15  /more/notifications    – Notifications
///  16  /more/tutorials        – Tutorials
///  17  /more/settings         – Settings
///  18  /more/profile          – Account / profile
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  GoRoute rootRoute(String path, Widget Function(GoRouterState) build) =>
      GoRoute(
        path: path,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => build(state),
      );

  StatefulShellBranch branch(String path, Widget page) =>
      StatefulShellBranch(
        routes: [GoRoute(path: path, builder: (c, s) => page)],
      );

  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionControllerProvider, (_, _) => refresh.value++);
  ref.listen(introSeenProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionControllerProvider);
      final introSeen = ref.read(introSeenProvider);
      final loc = state.matchedLocation;
      final onSplash = loc == AppRoutes.splash;

      if (session.isLoading || introSeen.isLoading) {
        return onSplash ? null : AppRoutes.splash;
      }

      final authed = session.asData?.value is Authenticated;
      final seenIntro = introSeen.asData?.value ?? true;
      final onIntro = loc == AppRoutes.intro;
      final onAuth = loc == AppRoutes.login || loc == AppRoutes.register;

      if (authed) {
        return (onAuth || onIntro || onSplash) ? AppRoutes.sales : null;
      }
      if (!seenIntro) return onIntro ? null : AppRoutes.intro;
      if (onSplash || onIntro) return AppRoutes.login;
      return onAuth ? null : AppRoutes.login;
    },
    routes: [
      // ── Auth / onboarding ──────────────────────────────────────────────
      rootRoute(AppRoutes.splash, (s) => const SplashPage()),
      rootRoute(AppRoutes.intro, (s) => const IntroPage()),
      rootRoute(AppRoutes.login, (s) => const LoginPage()),
      rootRoute(AppRoutes.register, (s) => const RegisterPage()),
      rootRoute(AppRoutes.about, (s) => const AboutPage()),

      // ── Desktop shell with sidebar ─────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => DesktopShell(shell: shell),
        branches: [
          // ── Main tabs (indices 0-3) ────────────────────────────────────
          branch(AppRoutes.sales, const SalesPage()),
          branch(AppRoutes.products, const MedicinesPage()),
          branch(AppRoutes.catalog, const CatalogPage()),
          branch(AppRoutes.home, const HomePage()),

          // ── Inventory & purchasing (indices 4-6) ──────────────────────
          branch(AppRoutes.inventory, const StockPage()),
          branch(AppRoutes.stockMovements, const StockMovementsPage()),
          branch(AppRoutes.purchases, const PurchasesPage()),

          // ── Returns (index 7) ───────────────────────────────────────────
          // مسارات شقيقة (نفس أسلوب التقارير): `go` بينها يستبدل الصفحة بلا
          // مكدس، والشريط الجانبي يظلّل القسم المفتوح.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.salesReturns,
                builder: (c, s) => const SaleReturnsListPage(),
              ),
              GoRoute(
                path: AppRoutes.purchaseReturns,
                builder: (c, s) => const PurchaseReturnsListPage(),
              ),
            ],
          ),

          // ── Master data (indices 8-13) ─────────────────────────────────
          branch(AppRoutes.suppliers, const SuppliersPage()),
          branch(AppRoutes.customers, const CustomersPage()),
          branch(AppRoutes.categories, const CategoriesPage()),
          branch(AppRoutes.manufacturers, const ManufacturersPage()),
          branch(AppRoutes.units, const UnitsPage()),
          branch(AppRoutes.currencies, const CurrenciesPage()),

          // ── Reports (index 13) ─────────────────────────────────────────
          // مسارات شقيقة (لا تداخل ولا صفحة مركز): `go` بينها يستبدل الصفحة
          // فلا مكدس ولا سهم رجوع، والشريط الجانبي يظلّل التقرير المفتوح.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.salesReport,
                builder: (c, s) =>
                    SalesReportPage(initialPeriod: ReportPeriod.month()),
              ),
              GoRoute(
                path: AppRoutes.profitReport,
                builder: (c, s) =>
                    ProfitReportPage(initialPeriod: ReportPeriod.month()),
              ),
              GoRoute(
                path: AppRoutes.purchasesReport,
                builder: (c, s) =>
                    PurchasesReportPage(initialPeriod: ReportPeriod.month()),
              ),
              GoRoute(
                path: AppRoutes.inventoryReport,
                builder: (c, s) => const InventoryReportPage(),
              ),
              GoRoute(
                path: AppRoutes.expiryReport,
                builder: (c, s) => const ExpiryReportPage(),
              ),
              GoRoute(
                path: AppRoutes.stocktakeReport,
                builder: (c, s) => const StocktakeReportPage(),
              ),
              GoRoute(
                path: AppRoutes.prescriptionsReport,
                builder: (c, s) => const PrescriptionsReportPage(),
              ),
            ],
          ),

          // ── System (indices 14-17) ─────────────────────────────────────
          branch(AppRoutes.notifications, const NotificationsPage()),
          branch(AppRoutes.tutorials, const TutorialsPage()),
          branch(AppRoutes.settings, const SettingsPage()),
          branch(AppRoutes.profile, const AccountPage()),
        ],
      ),
    ],
  );
}
