/// Application-wide constants that are not environment-specific.
///
/// Environment values (base URL) live in `AppConfig`.
abstract final class AppConstants {
  const AppConstants._();

  static const String appName = 'صيدليتي';

  /// Default network timeouts, shared by the Dio factory.
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// The empty GUID many APIs accept to mean "server assigns the id".
  static const String emptyGuid = '00000000-0000-0000-0000-000000000000';

  /// Default paging values used by paged endpoints.
  static const int defaultLimit = 20;
  static const int defaultOffset = 0;

  /// Local cache key for the main warehouse id. It is resolved automatically
  /// from the backend (`GET Warehouse/main`) and cached here so sales/stock keep
  /// working offline; it is never entered manually.
  static const String defaultWarehouseKey = 'default_warehouse_id';

  /// Local cache key for the main warehouse display name (cached alongside its
  /// id so the settings screen can show it while offline).
  static const String defaultWarehouseNameKey = 'default_warehouse_name';

  /// Server-side settings key holding the pharmacy display name (general setting).
  static const String pharmacyNameKey = 'pharmacy_name';

  /// Server-side settings key: allow selling when stock is insufficient (the
  /// balance may go negative). Stored as "true"/"false". Must match the backend.
  static const String allowNegativeSaleKey = 'AllowNegativeSale';

  /// Local flag: the first-run intro carousel has been seen.
  static const String introSeenKey = 'intro_seen';

  /// Local flag: the post-auth "we migrate your data" offer has been shown
  /// once (first time the dashboard is reached on this device). v2: v1 had a
  /// race where the trigger lived on the login page itself — its context
  /// could be torn down by the router's post-auth redirect between marking
  /// the flag seen and actually showing the dialog, silently eating the
  /// offer forever. Moved to [MigrationOfferGate] on the stable home page.
  static const String migrationOfferSeenKey = 'migration_offer_seen_v2';

  /// الدعم الفني — أرقام واتساب سورية، محلية (٠ بالبداية، تُحوَّل لدولية
  /// بإبدال الصفر بـ٩٦٣ عند بناء رابط wa.me).
  static const List<String> supportWhatsAppNumbers = ['0988693463', '0985311971'];
}

/// Keys used with the [KeyValueStore]. Centralized to avoid stringly-typed drift.
abstract final class StorageKeys {
  const StorageKeys._();

  static const String accessToken = 'access_token';
  static const String userId = 'user_id';
  static const String tenantId = 'tenant_id';
}
