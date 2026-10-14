/// Central Arabic copy for the app. Keeping user-facing strings here keeps the
/// UI fully Arabic and consistent, and makes a future move to ARB/intl trivial.
///
/// Rule: no English placeholders or button text in the final UI. Use clear,
/// professional Arabic. Feature-specific copy is added here per feature as the
/// feature is built; this foundation ships only the shared/common strings.
abstract final class AppStrings {
  const AppStrings._();

  // App
  static const String appName = 'صيدليتي';
  static const String homeTitle = 'الرئيسية';
  static const String sectionsTitle = 'التقارير';
  static const String homeGreeting = 'أهلاً بك';
  static const String homeSubtitle = 'ابدأ بسرعة أو انتقل إلى ما تريد';

  // Bottom navigation tabs
  static const String tabHome = 'التقارير';
  static const String tabProducts = 'أدويتي';
  static const String tabSales = 'المبيعات';
  static const String tabMore = 'المزيد';

  // Feature section titles (pharmacy domain — placeholders for now)
  static const String products = 'الأدوية والمنتجات';
  static const String sales = 'المبيعات';
  static const String purchases = 'المشتريات';
  static const String inventory = 'المخزون';
  static const String customers = 'الزبائن';
  static const String suppliers = 'الموردون';
  static const String categories = 'الأصناف';
  static const String reports = 'التقارير';
  static const String settings = 'الإعدادات';
  static const String account = 'الحساب الشخصي';
  static const String more = 'المزيد';
  static const String comingSoon = 'قيد الإنشاء';
  // المزيد — الدعم والأسعار
  static const String techSupport = 'الدعم الفني';
  static const String techSupportHint = 'تواصل معنا عبر واتساب';
  static const String pricingAndPlans = 'الأسعار والخطط';
  static const String pricingAndPlansHint = 'عرض الباقات على الموقع الرسمي';

