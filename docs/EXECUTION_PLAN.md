# خطة تنفيذ الفرونت — صيدليتي (saydaliati)

خطة تنفيذية مرحلية لواجهة تطبيق **صيدليتي** فوق باك إند `Pharmacy.api`
(`C:\Users\Ibrahem\RiderProjects\Pharmacy.api`). مبنية على العقد الفعلي للـ API
(النقاط النهائية + الكيانات + حقول الـ DTOs) وعلى الأساس القابل لإعادة الاستخدام
الموجود مسبقاً في المشروع (Clean Architecture + Riverpod + Freezed + go_router +
Dio + drift/offline).

> **مبادئ ثابتة:** كل مرحلة تُنتج تطبيقاً **يعمل**. لا نبني اختبارات في الفرونت.
> لا نبني «سلة» (PosCart/CartItem) — الفاتورة تُبنى في الذاكرة وتُرسَل مباشرة.
> الواجهة عربية/RTL بالكامل، خط Cairo، ألوان الصيدلية الخضراء.

---

## 0) ملخص تنفيذي — الحالة (مُحدّث)

| المرحلة | العنوان | الحالة | الناتج الذي «يعمل» |
|--------|---------|:------:|--------------------|
| **P0** | التأسيس والربط | ✅ **مكتمل** | اتصال بالـ API + لوحة مؤشرات حيّة |
| **P1** | الكتالوج (قراءة) + **شاشة البيع** | ✅ **مكتمل** | مسح باركود → إصدار فاتورة بيع فعلية (أوفلاين + طابور) |
| **P2** | إدارة الكتالوج (CRUD) | ✅ **مكتمل** | أدوية/أصناف/شركات/وحدات/عملات (إضافة/تعديل/حذف) |
| **P3** | المخزون والمشتريات | ✅ **مكتمل** | استلام مخزون + فواتير شراء + حركات مخزون |
| **P4** | المحاسبة والتقارير والإعدادات | 🟡 **جزئي** | ✅ تقرير الدواء + الإعدادات · ⬜ الحسابات والقيود |

**القاعدة الذهبية:** «يعمل المشروع» فعلياً منذ **P0 + P1**. الآن يغطّي التطبيق
المسار التشغيلي الكامل: **شراء → مخزون → بيع** + تقارير الأدوية.

### 0.1 ما أُنجز فعلياً (تفصيلاً)
- **P0:** `AppConfig` + `ApiEndpoints` (كل مسارات `pharmacy-api`) + `core/enums`
  (PaymentMethod/DosageForm/StockMovementType/AccountType) + ميزة **Dashboard**
  (لوحة المؤشرات الحيّة في الرئيسية).
- **P1:** ميزات `currencies` (قراءة+كاش) · `medicines` (كتالوج قراءة/بحث/كاش
  بالباركود + قائمة + تفاصيل + منتقي) · `settings` (المستودع الافتراضي) ·
  `sales` (**شاشة POS**: ماسح مضمّن + سطور + إجمالي + حفظ عبر الطابور/أوفلاين،
  قائمة فواتير + تفاصيل).
- **P2:** `categories` / `manufacturers` / `medicine_units` (CRUD) · `currencies`
  (CRUD + تعيين الأساسية + سعر الصرف) · **نموذج الدواء** (إضافة/تعديل + أسعار
  الوحدات) · حوار `showEntityFormDialog` قابل لإعادة الاستخدام.
- **P3:** `stock` (عرض + استلام مخزون + حذف) · `purchases` (فاتورة شراء POS +
  قائمة + تفاصيل) · `stock_movements` (سجل حركات للقراءة).
- **P4 (جزئي):** `reports` — **تقرير الدواء** `Report/medicine-report/{id}`
  (شاشة مؤشرات + شارات نفاد/انتهاء) بمدخل من تفاصيل الدواء. الإعدادات موجودة.

### 0.2 المتبقّي
- **P4 المحاسبة:** شجرة الحسابات (`Account`) + القيود (`JournalEntry` +
  `JournalEntryDetail`) — لم تُبنَ بعد (شاشاتها placeholder ضمن «المزيد»).
