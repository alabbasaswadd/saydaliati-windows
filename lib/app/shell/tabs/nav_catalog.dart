import 'package:flutter/material.dart';
import 'package:saydaliati/app/router/app_routes.dart';

/// عنوان وأيقونة كل مسار — المصدر الوحيد لعناوين التابّات.
///
/// **لمَ قائمة مستقلّة عن الشريط الجانبي:** الشريط يصف **البنية** (أقسام
/// وشجرة وأرقام فروع)، وهذه تصف **الهوية** (مسار ← عنوان وأيقونة). التابّ
/// يُفتَح أيضاً من غير الشريط — من زرٍّ داخل صفحة أو من مسار مُستعاد — فلا
/// يصحّ أن يكون عنوانه حبيس بنية الشريط.
///
/// **للإضافة:** سطر واحد هنا. وما لا سطر له يأخذ عنواناً من اسم المسار بدل
/// أن يختفي.
@immutable
class NavEntry {
  const NavEntry(this.location, this.title, this.icon);

  final String location;
  final String title;
  final IconData icon;
}

const List<NavEntry> navCatalog = [
  NavEntry(AppRoutes.home, 'الرئيسية', Icons.dashboard_outlined),
  NavEntry(AppRoutes.sales, 'المبيعات', Icons.point_of_sale_outlined),
  NavEntry(AppRoutes.salesInvoices, 'فواتير المبيعات', Icons.receipt_long_outlined),
  NavEntry(AppRoutes.purchases, 'المشتريات', Icons.shopping_cart_outlined),
  NavEntry(AppRoutes.purchaseInvoices, 'فواتير المشتريات', Icons.receipt_outlined),
  NavEntry(AppRoutes.openingBalanceInvoices, 'أول المدة', Icons.account_balance_wallet_outlined),
  NavEntry(AppRoutes.salesReturns, 'مرتجع مبيعات', Icons.assignment_return_outlined),
  NavEntry(AppRoutes.purchaseReturns, 'مرتجع مشتريات', Icons.assignment_return_outlined),
  NavEntry(AppRoutes.products, 'الأدوية', Icons.medication_outlined),
  NavEntry(AppRoutes.catalog, 'المكتبة الدوائية', Icons.local_library_outlined),
  NavEntry(AppRoutes.inventory, 'المخزون', Icons.inventory_2_outlined),
  NavEntry(AppRoutes.stockMovements, 'حركات المخزون', Icons.swap_vert_outlined),
  NavEntry(AppRoutes.suppliers, 'الموردون', Icons.local_shipping_outlined),
  NavEntry(AppRoutes.customers, 'العملاء', Icons.people_outline),
  NavEntry(AppRoutes.categories, 'التصنيفات', Icons.category_outlined),
  NavEntry(AppRoutes.manufacturers, 'الشركات', Icons.factory_outlined),
  NavEntry(AppRoutes.units, 'الوحدات', Icons.straighten_outlined),
  NavEntry(AppRoutes.currencies, 'العملات', Icons.currency_exchange_outlined),
  NavEntry(AppRoutes.accounts, 'الحسابات', Icons.account_balance_outlined),
  NavEntry(AppRoutes.vouchers, 'السندات', Icons.description_outlined),
  NavEntry(AppRoutes.expenses, 'المصاريف', Icons.payments_outlined),
  NavEntry(AppRoutes.expenseCategories, 'تصنيفات المصاريف', Icons.category_outlined),
  NavEntry(AppRoutes.debtsCustomers, 'ديون العملاء', Icons.person_outline),
  NavEntry(AppRoutes.debtsSuppliers, 'ديون الموردين', Icons.local_shipping_outlined),
  NavEntry(AppRoutes.reports, 'التقارير', Icons.bar_chart_outlined),
  NavEntry(AppRoutes.salesReport, 'تقرير المبيعات', Icons.show_chart_outlined),
  NavEntry(AppRoutes.profitReport, 'تقرير الأرباح', Icons.trending_up_outlined),
  NavEntry(AppRoutes.purchasesReport, 'تقرير المشتريات', Icons.shopping_bag_outlined),
  NavEntry(AppRoutes.inventoryReport, 'تقرير المخزون', Icons.inventory_outlined),
  NavEntry(AppRoutes.expiryReport, 'تقرير الصلاحية', Icons.event_busy_outlined),
  NavEntry(AppRoutes.stocktakeReport, 'الجرد', Icons.fact_check_outlined),
  NavEntry(AppRoutes.prescriptionsReport, 'الوصفات الطبية', Icons.medical_services_outlined),
  NavEntry(AppRoutes.settings, 'الإعدادات', Icons.settings_outlined),
  NavEntry(AppRoutes.shortcuts, 'الاختصارات', Icons.keyboard_outlined),
  NavEntry(AppRoutes.profile, 'الحساب الشخصي', Icons.person_outline),
  NavEntry(AppRoutes.tutorials, 'الشروحات', Icons.school_outlined),
  NavEntry(AppRoutes.notifications, 'الإشعارات', Icons.notifications_outlined),
  NavEntry(AppRoutes.users, 'المستخدمون', Icons.manage_accounts_outlined),
  NavEntry(AppRoutes.roles, 'الأدوار والصلاحيات', Icons.admin_panel_settings_outlined),
];

/// أفضل مطابقة لمسار: المطابقة التامّة أولاً، ثم أطول بادئة — فمسار فرعي
/// غير مُفهرَس (تفاصيل عنصر مثلاً) يرث عنوان قسمه بدل أن يصير بلا عنوان.
NavEntry? navEntryFor(String location) {
  NavEntry? best;
  for (final e in navCatalog) {
    if (e.location == location) return e;
    if (location.startsWith('${e.location}/') &&
        (best == null || e.location.length > best.location.length)) {
      best = e;
    }
  }
  return best;
}