  // Reports hub + period picker
  static const String reportsHubHint = 'اختر الفترة ثم التقرير المطلوب';
  static const String salesReport = 'تقرير المبيعات';
  static const String salesReportHint = 'الإيرادات وعدد الفواتير وأكثر الأدوية مبيعاً';
  static const String purchasesReport = 'تقرير المشتريات';
  static const String purchasesReportHint = 'إجمالي التكلفة والفواتير حسب المورّد والدواء';
  static const String inventoryReport = 'تقرير المخزون';
  static const String inventoryReportHint = 'الكميات وقيمة المخزون والمنخفض منه';
  static const String stocktakeReport = 'الجرد';
  static const String stocktakeReportHint = 'كل المواد ووحداتها بأسعار التكلفة/البيع';
  static const String stocktakeValue = 'قيمة الجرد (تكلفة)';
  static const String materialsCount = 'عدد المواد';
  static const String basisCost = 'سعر التكلفة';
  static const String basisSale = 'سعر البيع';
  static const String costCalcHint = 'التكلفة = تكلفة الوحدة الأساسية × المعامل';
  static const String expiryReport = 'تقرير الصلاحية';
  static const String expiryReportHint = 'الأدوية قريبة الانتهاء والمنتهية';
  static const String period = 'الفترة';
  static const String periodToday = 'اليوم';
  static const String periodWeek = 'هذا الأسبوع';
  static const String periodMonth = 'هذا الشهر';
  static const String periodCustom = 'مخصّص';
  static const String totalRevenue = 'إجمالي الإيراد';
  static const String invoicesCount = 'عدد الفواتير';
  static const String byPaymentMethod = 'حسب طريقة الدفع';
  static const String topSellingMedicines = 'الأكثر مبيعاً';
  static const String noDataForPeriod = 'لا توجد بيانات في هذه الفترة';
  static const String totalCost = 'إجمالي التكلفة';
  static const String topPurchasedMedicines = 'الأكثر شراءً';
  static const String qtyLabel = 'الكمية';
  static const String invoicesSection = 'الفواتير';
  static const String invoiceLabel = 'فاتورة';
  static const String windowAll = 'الكل';
  static const String costOfGoods = 'تكلفة المبيعات';
  static const String grossProfit = 'الربح الإجمالي';
  // Tree-grid reports (sales/purchases)
  static const String unitPriceColumn = 'الإفرادي';
  static const String piecesCountColumn = 'عدد القطع';
  static const String discountShort = 'الحسم';
  static const String marginLabel = 'الهامش';
  static const String estimatedCost = 'كلفة تقديرية';
  static const String cashSale = 'نقدي';
  static const String batchLabel = 'الدفعة';
  static const String stockValue = 'قيمة المخزون';
  static const String medicinesInStock = 'أصناف لها رصيد';
  static const String lowStockCount = 'أصناف منخفضة';
  static const String lowStockBadge = 'منخفض';
  static const String inventoryItems = 'الأصناف';
  static const String medicineName = 'الدواء';
  static const String warehouseColumn = 'المستودع';
  static const String expiryColumn = 'الصلاحية';
  static const String daysLeftColumn = 'المتبقّي';
  static const String unitColumn = 'الوحدة';
  static const String priceColumn = 'السعر';
  static const String subtotalColumn = 'الإجمالي';
  static const String dateColumn = 'التاريخ';
  static const String stockBatchesTitle = 'دفعات المخزون (تواريخ الصلاحية)';
  static const String noBatchesInStock = 'لا توجد دفعات في المخزون';
  static const String stockStatus = 'الحالة';
  static const String costPriceLabel = 'سعر الكلفة';
  static const String profitReportTitle = 'تقرير الأرباح';
  static const String todaysProfit = 'أرباح اليوم';
  static const String revenueShort = 'الإيراد';
  static const String costShort = 'التكلفة';
  static const String profitShort = 'الربح';
  static const String allCurrencies = 'كل العملات';
  static const String displayCurrency = 'عملة العرض';
  static const String originalCurrency = 'الأصل';
  static const String byCurrencyTitle = 'حسب العملة';
  static const String invoicesTitle = 'الفواتير';
  static const String profitFormulaHint =
      'الربح = (سعر البيع − سعر الكلفة) لكل بند';
  static const String profitReportHint =
      'ربح كل فاتورة والإجمالي حسب العملة';
  static const String qtySold = 'المُباع';
  static const String payCash = 'نقد';
  static const String payCreditCard = 'بطاقة ائتمان';
  static const String payDebitCard = 'بطاقة خصم';
  static const String payBankTransfer = 'حوالة بنكية';
  static const String payMobileWallet = 'محفظة إلكترونية';
  // Expiry report
  static const String expiringSoonTab = 'قريبة الانتهاء';
  static const String expiredTab = 'منتهية';
  static const String expiryWindow = 'نافذة التنبيه';
  static const String daysLeftLabel = 'متبقٍ';
  static const String daysAgoLabel = 'منذ';
  static const String daysUnit = 'يوم';
  static const String availableQty = 'المتوفّر';
  static const String noExpiringSoon = 'لا توجد أدوية قريبة الانتهاء';
  static const String noExpired = 'لا توجد أدوية منتهية';

  // Exit / back
  static const String exit = 'خروج';
  static const String exitTitle = 'تأكيد الخروج';
  static const String exitMessage = 'هل تريد الخروج من التطبيق؟';

  // Common actions
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String add = 'إضافة';
  static const String addNew = 'إضافة جديد';
  static const String confirm = 'تأكيد';
  static const String search = 'بحث';
  static const String retry = 'إعادة المحاولة';
  static const String close = 'إغلاق';
  static const String ok = 'حسناً';
  static const String logout = 'تسجيل الخروج';
  static const String details = 'التفاصيل';

  // CRUD feedback
  static const String saving = 'جاري الحفظ…';
  static const String deleting = 'جاري الحذف…';
  static const String createdSuccess = 'تمت الإضافة بنجاح';
  static const String updatedSuccess = 'تم التعديل بنجاح';
  static const String deletedSuccess = 'تم الحذف بنجاح';

  // Data refresh (local-first)
  static const String refreshData = 'تحديث البيانات';
  static const String refreshingData = 'جاري تحديث البيانات…';
  static const String noInternetToRefresh =
      'لا يوجد اتصال بالإنترنت لتحديث البيانات';
  static const String dataRefreshed = 'تم تحديث البيانات محلياً';
  static const String lastUpdated = 'آخر تحديث';
  static const String neverUpdated = 'لم يُحدَّث بعد';