- **لوحة تقارير موسّعة** (تجميع/فلاتر) — اختياري.
- **اعتماديات باك (تحجب اكتمالاً):** لا CRUD للزبائن/المورّدين/المستودعات، ولا
  Auth — راجع §1 و§9. البيع عابر، والمستودع من الإعدادات.
- **الصلاحيات:** ✅ أُعدّت (إنترنت/كاميرا/شبكة + cleartext للـ HTTP + minSdk).
  راجع §11.

---

## 1) فجوات الباك إند (اقرأها أولاً — تحدد ما يمكن بناؤه)

هذه ليست موجودة في الـ API الحالي رغم وجود كياناتها، لذا **لا نبني لها شاشات
الآن**، ونتعامل معها كالتالي:

| المفقود | الأثر على الفرونت | الحل المؤقّت |
|---------|-------------------|--------------|
| **Auth / Login** (لا endpoint) | كل النقاط مفتوحة (anonymous) | **لا بوابة دخول** — نبدأ مباشرة على الشِّل. بنية الجلسة تبقى في `core/session` جاهزة للتفعيل لاحقاً. |
| **Customer** (لا CRUD) | لا يمكن سرد/إضافة زبائن | البيع **عابر/نقدي**: `customerId = null`. |
| **Warehouse** (لا CRUD) | البيع/المخزون يحتاج `warehouseId` | نحلّه عبر **Settings** (مفتاح `default_warehouse_id`) أو من `Stock/medicine/{id}/warehouses`. راجع §5. |
| **Supplier** (لا CRUD) | فاتورة الشراء تحتاج مورّداً | `supplierId = null` (اختياري في الأمر). |
| **PosCart / CartItem** | — | **لا نستخدمها** (بطلب المستخدم). |

> **مهمة على الباك (اعتمادية):** لكي تعمل المبيعات والمخزون بشكل كامل نحتاج على
> الأقل نقطة **قائمة المستودعات** (`GET .../Warehouse`) وتحديد المستودع الرئيسي
> (`IsMain`)، وربما CRUD للزبائن والمورّدين. مذكورة في §9.

---

## 2) إعداد الربط (Online) — P0

### 2.1 عنوان الخادم والمسارات
- الأساس: `pharmacy-api/[Controller]` — **باستثناء** البدائل: `api/Alternatives`.
- لا يوجد بادئة `/api/` عامة ولا إصدارات (versioning).
- عدّل `lib/core/config/app_config.dart` → `apiBaseUrl` (host فقط، مثل
  `http://localhost:5000` أو `http://<lan-ip>:<port>`). المسارات تحمل بادئتها بنفسها.

### 2.2 المغلّف (Envelope) — **متوافق مع الأساس الحالي**
النجاح: `{ "succeeded": true, "data": <T>, "errors": {} }` (camelCase) —
يقرؤه `ApiEnvelope` الموجود دون تعديل. أخطاء الاستثناءات تأتي بشكل مختلف:
`{ "message": "...", "errors": { "Key": ["..."] }, "traceId": "..." }` —
و`ApiEnvelope._flatMessageErrors` يلتقط `message`. **لا حاجة لتعديل طبقة الشبكة.**

> تنبيه: أكواد الأخطاء **بالعربية** أحياناً — طابِق على المفتاح/الحالة لا على النص.

### 2.3 الترقيم (Pagination)
كل قوائم `GetAll` ترجع **مصفوفة مباشرة** (لا يوجد غلاف صفحات / لا `totalCount`).
الاستعلام: `?limit={int}&offset={int}` (الأسماء `limit`/`offset`، الربط غير حسّاس
لحالة الأحرف). ⇒ نستخدم `PagedListView` مع `hasMore = returnedCount == limit`.

### 2.4 تعدادات (Enums) — تُرسل/تُقرأ كأرقام صحيحة
أنشئ `lib/core/enums/` بهذه القيم **بالضبط**:

