import 'package:flutter/material.dart';

/// Identifies which screen/topic a tutorial belongs to, so a screen can show
/// its own contextual help video.
enum TutorialTopic {
  addMedicine,
  unitsAndPrices,
  firstPurchase,
  firstSale,
  afterSale,
  costPrice,
  currencies,
  secondCurrencySale,
  settings,
  profitReport,
}

/// A short, screen-recorded lesson hosted as a YouTube Short.
@immutable
class Tutorial {
  const Tutorial({
    required this.topic,
    required this.title,
    required this.youtubeId,
    this.subtitle,
    this.important = false,
    this.icon = Icons.play_circle_outline,
  });

  final TutorialTopic topic;
  final String title;
  final String? subtitle;
  final String youtubeId;

  /// Flagged lessons the user really shouldn't skip.
  final bool important;
  final IconData icon;

  String get url => 'https://youtube.com/shorts/$youtubeId';
  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
}

/// The full lesson catalogue, in recommended learning order.
const List<Tutorial> kTutorials = <Tutorial>[
  Tutorial(
    topic: TutorialTopic.addMedicine,
    title: 'إضافة دواء',
    subtitle: 'كيف تُدخل دواءً جديداً إلى المخزون',
    youtubeId: 'wpxBHTxbPdw',
    icon: Icons.medication_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.unitsAndPrices,
    title: 'الوحدات والأسعار',
    subtitle: 'ضبط وحدات البيع ومعاملات التحويل والأسعار',
    youtubeId: '1CpfguTUIgg',
    icon: Icons.straighten_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.firstPurchase,
    title: 'عمل أول فاتورة شراء',
    subtitle: 'الخطوة الأساسية لبناء مخزونك — مهم',
    youtubeId: 'Fmb51mN3jig',
    important: true,
    icon: Icons.shopping_cart_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.firstSale,
    title: 'أول فاتورة مبيعات',
    subtitle: 'إصدار فاتورة بيع للعميل',
    youtubeId: '8W66o2h8vng',
    icon: Icons.point_of_sale_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.afterSale,
    title: 'ما بعد فاتورة المبيعات',
    subtitle: 'ماذا يحدث بعد البيع — المخزون والتقارير',
    youtubeId: 'o-EpXaV3b4k',
    icon: Icons.receipt_long_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.costPrice,
    title: 'كيف يُحسب سعر الكلفة؟',
    subtitle: 'مهم جداً لفهم أرباحك الحقيقية',
    youtubeId: 'MKsmbYbuGiI',
    important: true,
    icon: Icons.calculate_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.currencies,
    title: 'العملات وتحديد أسعار الصرف',
    subtitle: 'إدارة العملات وأسعار صرفها',
    youtubeId: 'rdrBPIuASK0',
    icon: Icons.currency_exchange_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.secondCurrencySale,
    title: 'فاتورة مبيعات بعملة ثانية',
    subtitle: 'البيع بعملة مختلفة عن العملة الأساسية',
    youtubeId: 'VJbtddj94kw',
    icon: Icons.sync_alt_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.settings,
    title: 'واجهة الإعدادات',
    subtitle: 'جولة في إعدادات التطبيق',
    youtubeId: '0uzSAhl3n7g',
    icon: Icons.settings_outlined,
  ),
  Tutorial(
    topic: TutorialTopic.profitReport,
    title: 'تقرير الأرباح',
    subtitle: 'قراءة أرباحك وتكاليفك',
    youtubeId: 'H5McEZSgqkY',
    icon: Icons.insights_outlined,
  ),
];

/// The tutorial for a given [topic].
Tutorial tutorialFor(TutorialTopic topic) =>
    kTutorials.firstWhere((t) => t.topic == topic);