  // Connectivity & offline sync
  static const String connectivitySection = 'الاتصال والمزامنة';
  static const String workingOffline = 'أنت تعمل دون اتصال';
  static const String offlineMode = 'وضع عدم الاتصال (أوفلاين)';
  static const String offlineModeHint =
      'يعمل التطبيق من البيانات المحفوظة ويؤجّل الإرسال حتى عودة الاتصال';
  static const String syncData = 'تحديث بيانات العمل دون اتصال';
  static const String syncDataHint =
      'تنزيل العملات والأدوية والزبائن والكميات للعمل دون اتصال';
  static const String syncing = 'جارٍ المزامنة…';
  static const String syncDone = 'تمت مزامنة البيانات بنجاح';
  static const String lastSynced = 'آخر مزامنة';
  static const String syncCurrencies = 'العملات';
  static const String syncMedicines = 'الأدوية';
  static const String syncCustomers = 'الزبائن';
  static const String syncStock = 'الكميات';
  static const String syncCategories = 'التصنيفات';
  static const String syncUnits = 'الوحدات';

  // Un-synced (queued) invoices — the POS "cloud" screen
  static const String pendingInvoices = 'فواتير غير مرحّلة';
  static const String pendingInvoicesEmpty = 'لا توجد فواتير بانتظار الترحيل';
  static const String unsyncedInvoice = 'فاتورة غير مرحّلة';
  static const String queuedStatusPending = 'بانتظار الترحيل';
  static const String queuedStatusFailed = 'فشل الترحيل';
  static const String deleteQueuedConfirm =
      'حذف هذه الفاتورة غير المرحّلة؟ ستُعاد الكميات إلى المخزون.';
  static const String itemsCountLabel = 'عدد الأصناف';
  static const String offlineToggleTooltip =
      'تبديل وضع الاتصال (أونلاين/أوفلاين)';

  // Currency
  static const String baseCurrencyFixedNote =
      'العملة الأساسية ثابتة ولا يمكن تغييرها (تُحدَّد عند إنشاء الحساب)';
  static const String rateEnterPositive = 'أدخل قيمة موجبة';

  // States
  static const String loading = 'جارٍ التحميل…';
  static const String noData = 'لا توجد بيانات';
  static const String emptyDefault = 'لا توجد بيانات لعرضها';
  static const String errorDefault = 'حدث خطأ ما';
  static const String noInternet = 'لا يوجد اتصال بالإنترنت';
  static const String noInternetHint = 'تحقق من اتصالك ثم أعد المحاولة';
  static const String successDefault = 'تمت العملية بنجاح';

  // Auth
  static const String login = 'تسجيل الدخول';
  static const String loginWelcome = 'مرحباً حكيم';
  static const String signIn = 'دخول';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String appTagline = 'نظام إدارة الصيدلية';
  static const String registerTitle = 'إنشاء حساب';
  static const String registerCta = 'إنشاء الحساب';
  static const String registerWelcome = 'أنشئ حساب صيدليتك';
  static const String emailOrPhone = 'البريد الإلكتروني أو رقم الهاتف';
  static const String phoneField = 'رقم الهاتف';
  static const String pharmacyNameField = 'اسم الصيدلية';
  static const String userNameOptional = 'اسم المستخدم (اختياري)';
  static const String emailOptional = 'البريد الإلكتروني (اختياري)';
  static const String registerSubtitle = 'أنشئ حساب صيدليتك في دقيقة';
  static const String currencyCannotChange =
      'تنبيه: لا يمكن تغيير العملة الأساسية بعد إنشاء الحساب.';
  static const String accountTitle = 'الحساب الشخصي';

  // صفحات التعريف (intro)
  static const String introStart = 'ابدأ الآن';
  static const String intro1Title = 'أهلاً بك في صيدليتي';
  static const String intro1Body = 'نظام متكامل لإدارة صيدليتك بسهولة ومن مكان واحد.';
  static const String intro2Title = 'نقطة بيع سريعة';
  static const String intro2Body = 'بِع بمسح الباركود وأصدر الفواتير في ثوانٍ.';
  static const String intro3Title = 'مخزون وتقارير ذكية';
  static const String intro3Body = 'تابع الأدوية والأرباح والصلاحيات لحظة بلحظة.';
  static const String intro4Title = 'يعمل دون اتصال';
  static const String intro4Body = 'عملياتك محفوظة وتُزامَن تلقائياً عند عودة الإنترنت.';
  static const String noAccountRegister = 'ليس لديك حساب؟ أنشئ حساباً جديداً';
  static const String haveAccountLogin = 'لديك حساب؟ سجّل الدخول';
  static const String logoutConfirm = 'هل تريد تسجيل الخروج؟';

