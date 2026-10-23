import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/onboarding/onboarding_coach.dart';
import 'package:saydaliati/features/onboarding/onboarding_controller.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_create_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_detail_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';

/// Purchase invoices list. FAB creates a new one.
class PurchasesPage extends ConsumerStatefulWidget {
  const PurchasesPage({super.key});

  @override
  ConsumerState<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends ConsumerState<PurchasesPage> {
  final _addKey = GlobalKey();
  bool _coachShown = false;

  void _maybeShowCoach() {
    if (_coachShown) return;
    final onb = ref.read(onboardingControllerProvider);
    if (!onb.active || onb.stage != OnboardingStage.purchase) return;
    _coachShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(onboardingControllerProvider.notifier);
      showCoach(
        context,
        steps: [
          CoachStep(
              key: _addKey,
              title: AppStrings.onbAddPurchaseTitle,
              text: AppStrings.onbAddPurchaseText),
        ],
        // Last step of the tour.
        onFinish: () => notifier.finish(),
        onSkip: () => notifier.finish(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // فواتير أول المدة لها شاشتها الخاصة (ليست شراءً حقيقياً من مورّد) —
    // نفس الاستبعاد في PurchasesListPage.
    final async = ref.watch(purchasesListProvider).whenData(
        (list) => list.where((p) => !p.isOpeningBalance).toList());
    ref.watch(onboardingControllerProvider);
    _maybeShowCoach();
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.purchasesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: _addKey,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PurchaseCreatePage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newPurchase),
      ),
      body: AsyncListView<Purchase>(
        value: async,
        emptyMessage: AppStrings.noPurchases,
        onRefresh: () => ref.refresh(purchasesListProvider.future),
        itemBuilder: (context, p) => _PurchaseCard(purchase: p),
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({required this.purchase});

  final Purchase purchase;

  String get _preview {
    final names = purchase.items.map((e) => e.medicineName).toList();
    if (names.isEmpty) return '';
    final shown = names.take(2).join('، ');
    final extra = names.length - 2;
    return extra > 0 ? '$shown +$extra' : shown;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.local_shipping_outlined,
              color: theme.colorScheme.primary),
        ),
        title: Text(AppDate.ymd(purchase.purchaseDate),
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(
          _preview.isEmpty ? '${purchase.items.length} صنف' : _preview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Formatters.money(purchase.totalAmount),
                style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700)),
            Text('${purchase.items.length} صنف',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (_) => PurchaseDetailPage(purchase: purchase)),
        ),
      ),
    );
  }
}
