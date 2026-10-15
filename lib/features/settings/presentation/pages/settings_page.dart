import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/onboarding/onboarding_controller.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';

/// شاشة الإعدادات — تفضيلات التطبيق مجمَّعة بأقسام.
///
/// **تسجيل الخروج ليس هنا**: مكانه الملف الشخصي وحده. كان في الشاشتين، وفعلٌ
/// لا رجعة فيه يجب أن يكون مكانه واحداً متوقَّعاً، لا مُجاوراً لمفاتيح
/// التفضيلات التي تُجرَّب بالنقر.
///
/// كل قسم **بطاقة واحدة** بفواصل داخلية، لا بطاقة لكل سطر: البطاقات
/// المتلاصقة تُنتج حدوداً مزدوجة وإيقاعاً مضطرباً، والتجميع يُظهر أن السطور
/// تنتمي لموضوع واحد.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        actions: const [TutorialHelpButton(TutorialTopic.settings)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const _Section(
            title: AppStrings.generalSettings,
            footnote: AppStrings.changeWarehouseSoon,
            children: [
              _PharmacyNameTile(),
              Divider(height: 1),
              _DefaultWarehouseTile(),
            ],
          ),
          const _Section(
            title: AppStrings.salesSettings,
            children: [_AllowNegativeSaleTile()],
          ),
          const _Section(
            title: AppStrings.connectivitySection,
            children: [
              _OfflineModeTile(),
              Divider(height: 1),
              _SyncDataTile(),
            ],
          ),
          const _Section(
            title: AppStrings.help,
            children: [_ReplayTourTile()],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════ القسم والسطر ═══════════════════════

/// عنوان قسم + بطاقة واحدة تحمل سطوره، وحاشية اختيارية تحتها.
class _Section extends StatelessWidget {
  const _Section({required this.title, this.footnote, required this.children});

  final String title;
  final List<Widget> children;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
            right: AppSpacing.xs,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Card(child: Column(children: children)),
        if (footnote != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              right: AppSpacing.sm,
              left: AppSpacing.sm,
            ),
            child: Text(
              footnote!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

/// نصّ القيمة تحت العنوان مع حالات التحميل والخطأ — متكرّر في كل سطر إعداد
/// يقرأ من الخادم.
Widget _valueText(AsyncValue<String?> async, String fallback, {bool bold = false}) {
  return async.when(
    loading: () => const Text('…'),
    error: (_, _) => Text(fallback),
    data: (v) => Text(
      (v != null && v.isNotEmpty) ? v : fallback,
      style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
    ),
  );
}

/// يُعلِم المستخدم بنتيجة الحفظ — نفس الرسالة في كل إعداد.
void _notify(BuildContext context, {required bool saved}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(saved ? AppStrings.settingsSaved : AppStrings.saveFailed),
    ),
  );
}

// ═══════════════════════ إعدادات عامة ═══════════════════════

class _PharmacyNameTile extends ConsumerWidget {
  const _PharmacyNameTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(pharmacyNameProvider);
    return ListTile(
      leading: const Icon(Icons.local_pharmacy_outlined),
      title: const Text(AppStrings.pharmacyName),
      subtitle: _valueText(async, AppStrings.notSet),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        tooltip: AppStrings.edit,
        onPressed: () => _edit(context, ref, async.value),
      ),
      onTap: () => _edit(context, ref, async.value),
    );
  }

  /// الحوار من [showEntityFormDialog] لا مبنيّاً هنا: كان نسخةً يدوية بنفس
  /// التصميم، فتتبدّل مع كل تحسين في المكوّن المشترك وتتخلّف عنه.
  Future<void> _edit(BuildContext context, WidgetRef ref, String? current) async {
    final result = await showEntityFormDialog(
      context,
      title: AppStrings.pharmacyName,
      icon: Icons.local_pharmacy_outlined,
      fields: [
        EntityField(
          key: 'name',
          label: AppStrings.pharmacyName,
          initial: current ?? '',
          isRequired: true,
        ),
      ],
    );
    if (result == null) return;

    final saved = await ref
        .read(settingsRepositoryProvider)
        .setValue(AppConstants.pharmacyNameKey, result['name'] ?? '');

    ref.invalidate(pharmacyNameProvider);
    if (!context.mounted) return;
    saved.fold(
      (_) => _notify(context, saved: true),
      (_) => _notify(context, saved: false),
    );
  }
}