  // Validation
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'أدخل بريداً إلكترونياً صحيحاً';

  // Barcode scanning
  static const String scanBarcode = 'مسح الباركود';
  static const String readyToScan = 'جاهز للمسح — وجّه الماسح نحو الباركود';
  static const String scannedCode = 'الرمز الممسوح';
  static const String noProductForBarcode = 'لا يوجد منتج بهذا الباركود';
  static const String barcodeNotFoundTitle = 'باركود غير موجود';
  static const String barcodeNotFoundBody =
      'لم يُعثر على دواء بهذا الباركود. هل تريد إضافته؟';

  // Settings — main warehouse (resolved automatically from the backend)
  static const String defaultWarehouse = 'المستودع الرئيسي';
  static const String defaultWarehouseHelp =
      'يعمل النظام بمستودع رئيسي واحد يُحدَّد تلقائياً من الخادم. لا حاجة لأي '
      'إعداد يدوي — تُسجَّل كل عمليات البيع والمخزون والمشتريات فيه.';
  static const String warehouseIdLabel = 'معرّف المستودع';
  static const String warehouseNotSet =
      'تعذّر تحديد المستودع الرئيسي — تأكّد من الاتصال بالخادم ثم أعد المحاولة.';
  static const String settingsSaved = 'تم حفظ الإعدادات';
  static const String saveFailed = 'تعذّر حفظ الإعداد — حاول مرة أخرى.';

  // Settings — general section
  static const String generalSettings = 'إعدادات عامة';
  static const String pharmacyName = 'اسم الصيدلية';
  static const String notSet = 'غير محدد';
  static const String changeWarehouse = 'تغيير المستودع';
  static const String changeWarehouseSoon =
      'إمكانية تغيير المستودع الرئيسي ستتوفّر قريباً (ميزة قادمة).';

  // Sales / POS
  static const String selectCurrency = 'اختر العملة';
  static const String paymentMethod = 'طريقة الدفع';
  static const String saleEmptyHint = 'امسح دواءً أو أضِفه للبدء';
  static const String addLine = 'إضافة دواء';
  static const String noPricedUnitForProduct = 'لا يوجد سعر لهذا الدواء';
  static const String productAdded = 'تمت الإضافة';
  static const String itemCountLabel = 'عدد الأصناف';
  static const String quantity = 'الكمية';
  static const String price = 'السعر';
  static const String unitLabel = 'الوحدة';
  static const String expiryDateLabel = 'تاريخ الصلاحية';
  static const String editLineTitle = 'تعديل السطر';
  static const String subtotalLabel = 'المجموع';
  static const String total = 'الإجمالي';
  static const String invoiceNote = 'بيان الفاتورة';
  static const String lineNote = 'بيان الصنف';
  static const String noteHint = 'اكتب بياناً (اختياري)';
  static const String newSale = 'فاتورة بيع';
  static const String saleDetails = 'تفاصيل الفاتورة';
  static const String editSale = 'تعديل الفاتورة';
  static const String customer = 'العميل';
  static const String noCustomer = 'بدون عميل';
  static const String saleSavedSuccess = 'تم حفظ الفاتورة';
  static const String salesList = 'فواتير المبيعات';
  static const String noSales = 'لا توجد فواتير';
  static const String invoiceNumberPrefix = 'فاتورة #';
  static const String searchMedicineHint = 'ابحث بالاسم أو الباركود';