```dart
// payment_method.dart
enum PaymentMethod { cash, creditCard, debitCard, bankTransfer, mobileWallet }
// wire: cash=1, creditCard=2, debitCard=3, bankTransfer=4, mobileWallet=5

// dosage_form.dart  (شكل الجرعة)
enum DosageForm { tablet, capsule, syrup, injection, cream, ointment, gel,
                  drops, inhaler, suppository, powder, lotion }
// wire: 1..12 بالترتيب أعلاه

// stock_movement_type.dart
enum StockMovementType { purchaseReceipt, purchaseReturn, saleIssue, saleReturn,
                         stockAdjustmentPlus, stockAdjustmentMinus }
// wire: 0..5 بالترتيب أعلاه

// account_type.dart
enum AccountType { asset, liability, equity, revenue, expense, contraAsset }
// wire: 1..6 بالترتيب أعلاه
```
كل enum: getter `int get wire` + `static fromWire(int)` + `String get label`
(عربي) — على نمط النواة.

### 2.5 جدول النقاط النهائية → `ApiEndpoints`
حدّث `lib/core/network/api_endpoints.dart` (كل المسارات تحت `pharmacy-api/…`):

| المورد | المسارات |
|--------|----------|
| Medicine | `GET /Medicine?name=&limit=&offset=` · `GET /Medicine/{id}` · `POST /Medicine` · `PUT /Medicine/{id}` · `DELETE /Medicine/{id}` |
| MedicineUnit | `GET/POST /MedicineUnit` · `PUT/DELETE /MedicineUnit/{id}` |
| MedicineUnitPrice | `GET/POST /MedicineUnitPrice` · `PUT/DELETE /MedicineUnitPrice/{id}` |
| Alternatives | `GET/POST /api/Alternatives` · `GET/PUT/DELETE /api/Alternatives/{id}` |
| Category | `GET/POST /Category` · `PUT/DELETE /Category/{id}` |
| Manufacturer | `GET/POST /Manufacturer` · `PUT/DELETE /Manufacturer/{id}` |
| Currency | `GET/POST /Currency` · `PUT/DELETE /Currency/{id}` · `POST /Currency/ChangeBaseCurrency?currencyId=&isBaseCurrency=` |
| ExchangeRate | `POST /ExchangeRate?currencyId=&exchangeRate=` |
| Stock | `GET/POST /Stock` · `GET/PUT/DELETE /Stock/{id}` · `GET /Stock/medicine/{medicineId}/warehouses?excludeExpired=&includeZeroWarehouses=` |
| StockMovement | `GET /StockMovement?medicineId=&warehouseId=&from=&to=&limit=&offset=` · `GET /StockMovement/{id}` |
| Sale | `GET/POST /Sale` · `GET/PUT/DELETE /Sale/{id}` |
| Purchase | `GET/POST /Purchase` · `GET/PUT/DELETE /Purchase/{id}` |
| Account | `GET/POST /Account` · `GET/PUT/DELETE /Account/{id}` |
| JournalEntry | `GET/POST /JournalEntry` · `GET/DELETE /JournalEntry/{id}` (لا PUT) |
| JournalEntryDetail | `GET/POST /JournalEntryDetail?journalEntryId=` · `PUT/DELETE /JournalEntryDetail/{id}` |
| Dashboard | `GET /Dashboard` |
| Report | `GET /Report/medicine-report/{medicineId}` |
| Setting | `GET/POST /Setting` · `GET/DELETE /Setting/{key}` |

### 2.6 مهام P0 (Definition of Done)
- [ ] `apiBaseUrl` يشير للخادم الحقيقي (عبر `--dart-define=API_BASE_URL=`).
- [ ] `ApiEndpoints` محدّث بالكامل كما أعلاه.
- [ ] `core/enums/` أُنشئت بالقيم الصحيحة.
- [ ] ميزة `dashboard`: نداء واحد `GET /Dashboard` يعرض بطاقات المؤشرات على
      الواجهة الرئيسية (بديل قيم `—` الحالية) → يثبت أن السلسلة كاملة تعمل.
