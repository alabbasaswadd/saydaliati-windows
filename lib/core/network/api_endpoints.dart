/// Central registry of API paths for the Pharmacy.api backend.
///
/// Keeping them here means routes aren't stringly-typed across the codebase and
/// have a single source of truth. All paths are relative to the host base URL
/// (see `AppConfig`). The backend convention is `pharmacy-api/[Controller]` —
/// the ONE exception is Alternatives, which lives under `api/Alternatives`.
///
/// List endpoints page with `?limit=&offset=` and return bare JSON arrays
/// (there is no paging envelope). Enums are sent/received as integers.
abstract final class ApiEndpoints {
  const ApiEndpoints._();

  static const String _base = '/pharmacy-api';

  // ---- Dashboard ----
  static const String dashboard = '$_base/Dashboard';

  // ---- Medicines ----
  // Auth
  static const String authRegister = '$_base/Auth/register';
  static const String authLogin = '$_base/Auth/login';
  static const String authMe = '$_base/Auth/me';

  // ---- Notifications ----
  static const String notifications = '$_base/Notifications';
  static String notificationRead(String id) => '$_base/Notifications/$id/read';
  static const String notificationsReadAll = '$_base/Notifications/read-all';

  // ---- Announcements (one-time tips shown on app open) ----
  static const String announcementsPending = '$_base/Announcements/pending';
  static String announcementAck(String id) => '$_base/Announcements/$id/ack';

  static const String medicines = '$_base/Medicine';
  static String medicineById(String id) => '$_base/Medicine/$id';
  static String medicinePrices(String id) => '$_base/Medicine/$id/prices';
  static String medicineAlternatives(String id) => '$_base/Medicine/$id/alternatives';
  static String medicineBarcode(String id) => '$_base/Medicine/$id/barcode';

  // ---- Medicine Catalog (global, read-only reference — 22.5k drugs) ----
  static const String catalog = '$_base/MedicineCatalog';
  // whole catalog in one response (for the offline mirror — one request, no offset)
  static const String catalogAll = '$_base/MedicineCatalog/all';
  static String catalogById(String id) => '$_base/MedicineCatalog/$id';
  static String catalogByBarcode(String barcode) =>
      '$_base/MedicineCatalog/by-barcode/$barcode';
  static String catalogAlternatives(String id) =>
      '$_base/MedicineCatalog/$id/alternatives';
  static const String catalogManufacturers = '$_base/MedicineCatalog/manufacturers';
  static const String catalogMeta = '$_base/MedicineCatalog/meta';
  static const String catalogSync = '$_base/MedicineCatalog/sync';
  // add a catalog item to the pharmacy's own stock (creates/reuses a medicine)
  static const String medicineFromCatalog = '$_base/Medicine/from-catalog';
  // sync the pharmacy's own medicine prices from the global catalog
  static const String medicineSyncPrices = '$_base/Medicine/sync-prices';
  // toggle auto-price-sync for one medicine
  static String medicineAutoPriceSync(String id) => '$_base/Medicine/$id/auto-price-sync';

  // ---- Medicine units ----
  static const String medicineUnits = '$_base/MedicineUnit';
  static String medicineUnitById(String id) => '$_base/MedicineUnit/$id';

  // ---- Medicine unit prices ----
  static const String medicineUnitPrices = '$_base/MedicineUnitPrice';
  static String medicineUnitPriceById(String id) =>
      '$_base/MedicineUnitPrice/$id';

  // ---- Alternatives (NOTE: different prefix) ----
  static const String alternatives = '/api/Alternatives';
  static String alternativeById(String id) => '/api/Alternatives/$id';

  // ---- Categories ----
  static const String categories = '$_base/Category';
  static String categoryById(String id) => '$_base/Category/$id';

  // ---- Manufacturers ----
  static const String manufacturers = '$_base/Manufacturer';
  static String manufacturerById(String id) => '$_base/Manufacturer/$id';

  // ---- Currencies ----
  static const String currencies = '$_base/Currency';
  static String currencyById(String id) => '$_base/Currency/$id';
  static const String changeBaseCurrency = '$_base/Currency/ChangeBaseCurrency';