  // Catalog CRUD (categories / manufacturers / units / currencies)
  static const String name = 'الاسم';
  static const String description = 'الوصف';
  static const String categoryName = 'اسم الصنف';
  static const String addCategory = 'إضافة صنف';
  static const String editCategory = 'تعديل صنف';
  static const String noCategories = 'لا توجد أصناف';
  static const String medicinesUnit = 'دواء';
  static const String manufacturers = 'الشركات الصانعة';
  static const String manufacturerName = 'اسم الشركة';
  static const String location = 'الموقع';
  static const String addManufacturer = 'إضافة شركة';
  static const String editManufacturer = 'تعديل شركة';
  static const String noManufacturers = 'لا توجد شركات';
  // Suppliers & Customers
  static const String contactPerson = 'جهة الاتصال';
  static const String addSupplier = 'إضافة مورّد';
  static const String editSupplier = 'تعديل مورّد';
  static const String noSuppliers = 'لا يوجد موردون';
  static const String addCustomer = 'إضافة عميل';
  static const String editCustomer = 'تعديل عميل';
  static const String noCustomers = 'لا يوجد عملاء';
  static const String firstName = 'الاسم الأول';
  static const String lastName = 'الكنية';
  static const String phone = 'الهاتف';
  static const String address = 'العنوان';
  static const String unitsList = 'الوحدات';
  static const String unitName = 'اسم الوحدة';
  static const String addUnit = 'إضافة وحدة';
  static const String editUnit = 'تعديل وحدة';
  static const String noUnits = 'لا توجد وحدات';
  static const String currenciesList = 'العملات';
  static const String currencyCode = 'الرمز (Code)';
  static const String currencyName = 'اسم العملة';
  static const String currencySymbol = 'الرمز المختصر';
  static const String exchangeRateLabel = 'سعر الصرف';
  static const String isBaseCurrency = 'العملة الأساسية';
  static const String addCurrency = 'إضافة عملة';
  static const String editCurrency = 'تعديل عملة';
  static const String noCurrencies = 'لا توجد عملات';
  static const String setAsBase = 'تعيين كأساسية';
  static const String baseBadge = 'أساسية';
  static const String editRate = 'تعديل سعر الصرف';
  static const String baseCurrencyLabel = 'العملة الأساس';
  static const String exchangeRateHint = 'كم تساوي وحدة من هذه العملة بعملة الأساس';
  static const String rateHistory = 'سجلّ أسعار الصرف';
  static const String noRateHistory = 'لا يوجد سجلّ لأسعار الصرف';

  // Medicine form
  static const String addMedicine = 'إضافة دواء';
  static const String editMedicine = 'تعديل دواء';
  static const String brandName = 'الاسم التجاري';
  static const String genericName = 'الاسم العلمي';
  static const String strength = 'التركيز';
  static const String expirationDate = 'تاريخ انتهاء الصلاحية';
  static const String selectCategory = 'اختر الصنف';
  static const String selectManufacturer = 'اختر الشركة (اختياري)';
  static const String selectUnit = 'اختر الوحدة';
  static const String pricedUnits = 'الوحدات والأسعار';
  static const String addPricedUnit = 'إضافة وحدة';
  static const String medicineSavedSuccess = 'تم حفظ الدواء';
  static const String atLeastOneUnit = 'أضِف وحدة واحدة على الأقل';
  static const String conversionFactor = 'معامل التحويل';
  static const String conversionFactorHint = 'كم وحدة أساسية داخل هذه الوحدة';
  static const String baseUnit = 'أساسية';
  static const String defaultUnit = 'افتراضية';
  static const String baseUnitHelp =
      'حدّد وحدة أساسية واحدة (معاملها = 1). تُحسب باقي الوحدات نسبةً إليها.';
  static const String selectOneBaseUnit = 'يجب تحديد وحدة أساسية واحدة';
  static const String purchaseCostLabel = 'تكلفة الشراء (للوحدة الأساسية)';
  static const String editOnlineOnly = 'تعديل الكتالوج يتطلب اتصالاً بالإنترنت';

  // Stock / inventory
  static const String stockTitle = 'المخزون';
  static const String addStock = 'إضافة مخزون';
  static const String receiveStock = 'استلام مخزون';
  static const String noStock = 'لا يوجد مخزون';
  static const String selectMedicine = 'اختر الدواء';
  static const String stockSavedSuccess = 'تم حفظ المخزون';
  static const String available = 'المتوفر';
  static const String expiry = 'الصلاحية';
  static const String stockMovements = 'حركات المخزون';
  static const String noMovements = 'لا توجد حركات';
  static const String movementIn = 'وارد';
  static const String movementOut = 'صادر';
  static const String all = 'الكل';
  static const String filterByMedicine = 'تصفية حسب الدواء';
  static const String filterByCategory = 'تصفية حسب الصنف';
  static const String filterByCustomer = 'تصفية حسب العميل';
  static const String filterByCurrency = 'تصفية حسب العملة';
  // فلترة عامة (قائمة جانبية)
  static const String filters = 'تصفية';
  static const String clearFilters = 'مسح الفلاتر';
  static const String periodYear = 'هذه السنة';
  static const String periodAll = 'كل الفترات';

