import 'package:flutter/material.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';

/// كتل شاشة الاختصارات — ترتيب العرض هو ترتيب التعريف هنا.
enum ShortcutSection {
  general('عامّ — في كل الشاشات', Icons.apps_outlined),
  navigation('التنقّل بين الشاشات', Icons.explore_outlined),
  invoice('الفاتورة', Icons.receipt_long_outlined);

  const ShortcutSection(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// كتالوغ إجراءات الاختصارات — المصدر الوحيد لِما يمكن ربطه بمفاتيح.
///
/// الواجهة تملك الكتالوغ (لأنها وحدها تعرف كيف تُنفِّذ كل إجراء)، والخادم يخزّن
/// التخصيصات فقط: إجراء بلا صفّ مخزَّن يعمل بـ[defaultCombo].
///
/// [id] هو ما يُرسَل ويُخزَّن — لا تُغيِّره بعد الإصدار وإلا فقد المستخدمون
/// تخصيصهم لذلك الإجراء.
enum ShortcutAction {
  // ── عامّ ────────────────────────────────────────────────────────────────
  invoiceSave(
    id: 'invoice.save',
    label: 'حفظ',
    section: ShortcutSection.general,
    icon: Icons.save_outlined,
    // نُقل من Ctrl+S إلى Ctrl+Enter لأن Ctrl+S صار لتعديل السعر بطلب
    // المستخدم، ولا يصحّ إجراءان مفعَّلان على تركيبة واحدة. و«إنتر» مع
    // مُعدِّل اصطلاحٌ معروف للإتمام والحفظ.
    defaultCombo: 'Ctrl+Enter',
    hint: 'يحفظ ما هو مفتوح أمامك: فاتورة، مصروف، سند، أو أي نموذج',
  ),

  // ── التنقّل ──────────────────────────────────────────────────────────────
  navSales(
    id: 'nav.sales',
    label: 'فاتورة مبيعات',
    section: ShortcutSection.navigation,
    icon: Icons.point_of_sale_outlined,
    defaultCombo: 'Ctrl+1',
  ),
  navPurchases(
    id: 'nav.purchases',
    label: 'فاتورة مشتريات',
    section: ShortcutSection.navigation,
    icon: Icons.local_shipping_outlined,
    defaultCombo: 'Ctrl+2',
  ),
  navSalesReturns(
    id: 'nav.salesReturns',
    label: 'مرتجع مبيعات',
    section: ShortcutSection.navigation,
    icon: Icons.assignment_return_outlined,
    defaultCombo: 'Ctrl+3',
  ),
  navPurchaseReturns(
    id: 'nav.purchaseReturns',
    label: 'مرتجع مشتريات',
    section: ShortcutSection.navigation,
    icon: Icons.assignment_return_outlined,
    defaultCombo: 'Ctrl+4',
  ),
  navMedicines(
    id: 'nav.medicines',
    label: 'الأدوية',
    section: ShortcutSection.navigation,
    icon: Icons.medication_outlined,
    defaultCombo: 'Ctrl+5',
  ),
  navStock(
    id: 'nav.stock',
    label: 'المخزون',
    section: ShortcutSection.navigation,
    icon: Icons.inventory_2_outlined,
    defaultCombo: 'Ctrl+6',
  ),
  navAccounts(
    id: 'nav.accounts',
    label: 'الحسابات',
    section: ShortcutSection.navigation,
    icon: Icons.account_balance_outlined,
    defaultCombo: 'Ctrl+7',
  ),
  navSalesReport(
    id: 'nav.salesReport',
    label: 'تقرير المبيعات',
    section: ShortcutSection.navigation,
    icon: Icons.insights_outlined,
    defaultCombo: 'Ctrl+8',
  ),

  // ── الفاتورة ────────────────────────────────────────────────────────────
  // الشغل الروتيني على مربّع Z/X/C/V أسفل يسار لوحة المفاتيح: تُطال باليد
  // اليسرى وحدها بينما تبقى اليمنى على الفأرة أو لوحة الأرقام.
  invoiceNewTab(
    id: 'invoice.newTab',
    label: 'فاتورة جديدة',
    section: ShortcutSection.invoice,
    icon: Icons.add_box_outlined,
    defaultCombo: 'Ctrl+C',
    hint: 'يفتح تاب فاتورة جديد بجانب الحالية',
  ),
  invoiceCancel(
    id: 'invoice.cancel',
    label: 'إلغاء الفاتورة',
    section: ShortcutSection.invoice,
    icon: Icons.backspace_outlined,
    defaultCombo: 'Ctrl+X',
    hint: 'يفرّغ أسطر الفاتورة الحالية بعد تأكيد',
  ),
  invoiceAddItem(
    id: 'invoice.addItem',
    label: 'إضافة مادة',
    section: ShortcutSection.invoice,
    icon: Icons.add_shopping_cart_outlined,
    defaultCombo: 'Ctrl+Z',
    hint: 'يفتح منتقي الدواء لإضافة سطر',
  ),
  invoicePickCurrency(
    id: 'invoice.pickCurrency',
    label: 'تغيير العملة',
    section: ShortcutSection.invoice,
    icon: Icons.payments_outlined,
    defaultCombo: 'Ctrl+V',
    hint: 'يفتح منتقي العملة ويعيد تسعير الأسطر عليها',
  ),
  invoiceDeleteLine(
    id: 'invoice.deleteLine',
    label: 'حذف السطر المحدَّد',
    section: ShortcutSection.invoice,
    icon: Icons.delete_outline,
    defaultCombo: 'Ctrl+D',
  ),
  invoiceEditPrice(
    id: 'invoice.editPrice',
    label: 'تعديل سعر السطر',
    section: ShortcutSection.invoice,
    icon: Icons.sell_outlined,
    defaultCombo: 'Ctrl+S',
    hint: 'ينقل التحرير إلى خلية السعر في السطر المحدَّد',
  ),
  invoiceEditQty(
    id: 'invoice.editQty',
    label: 'تعديل كمية السطر',
    section: ShortcutSection.invoice,
    icon: Icons.numbers_outlined,
    defaultCombo: 'Ctrl+F',
    hint: 'ينقل التحرير إلى خلية الكمية في السطر المحدَّد',
  ),
  invoicePickCustomer(
    id: 'invoice.pickCustomer',
    label: 'اختيار العميل',
    section: ShortcutSection.invoice,
    icon: Icons.person_outline,
    defaultCombo: 'Ctrl+M',
  ),
  invoicePrescription(
    id: 'invoice.prescription',
    label: 'تبديل «وصفة طبية»',
    section: ShortcutSection.invoice,
    icon: Icons.description_outlined,
    defaultCombo: 'Ctrl+R',
  );

  const ShortcutAction({
    required this.id,
    required this.label,
    required this.section,
    required this.icon,
    required this.defaultCombo,
    this.hint,
  });

  /// المعرّف المخزَّن على الخادم. ثابت لا يتغيّر.
  final String id;
  final String label;
  final ShortcutSection section;
  final IconData icon;

  /// التركيبة الافتراضية بصيغتها المخزَّنة.
  final String defaultCombo;

  /// شرح سطر واحد يظهر تحت الاسم في شاشة الإعدادات.
  final String? hint;

  KeyCombo get defaultKeyCombo => KeyCombo.parse(defaultCombo)!;

  static ShortcutAction? fromId(String id) {
    for (final a in values) {
      if (a.id == id) return a;
    }
    return null;
  }
}