- **يعمل:** التطبيق يفتح ويعرض مؤشرات حقيقية من الخادم.

---

## 3) نموذج البيانات في الفرونت (حسب الميزة)

لكل ميزة: **Entity** (Freezed) ← **DTO** (json_serializable) ← **Mapper** ←
**Cache table** (إن وُجدت). المفاتيح كلها `String` (Guid). التعدادات أرقام.
حقول `CreatedBy/CreatedOn/UpdatedBy/UpdatedOn` تُقرأ فقط (لا تُرسل).

### 3.1 Medicine (الدواء) — جوهر الكتالوج
**قراءة `MedicineResponseDto`:** `id, categoryId, genericName, brandName,
strength(num), barcode, manufacturerId?, sideEffects, dosageForm(int),
description, note, yearsOfValidity(int), manufacturingDate, expirationDate,
category{id,categoryName,description}, manufacturer{id,name,location},
unitPrices[]`
**`unitPrices[]` (`MedicineUnitPriceDto`):** `medicineId, unitId,
unit{id,name,description}, purchasePrice(num), salePrice(num)`
**إنشاء `CreateMedicine`:** `categoryId*(req), genericName, brandName*(req),
strength, barcode, manufacturerId?, sideEffects, dosageForm, description, note,
yearsOfValidity, manufacturingDate, expirationDate, unitPrices[]{unitId,
purchasePrice, salePrice}`
**قائمة:** `GET /Medicine?name=&limit=&offset=` (لعرض الكل مرّر `name=`).
**Entity الفرونت (مبسّط للبيع):** `id, brandName, genericName, barcode,
categoryId, dosageForm, units: [{unitId, unitName, salePrice, purchasePrice}]`.
**Cache:** `entityType='medicines'`, `name=brandName`, `code=barcode` (للبحث/المسح
دون اتصال).