  // ---- Exchange rate ----
  static const String exchangeRate = '$_base/ExchangeRate';
  static String exchangeRateHistory(String currencyId) =>
      '$_base/ExchangeRate/history/$currencyId';

  // ---- Warehouses (single-warehouse setup; the main one is auto-resolved) ----
  static const String warehouses = '$_base/Warehouse';
  static const String mainWarehouse = '$_base/Warehouse/main';

  // ---- Stock ----
  static const String stocks = '$_base/Stock';
  static String stockById(String id) => '$_base/Stock/$id';
  static String stockWarehousesForMedicine(String medicineId) =>
      '$_base/Stock/medicine/$medicineId/warehouses';

  // ---- Stock movements (read-only) ----
  static const String stockMovements = '$_base/StockMovement';
  static String stockMovementById(String id) => '$_base/StockMovement/$id';

  // ---- Sales ----
  static const String sales = '$_base/Sale';
  static String saleById(String id) => '$_base/Sale/$id';

  // ---- Sale returns ----
  static const String saleReturns = '$_base/SaleReturn';
  static String saleReturnableLines(String saleId) =>
      '$_base/SaleReturn/returnable-lines/$saleId';
  static String saleReturnsBySale(String saleId) =>
      '$_base/SaleReturn/by-sale/$saleId';

  // ---- Purchases ----
  static const String purchases = '$_base/Purchase';
  static String purchaseById(String id) => '$_base/Purchase/$id';

  // ---- Purchase returns ----
  static const String purchaseReturns = '$_base/PurchaseReturn';
  static String purchaseReturnableLines(String purchaseId) =>
      '$_base/PurchaseReturn/returnable-lines/$purchaseId';
  static String purchaseReturnsByPurchase(String purchaseId) =>
      '$_base/PurchaseReturn/by-purchase/$purchaseId';

  // ---- Expense categories ----
  static const String expenseCategories = '$_base/ExpenseCategory';
  static String expenseCategoryById(String id) => '$_base/ExpenseCategory/$id';

  // ---- Expenses ----
  static const String expenses = '$_base/Expense';
  static String expenseById(String id) => '$_base/Expense/$id';
  static const String expensesSummary = '$_base/Expense/summary';

  // ---- Accounts (chart of accounts) ----
  static const String accounts = '$_base/Account';
  static String accountById(String id) => '$_base/Account/$id';
  static String accountStatement(String id) => '$_base/Account/$id/statement';

  // ---- Journal entries ----
  static const String journalEntries = '$_base/JournalEntry';
  static String journalEntryById(String id) => '$_base/JournalEntry/$id';
  static const String journalEntryDetails = '$_base/JournalEntryDetail';
  static String journalEntryDetailById(String id) =>
      '$_base/JournalEntryDetail/$id';

  // ---- Reports ----
  static String medicineReport(String medicineId) =>
      '$_base/Report/medicine-report/$medicineId';
  static const String salesSummary = '$_base/Report/sales-summary';
  // Tree-grid reports (invoice + line items + profit). Return bare JSON arrays.
  static const String salesGrid = '$_base/Report/sales-grid';
  static const String purchasesGrid = '$_base/Report/purchases-grid';
  static const String profitReport = '$_base/Report/profit';
  static const String expiryReport = '$_base/Report/expiry';
  static const String purchasesSummary = '$_base/Report/purchases-summary';
  static const String inventoryReport = '$_base/Report/inventory';
  static const String stocktakeReport = '$_base/Report/stocktake';
  static String medicineBatches(String medicineId) =>
      '$_base/Stock/medicine/$medicineId/batches';

  // ---- Suppliers & Customers ----
  static const String suppliers = '$_base/Supplier';
  static String supplierById(String id) => '$_base/Supplier/$id';
  static const String customers = '$_base/Customer';
  static String customerById(String id) => '$_base/Customer/$id';

  // ---- Settings ----
  static const String settings = '$_base/Setting';
  static String settingByKey(String key) => '$_base/Setting/$key';

  // ---- Keyboard shortcuts (stored customisations only; the app owns the
  // action catalogue and the defaults) ----
  static const String shortcuts = '$_base/Shortcut';
  static const String shortcutsReset = '$_base/Shortcut/reset';
}