  // Purchases
  static const String purchasesTitle = 'المشتريات';
  static const String newPurchase = 'فاتورة شراء';
  static const String editPurchase = 'تعديل فاتورة الشراء';
  static const String noPurchases = 'لا توجد فواتير شراء';
  static const String purchaseSavedSuccess = 'تم حفظ فاتورة الشراء';
  static const String supplier = 'المورّد';
  static const String unitCost = 'سعر التكلفة';
  static const String purchaseEmptyHint = 'أضِف دواءً لبدء فاتورة الشراء';
  static const String purchaseDetails = 'تفاصيل فاتورة الشراء';

  // Reports — medicine report
  static const String medicineReport = 'تقرير الدواء';
  static const String noMedicineForBarcode = 'لا يوجد دواء بهذا الباركود';
  static const String viewReport = 'عرض التقرير';
  static const String stockQuantity = 'الرصيد (المخزون)';
  static const String soldQuantity = 'المُباع';
  static const String reservedQuantity = 'المحجوز';
  static const String totalSales = 'إجمالي المبيعات';
  static const String transactionsCount = 'عدد العمليات';
  static const String unitPriceLabel = 'سعر الوحدة';
  static const String nearExpiry = 'قرب انتهاء الصلاحية';
  static const String lowStockFlag = 'مخزون منخفض';
  static const String code = 'الرمز';
  static const String notes = 'ملاحظات';

  // Medicines
  static const String medicinesList = 'الأدوية';
  static const String noMedicines = 'لا توجد أدوية';
  static const String medicineDetails = 'تفاصيل الدواء';
  static const String barcode = 'الباركود';
  static const String dosageForm = 'شكل الجرعة';
  static const String category = 'الصنف';
  static const String manufacturer = 'الشركة الصانعة';
  static const String salePrice = 'سعر البيع';
  static const String purchasePrice = 'سعر الشراء';
  static const String units = 'الوحدات';

  // Offline / pending queue
  static const String offlineNotice =
      'وضع عدم الاتصال — تُحفظ العمليات وتُرحّل لاحقاً';
  static const String pendingOperations = 'عمليات بانتظار الترحيل';
  static const String syncNow = 'ترحيل الآن';
  static const String syncingNow = 'جاري الترحيل…';

  // إعدادات المبيعات
  static const String salesSettings = 'إعدادات المبيعات';
  static const String allowNegativeSale = 'السماح بالبيع في السالب';
  static const String allowNegativeSaleHint =
      'إتمام البيع حتى لو كان المخزون غير كافٍ (يصبح الرصيد سالباً)';

  // تنويه سعر البيع أقل من الكلفة (نموذج الدواء)
  static const String priceBelowCostTitle = 'سعر أقل من الكلفة';
  static const String priceBelowCostBody =
      'سعر البيع لبعض الوحدات أقل من سعر الكلفة. هل تريد المتابعة؟';

  // نقطة البيع: وصفة طبية / ربح سالب / بيع في السالب
  static const String prescriptionLabel = 'وصفة طبية';
  static const String prescriptionNeedsCustomer = 'الوصفة الطبية تتطلب اختيار عميل';
  static const String creditSaleNeedsCustomer = 'البيع الآجل يتطلب اختيار عميل';
  static const String creditPurchaseNeedsSupplier = 'الشراء الآجل يتطلب اختيار مورّد';
  static const String actionsColumn = 'الإجراءات';
  static const String saleReturnAction = 'مرتجع مبيعات';
  static const String purchaseReturnAction = 'مرتجع مشتريات';
  static const String negativeProfitTitle = 'ربح سالب';
  static const String negativeProfitBody =
      'سعر البيع أقل من الكلفة لبعض الأصناف وسيصبح الربح سالباً. هل تريد المتابعة؟';
  static const String negativeStockTitle = 'بيع في السالب';
  static const String negativeStockBody =
      'المخزون غير كافٍ وسيصبح سالباً للأصناف التالية:';
  static const String insufficientStockTitle = 'المخزون غير كافٍ';
  static const String insufficientStockBody =
      'المخزون غير كافٍ للأصناف التالية (البيع في السالب غير مسموح):';
  static const String continueLabel = 'متابعة';

  // تصدير الفاتورة PDF
  static const String exportPdf = 'تصدير PDF';
  static const String invoiceDocTitle = 'فاتورة مبيعات';