### 3.2 MedicineUnit (الوحدة): `id, name, description` — Cache `units` (`name`).
### 3.3 Category (الصنف): `id, categoryName, description` — Cache `categories`.
### 3.4 Manufacturer (الشركة): `id, name, location` — Cache `manufacturers`.
### 3.5 Currency (العملة): `id, code, name, symbol, exchangeRate(num),
isBaseCurrency(bool), isActive(bool)` — Cache `currencies`.
- تغيير الأساس: `POST /Currency/ChangeBaseCurrency?currencyId=&isBaseCurrency=`
- تعديل السعر: `POST /ExchangeRate?currencyId=&exchangeRate=`

### 3.6 Stock (المخزون): `id, medicineId, expiryDate, quantityAvailable(num),
purchasePrice, sellingPrice, supplierId, dateReceived, medicine{...}`
- **إنشاء:** `expiryDate, quantityAvailable, purchasePrice, medicineId,
  warehouseId, dateReceived` (لا sellingPrice/supplier عند الإنشاء).
- مخزون الدواء حسب المستودع: `GET /Stock/medicine/{id}/warehouses` →
  `[{warehouseId, warehouseName, quantity}]` (مصدر المستودعات المتاح حالياً!).

### 3.7 StockMovement (حركة مخزون، قراءة فقط): `stockId, medicineId, warehouseId,
quantityDelta(num), type(int), occurredOn, referenceType, referenceId?,
unitCost?, unitPrice?, batchNo, expiryDate?, note`.

### 3.8 Sale (فاتورة البيع) — التفاصيل في §4.
**قراءة `SaleResponseDto`:** `id, customerId?, saleDate, totalAmount(num),
paymentMethod(int), customer{...}?, currency{...}, items[], journalEntryId?`
**`items[]`:** `id, medicineId, unitId, individual(num=سعر الوحدة),
quantity(num), discount(num), subTotal(num, محسوب على الخادم), medicine{...},
unit{...}, warehouse{...}`

### 3.9 Purchase (فاتورة شراء): `id, purchaseDate, totalAmount, user{...},
items[]{id, warehouseId, medicineId, unitId, unitPrice(num), quantity(num),
subTotal, expiryDate?, note}`.
**إنشاء:** `supplierId?, userId?, currencyId, warehouseId, paymentMethod, note,
purchaseDate, totalAmount, items[]{warehouseId, medicineId, unitId, unitPrice,
quantity, note, expiryDate?}`.

### 3.10 Dashboard: `salesToday(num), salesInvoicesToday(int),
purchasesThisMonth(num), lowStock(int), lowStockList[]{medicineId, brandName,
quantityAvailable}, expiringMedicines(int), expiringList[]{id, brandName,
expirationDate, daysLeft(int)}, totalMedicines, totalCustomers, totalSuppliers`.

### 3.11 المحاسبة (لاحقة): Account `{id, name, code, parentId?, accountType(int),
isActive, currentBalance}` · JournalEntry `{id, date, description,
totalDepit(num — إملاء الخادم!), totalCredit, journalEntryDetails[]}`.

### 3.12 Setting: `{id, key, value(string JSON خام)}` — نخزّن هنا
`default_warehouse_id` وأي تفضيلات.

> **تحذيرات إملاء محفوظة في العقد:** `totalDepit` (بدل Debit)، `createOn`
> (مع `createdOn`). التزم بها حرفياً في الـ DTO.

---

## 4) شاشة البيع (POS) — نفس واجهة الديون  🔴 قلب المشروع

نُعيد **نفس تصميم** `sale_form.dart` من تطبيق الديون (نظيف وسهل)، مع تكييف
الدلالات لباك الصيدلية (لا دَيْن، الزبون اختياري، لا سلة).

### 4.1 تخطيط الشاشة (من الأعلى للأسفل)
1. **كاميرا مضمّنة دائمة** (`_EmbeddedScanner`) — تبقى شغّالة داخل الواجهة، مع
   زر تشغيل/إيقاف وفلاش، وdebounce (٢ ثانية لنفس الكود)، وصافرة `ScannerBeep`
   عند الالتقاط. تقتصر على صيغ الباركود الخطية (تتجاهل QR).
2. **طريقة الدفع** (بدل «نقدي/آجل»): `SegmentedButton`/قائمة صغيرة على
   `PaymentMethod` (نقدي افتراضياً). *(لا يوجد دَيْن في هذا الباك، فلا تقسيم
   نقدي/آجل مرتبط بذمم.)*
3. **العملة** (Dropdown، الأساسية افتراضياً) — و**الزبون معطّل حالياً** (لا API؛
   يظهر عند توفّره).
4. **منتقي دواء يدوي** (`ProductPickerField`) — بحث بالاسم/الباركود يضيف سطراً.
5. **سطور الفاتورة** — كل سطر: اسم الدواء + الوحدة/السعر (قابل للتعديل بالنقر)،
   عدّاد كمية (± و«اكتب رقماً»)، ملاحظة سطر اختيارية، الإجمالي، زر حذف. تحذير
   «تجاوز المخزون» إن عُرفت الكمية المتاحة الموجبة (لا يمنع البيع).
6. **شريط الملخّص**: رقائق (خصم كامل الفاتورة % أو مبلغ، بيان الفاتورة، طريقة
   الدفع) + الإجمالي الكبير + زر **حفظ** (أخضر).
7. **وميض بعد المسح** (Flash) يعرض «تمت الإضافة/× الكمية» + عدد الأصناف.

### 4.2 المكوّنات المُعاد استخدامها (منقولة جاهزة)
- `shared/audio/scanner_beep.dart` ✅ موجود.
- `_EmbeddedScanner` + `ProductPickerField` (يُنقلان من الديون؛ الأخير بحث محلي
  عبر `EntityCache.search`).
- كل عناصر النواة/المشترك (AppButton, AppDropdown, AppNumberField, states…).

### 4.3 الإرسال — بناء `CreateSaleRequest`
عند الحفظ نبني الطلب مباشرة (لا سلة):
```
POST pharmacy-api/Sale
{
  "customerId": null,                 // عابر (لا API للزبائن بعد)
  "userId": null,
  "currencyId": <selected>,
  "warehouseId": <default — راجع §5>,
  "saleDate": <now ISO>,
  "note": <invoiceNote?>,
  "totalAmount": <netTotal بعد الخصم>,
  "paymentMethod": <enum.wire>,
  "items": [
    { "medicineId": <id>, "unitId": <unitId>, "warehouseId": <default>,
      "currencyId": <selected>, "individual": <unitPrice>,
      "quantity": <qty>, "discount": <lineDiscount|0> }
  ]
}
```
- `subTotal` محسوب على الخادم — لا نرسله.
- خصم كامل الفاتورة: وزّعه على السطور أو أرسله كـ `discount` على أول سطر /
  اطرحه من `totalAmount` (نُثبّت السلوك في التنفيذ؛ الأبسط: `totalAmount` صافٍ
  و`discount` لكل سطر صفر ما لم يُحدَّد).
- بعد النجاح: مسح السطور، إعادة الافتراضيات، صافرة/سناك بار نجاح، وطباعة/مشاركة
  الفاتورة (اختياري لاحقاً).

### 4.4 أوفلاين للبيع (مهم)
- المسح والتسعير يعملان **دون اتصال** من كاش الأدوية/الوحدات/العملات.
- الإرسال يمرّ عبر `OfflineWriteGate` بنوع `createSale`، ويُسجَّل في
  `outboxEndpointsProvider`: `{'createSale': ApiEndpoints.sales}`. المحرّك
  `SyncController` يُرحّلها تلقائياً عند عودة الاتصال. (id مُولّد بـ uuid للفكرة
  الاصطلاحية — لكن هذا الباك يولّد Id بنفسه، لذا نعامل الإرسال كـ POST idempotent
  منطقياً بمفتاح عميل محلي فقط لمنع التكرار داخل الطابور.)

### 4.5 مكان الشاشة
تبويب **المبيعات** (`SalesPage` الحالي) يُستبدل بهذه الشاشة كاملة، وتبقى أيضاً
متاحة كإجراء سريع من الرئيسية. قائمة فواتير المبيعات (`GET /Sale`) شاشة منفصلة
بسيطة (`PagedListView`).

---

## 5) حلّ المستودع الافتراضي (يحجب البيع والمخزون)

البيع/الشراء/المخزون يتطلب `warehouseId`، ولا يوجد endpoint لقائمة المستودعات.
**استراتيجية تدريجية:**
1. **P1 (الأبسط):** خزّن `default_warehouse_id` في **Settings**
   (`GET /Setting/default_warehouse_id`). إن غاب → شاشة إعداد أوّلي تطلب من
   المستخدم لصق/إدخال معرّف المستودع مرة واحدة (يُحفظ عبر `POST /Setting`).
2. **بديل:** استنتجه من `GET /Stock/medicine/{anyId}/warehouses` (يرجع
   warehouseId + الاسم) واختر `IsMain`/الأول.
3. **الأمثل (اعتمادية باك):** إضافة `GET pharmacy-api/Warehouse` → عندها Dropdown
   حقيقي لاختيار المستودع في البيع/الشراء.

نغلّف الحل بـ `warehouseProvider` واحد يُرجع المعرّف الافتراضي، فتتبدّل
الاستراتيجية دون لمس شاشات البيع.

---

## 6) استراتيجية الأوفلاين (لكل ميزة)

| البيانات | النمط | ملاحظات |
|----------|------|---------|
| medicines, units, currencies, categories, manufacturers | **Cache-first** (`EntityCache`) | تُسحب وتُخزّن؛ المسح/التسعير يعمل دون اتصال. |
| المبيعات (كتابة) | **Outbox** (`createSale`) | تُرحّل تلقائياً عند الاتصال. |
| stocks, purchases, movements, dashboard, reports, accounting | **Online-first** | يُعرض `OnlineOnlyView` دون اتصال؛ لا حاجة لكاش الآن. |
| كتابات الكتالوج (إضافة دواء/صنف…) | **Online-only** | تعديل الكتالوج يتطلب اتصالاً؛ نمنعه دون اتصال برسالة واضحة. |

`outboxEndpointsProvider` يُملأ في `app_bootstrap.dart`:
```dart
outboxEndpointsProvider.overrideWithValue({ 'createSale': ApiEndpoints.sales })
```

---

## 7) خارطة المراحل التفصيلية (قابلة للتنفيذ مرحلة مرحلة)

> كل عنصر ميزة يتبع قالب `lib/features/README.md`
> (data/domain/presentation + ملف providers للـ DI).

### 🔴 P0 — التأسيس والربط
- [ ] `AppConfig.apiBaseUrl` + `ApiEndpoints` كاملة + `core/enums/`.
- [ ] ميزة `dashboard`: `GET /Dashboard` → بطاقات المؤشرات في الرئيسية.
- **يعمل:** اتصال حيّ + مؤشرات حقيقية.

### 🔴 P1 — الكتالوج (قراءة) + شاشة البيع  ← «المشروع يعمل» هنا
1. [ ] `currencies` (قراءة + كاش) — لازمة للبيع.
2. [ ] `medicine_units` (قراءة + كاش).
3. [ ] `categories` + `manufacturers` (قراءة + كاش) — لعرض/فلترة الأدوية.
4. [ ] `medicines` (قراءة/بحث `name` + كاش، `code=barcode`) + شاشة قائمة الأدوية
       (`PagedListView`) + شاشة تفاصيل.
5. [ ] **شاشة البيع POS** (§4) + نقل `_EmbeddedScanner` و`ProductPickerField`.
6. [ ] `warehouseProvider` (§5، عبر Settings).
7. [ ] أوفلاين البيع (Outbox `createSale`) + شارة الطابور (موجودة).
8. [ ] قائمة فواتير المبيعات (`GET /Sale`) + تفاصيل فاتورة.
- **يعمل:** صيدلي يمسح باركود → يضيف أدوية → يحفظ فاتورة بيع فعلية (حتى دون اتصال
  ثم تُرحّل تلقائياً).

### 🟠 P2 — إدارة الكتالوج (CRUD)
- [ ] `medicines`: إنشاء/تعديل (مع `unitPrices[]` والبدائل `Alternatives`).
- [ ] `categories` / `manufacturers` / `medicine_units`: CRUD كامل + حوارات إضافة سريعة.
- [ ] `currencies`: CRUD + تغيير الأساس + تعديل سعر الصرف (`ExchangeRate`).
- [ ] `medicine_unit_prices`: إدارة أسعار الشراء/البيع لكل وحدة.
- **يعمل:** الصيدلية تدير كتالوجها بالكامل من التطبيق.

### 🟡 P3 — المخزون والمشتريات
- [ ] `stocks`: قائمة + إدخال مخزون (`POST /Stock`) + تعديل.
- [ ] كمية الدواء حسب المستودع (`Stock/medicine/{id}/warehouses`) — تُعرض في تفاصيل الدواء والبيع.
- [ ] `purchases`: فاتورة شراء بسطور (نفس نمط شاشة البيع، لكن أسعار شراء) + قائمة + تفاصيل.
- [ ] `stock_movements`: عرض حركات المخزون (فلاتر: دواء/مستودع/تاريخ).
- [ ] تنبيهات النفاد/قرب الانتهاء من `Dashboard` (`lowStockList`/`expiringList`) + `Report` لكل دواء.
- **يعمل:** دورة مخزون كاملة (شراء → مخزون → بيع يخصم).

### 🟢 P4 — المحاسبة والتقارير والإعدادات
- [ ] `accounts` (شجرة الحسابات) + `journal_entries` (+ `details`).
- [ ] لوحة تقارير موسّعة + `Report/medicine-report/{id}`.
- [ ] `settings`: شاشة إعدادات (المستودع الافتراضي، تفضيلات العرض).
- **يعمل:** طبقة محاسبية وتقارير للإدارة.

---

## 8) هيكل الملفات المتوقّع (نموذج ميزة `medicines`)

```
lib/features/medicines/
  medicine_providers.dart                 // DI (composition root)
  data/
    datasources/medicine_remote_data_source.dart
    dtos/medicine_dto.dart (+ .g.dart)
    dtos/medicine_unit_price_dto.dart (+ .g.dart)
    mappers/medicine_mapper.dart
    repositories/medicine_repository_impl.dart
  domain/
    entities/medicine.dart (+ .freezed.dart)
    repositories/medicine_repository.dart
    usecases/get_medicines.dart
  presentation/
    pages/medicines_page.dart
    pages/medicine_form_page.dart
    providers/medicines_provider.dart (+ .g.dart)
    widgets/medicine_picker_field.dart