/// المستودع الرئيسي — يُحلّ تلقائياً من الخادم، وتغييره ميزة مؤجَّلة
/// (الزرّ معطَّل عن قصد، والحاشية تقول السبب).
class _DefaultWarehouseTile extends ConsumerWidget {
  const _DefaultWarehouseTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(defaultWarehouseProvider);
    return ListTile(
      leading: const Icon(Icons.warehouse_outlined),
      title: const Text(AppStrings.defaultWarehouse),
      subtitle: _valueText(
        async.whenData((w) => w == null
            ? null
            : (w.name.isNotEmpty ? w.name : w.id)),
        AppStrings.warehouseNotSet,
        bold: true,
      ),
      trailing: TextButton.icon(
        onPressed: null,
        icon: const Icon(Icons.lock_outline, size: AppSizes.iconSm),
        label: const Text(AppStrings.changeWarehouse),
      ),
    );
  }
}

// ═══════════════════════ المبيعات ═══════════════════════

class _AllowNegativeSaleTile extends ConsumerWidget {
  const _AllowNegativeSaleTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allowNegativeSaleProvider);
    return SwitchListTile(
      secondary: const Icon(Icons.trending_down_outlined),
      title: const Text(AppStrings.allowNegativeSale),
      subtitle: const Text(AppStrings.allowNegativeSaleHint),
      value: async.value ?? false,
      onChanged: async.isLoading ? null : (v) => _set(context, ref, v),
    );
  }

  Future<void> _set(BuildContext context, WidgetRef ref, bool value) async {
    final result = await ref
        .read(settingsRepositoryProvider)
        .setValue(AppConstants.allowNegativeSaleKey, value ? 'true' : 'false');

    // يُبطَل المزوّد في الحالتين: الفشل يعيد المفتاح إلى قيمة الخادم الحقيقية
    // بدل تركه يعرض ما لم يُحفَظ.
    ref.invalidate(allowNegativeSaleProvider);
    if (!context.mounted) return;
    result.fold(
      (_) => _notify(context, saved: true),
      (_) => _notify(context, saved: false),
    );
  }
}

// ═══════════════════════ الاتصال ═══════════════════════

class _OfflineModeTile extends ConsumerWidget {
  const _OfflineModeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      secondary: const Icon(Icons.cloud_off_outlined),
      title: const Text(AppStrings.offlineMode),
      subtitle: const Text(AppStrings.offlineModeHint),
      value: ref.watch(workModeControllerProvider) == WorkMode.offline,
      onChanged: (v) =>
          ref.read(workModeControllerProvider.notifier).toggleOffline(v),
    );
  }
}

/// «تحديث البيانات» — مزامنة شاملة: ترحيل الكتابات المعلَّقة ثم سحب الكاش،
/// مع عرض التقدّم وآخر وقت مزامنة وعدد العمليات المعلَّقة.
class _SyncDataTile extends ConsumerWidget {
  const _SyncDataTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(dataSyncControllerProvider);
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;

    return ListTile(
      leading: const Icon(Icons.cloud_sync_outlined),
      title: const Text(AppStrings.syncData),
      subtitle: Text(_subtitle(sync, pending)),
      trailing: sync.running
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_left),
      onTap: sync.running ? null : () => _run(context, ref),
    );
  }

  static String _subtitle(SyncProgress sync, int pending) {
    final String base;
    if (sync.running) {
      base = '${AppStrings.syncing} ${sync.step ?? ''}'.trim();
    } else if (sync.lastSyncedAt != null) {
      base = '${AppStrings.lastSynced}: ${_fmtTime(sync.lastSyncedAt!)}';
    } else {
      base = AppStrings.syncDataHint;
    }
    return pending > 0
        ? '$base • ${AppStrings.pendingOperations}: $pending'
        : base;
  }

  Future<void> _run(BuildContext context, WidgetRef ref) async {
    await ref.read(dataSyncControllerProvider.notifier).syncAll();
    if (!context.mounted) return;
    final st = ref.read(dataSyncControllerProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          st.offline ? AppStrings.noInternetToRefresh : AppStrings.syncDone,
        ),
      ),
    );
  }

  static String _fmtTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ═══════════════════════ المساعدة ═══════════════════════

class _ReplayTourTile extends ConsumerWidget {
  const _ReplayTourTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.school_outlined),
      title: const Text(AppStrings.replayTour),
      trailing: const Icon(Icons.chevron_left),
      onTap: () {
        // الجولة تشرح الشاشة الرئيسية، فالعودة إليها قبل تشغيلها.
        Navigator.of(context).popUntil((r) => r.isFirst);
        ref.read(onboardingControllerProvider.notifier).restart();
      },
    );
  }
}
