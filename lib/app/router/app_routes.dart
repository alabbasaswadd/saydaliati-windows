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
  static const String suppliers = '/more/suppliers';
  static const String customers = '/more/customers';
  static const String categories = '/more/categories';
  static const String manufacturers = '/more/manufacturers';
  static const String units = '/more/units';
  static const String currencies = '/more/currencies';
  static const String reports = '/more/reports';
  static const String settings = '/more/settings';
  static const String profile = '/more/profile';
  static const String tutorials = '/more/tutorials';
  static const String notifications = '/more/notifications';
}