```
نفس القالب لكل ميزة. التبويبات في `AppRoutes`/`MainShell` تُوصَل تدريجياً.

---

## 9) اعتماديات على الباك إند (حتى يعمل المشروع بالكامل)

مرتّبة حسب الأثر:
1. **`GET pharmacy-api/Warehouse`** (قائمة مستودعات + الرئيسي) — يحجب اختيار
   المستودع في البيع/الشراء/المخزون. (حاليّاً نلتفّ عبر Settings — §5.)
2. **CRUD للزبائن (Customer)** — لربط البيع بزبون وكشف حساب لاحقاً.
3. **CRUD للمورّدين (Supplier)** — لفواتير الشراء.
4. **Auth/Login + JWT** — عند الحاجة لتعدّد المستخدمين والصلاحيات (البنية جاهزة
   في `core/session`).
5. توحيد شكل الأخطاء (`ApiResult` مقابل شكل الـ middleware) — تحسين، ليس حاجزاً.

---

## 10) ملخّص «ما الذي يجعل المشروع شغّالاً؟»

> **الحد الأدنى العامل = P0 + P1:** اتصال بالـ API + كتالوج أدوية للقراءة
> (مع كاش أوفلاين) + شاشة بيع تمسح الباركود وتُصدر فاتورة `POST /Sale` (مع طابور
> أوفلاين). كل شيء بعد ذلك (CRUD الكتالوج، المخزون، المشتريات، المحاسبة) طبقات
> تحسين تُبنى بالترتيب أعلاه دون كسر ما قبلها.

---

## 11) الصلاحيات وإعداد المنصّات (مُعدّة ✅)

**Android** (`android/app/src/main/AndroidManifest.xml`):
- `INTERNET` + `ACCESS_NETWORK_STATE` — لنداءات الـ API و`connectivity_plus`
  (أُضيفت للـ main manifest لتسري على الإصدار release أيضاً، لا debug فقط).
- `CAMERA` + `uses-feature camera (required=false)` — لمسح الباركود.
- `android:usesCleartextTraffic="true"` — للسماح باتصال HTTP (خادم التطوير).
  عند الانتقال لـ HTTPS يُفضَّل إزالتها أو استبدالها بـ network-security-config.
- `minSdk = max(flutter.minSdkVersion, 23)` في `build.gradle.kts` — يلبّي
  متطلبات `mobile_scanner` و`flutter_secure_storage`.

**iOS** (`ios/Runner/Info.plist`):
- `NSCameraUsageDescription` — وصف استخدام الكاميرا (عربي).
- `NSAppTransportSecurity → NSAllowsArbitraryLoads = true` — للسماح بـ HTTP
  (تطوير)؛ تُزال في الإنتاج على HTTPS.

**طلب الإذن وقت التشغيل:** `mobile_scanner` يطلب إذن الكاميرا تلقائياً عند أول
تشغيل للماسح؛ عند الرفض تظهر أيقونة كاميرا معطّلة بدل التعطّل. `flutter_secure_storage`
لا يحتاج إذناً. لا أذونات تخزين مطلوبة (drift يستخدم مجلد التطبيق الخاص).

**التشغيل مقابل الخادم:**
```
flutter run --dart-define=API_BASE_URL=http://<lan-ip>:<port>
```
(محاكي Android: استخدم `http://10.0.2.2:<port>` للوصول لجهازك.)
