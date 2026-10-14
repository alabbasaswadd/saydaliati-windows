/// Central route table. Names/paths in one place so navigation isn't
/// stringly-typed and deep links have a single source of truth.
///
/// Structure:
///  * The bottom-nav tabs are shell branches (each keeps its own state).
///  * Detail/create/edit and the "More" sub-pages are pushed on the ROOT
///    navigator, so they cover the shell (no bottom bar) and Back returns to it.
///
/// Auth/splash routes are intentionally omitted from this foundation — the
/// session infrastructure lives in `core/session`, ready to wire an auth gate
/// (a redirect on the router) once an auth feature is built.
abstract final class AppRoutes {
  const AppRoutes._();

  // Auth + intro
  static const String splash = '/splash';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String about = '/more/about';

  // Bottom-nav tab roots
  static const String home = '/home';
  static const String products = '/products';
  static const String catalog = '/catalog';
  static const String sales = '/sales';
  static const String more = '/more';

  // More → sub-sections (pushed on the root navigator, cover the shell)
  static const String inventory = '/more/inventory';
  static const String stockMovements = '/more/stock-movements';
  static const String purchases = '/more/purchases';

  // Returns → sales/purchases return documents (sibling routes under one
  // branch, same pattern as reports below — sidebar section of their own).
  static const String salesReturns = '/more/returns/sales';
  static const String purchaseReturns = '/more/returns/purchases';

  static const String suppliers = '/more/suppliers';
  static const String customers = '/more/customers';
  static const String categories = '/more/categories';
  static const String manufacturers = '/more/manufacturers';
  static const String units = '/more/units';
  static const String currencies = '/more/currencies';
  static const String reports = '/more/reports';

  // Expenses → category management + expense log (sibling routes under one
  // branch, same pattern as returns/reports).
  static const String expenseCategories = '/more/expenses/categories';
  static const String expenses = '/more/expenses/list';

  // Accounts → chart of accounts (balances + statement drill-down pushed from
  // it) + vouchers (sibling routes under one branch).
  static const String accounts = '/more/accounts';
  static const String vouchers = '/more/vouchers';

  // Reports → individual reports (nested under the reports branch so they
  // render INSIDE the desktop shell and keep the sidebar highlight in sync).
  static const String salesReport = '/more/reports/sales';
  static const String profitReport = '/more/reports/profit';
  static const String purchasesReport = '/more/reports/purchases';
  static const String inventoryReport = '/more/reports/inventory';
  static const String expiryReport = '/more/reports/expiry';
  static const String stocktakeReport = '/more/reports/stocktake';
  static const String prescriptionsReport = '/more/reports/prescriptions';
  static const String settings = '/more/settings';
  static const String profile = '/more/profile';
  static const String tutorials = '/more/tutorials';
  static const String notifications = '/more/notifications';
}