  // تقرير الوصفات الطبية
  static const String prescriptionsReport = 'تقرير الوصفات الطبية';
  static const String prescriptionsReportHint = 'الوصفات الطبية مع العملاء';
  static const String noPrescriptions = 'لا توجد وصفات طبية';

  // الجرد: أساس التسعير
  static const String priceBasis = 'أساس التسعير';

  // إضافة وحدة سريعة من نموذج الدواء
  static const String addNewUnit = 'وحدة جديدة';
  static const String unitNameLabel = 'اسم الوحدة (علبة، شريط، حبة…)';
  static const String unitCreated = 'تمت إضافة الوحدة';

  // تفاصيل الفاتورة: الكلفة والربح
  static const String costLabel = 'الكلفة';
  static const String profitLabel = 'الربح';

  // تسعير سريع
  static const String quickPricing = 'تسعير سريع';
  static const String quickPricingHint = 'عدّل أسعار البيع لكل وحدة بسرعة.';
  static const String pricesSaved = 'تم حفظ الأسعار';
  static const String costPerUnit = 'الكلفة/الوحدة';

  // معلومات عنا (About)
  static const String aboutApp = 'معلومات عنا';
  static const String aboutWhoTitle = 'من نحن';
  static const String aboutBody =
      '«صيدليتي» تطبيق عربي صُمّم خصيصاً لتسهيل إدارة الصيدلية: بيع أسرع، مخزون '
      'دقيق، وقرارات أوضح. نطوّره باستمرار بالإنصات لاحتياجات الصيادلة.';
  static const String aboutPartnerWith = 'بالشراكة مع';
  static const String aboutPartnerBody =
      'نفخر بشراكتنا مع CodeTech، شركة متخصّصة في تطوير البرمجيات والحلول الرقمية.';
  static const String aboutFollowUs = 'تابعنا';
  static const String officialSite = 'الموقع الرسمي';
  static const String telegramLabel = 'تيليجرام';
  static const String facebookLabel = 'فيسبوك';
  static const String versionLabel = 'الإصدار';
  static const String linkOpenFailed = 'تعذّر فتح الرابط';

  // الجولة التعليمية (onboarding)
  static const String help = 'المساعدة';
  static const String skip = 'تخطّي';
  static const String next = 'التالي';
  static const String replayTour = 'إعادة الجولة التعليمية';
  static const String onbSalesTitle = 'المبيعات';
  static const String onbSalesText = 'من هنا تُنشئ فواتير البيع (نقطة البيع).';
  static const String onbProductsTitle = 'الأدوية';
  static const String onbProductsText =
      'كتالوج الأدوية. سنبدأ بإضافة أول دواء — اضغط «الأدوية».';
  static const String onbReportsTitle = 'التقارير';
  static const String onbReportsText =
      'تقارير المبيعات والأرباح والمخزون، ومنها تدخل إلى المشتريات.';
  static const String onbMoreTitle = 'المزيد';
  static const String onbMoreText = 'الموردون والعملاء والعملات والإعدادات.';
  static const String onbAddMedicineTitle = 'إضافة دواء';
  static const String onbAddMedicineText = 'اضغط زر + لإضافة دواء جديد.';
  static const String onbMedNameTitle = 'اسم الدواء';
  static const String onbMedNameText = 'أدخل الاسم التجاري أو العلمي للدواء.';
  static const String onbMedCategoryTitle = 'الصنف';
  static const String onbMedCategoryText = 'اختر صنف الدواء من القائمة.';
  static const String onbMedUnitsTitle = 'الوحدات والأسعار';
  static const String onbMedUnitsText =
      'حدّد الوحدة الأساسية وسعر البيع. يمكنك إضافة وحدات أخرى بمعاملات.';
  static const String onbMedSaveTitle = 'حفظ الدواء';
  static const String onbMedSaveText =
      'احفظ الدواء، ثم اذهب إلى «التقارير» ← «المشتريات» لإضافة أول فاتورة.';
  static const String onbAddPurchaseTitle = 'فاتورة مشتريات';
  static const String onbAddPurchaseText =
      'اضغط لإضافة أول فاتورة مشتريات: اختر المورد والأصناف ثم احفظ.';

  // نقطة البيع: سحب للحذف + تراجع
  static const String lineDeleted = 'تم حذف الصنف';
  static const String undo = 'تراجع';
}
