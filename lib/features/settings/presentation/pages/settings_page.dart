import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/session/session_controller.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/onboarding/onboarding_controller.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';

/// Settings screen.
///
/// Groups app-wide preferences under a "General settings" (إعدادات عامة)
/// section. The pharmacy currently operates a single (main) warehouse resolved
/// automatically from the backend; its name is shown clearly here, and changing
/// it is a planned future capability (the control is intentionally disabled).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouseAsync = ref.watch(defaultWarehouseProvider);
    final pharmacyNameAsync = ref.watch(pharmacyNameProvider);
    final allowNegativeAsync = ref.watch(allowNegativeSaleProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text(AppStrings.settings),
          actions: const [TutorialHelpButton(TutorialTopic.settings)]),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const _SectionHeader(AppStrings.generalSettings),

          // اسم الصيدلية — general setting, editable (stored server-side).
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_pharmacy_outlined),
              title: const Text(AppStrings.pharmacyName),
              subtitle: pharmacyNameAsync.when(
                loading: () => const Text('…'),
                error: (_, _) => const Text(AppStrings.notSet),
                data: (name) => Text(
                  (name != null && name.isNotEmpty) ? name : AppStrings.notSet,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: AppStrings.edit,
                onPressed: () => _editPharmacyName(
                  context,
                  ref,
                  pharmacyNameAsync.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // المستودع الرئيسي — name shown clearly; changing is a future feature.
          Card(
            child: ListTile(
              leading: const Icon(Icons.warehouse_outlined),
              title: const Text(AppStrings.defaultWarehouse),
              subtitle: warehouseAsync.when(
                loading: () => const Text('…'),
                error: (_, _) => const Text(AppStrings.warehouseNotSet),
                data: (warehouse) {
                  if (warehouse == null) {
                    return const Text(AppStrings.warehouseNotSet);
                  }
                  final label = warehouse.name.isNotEmpty
                      ? warehouse.name
                      : warehouse.id;
                  return Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              // Disabled on purpose: changing the main warehouse is planned.
              trailing: TextButton.icon(
                onPressed: null,
                icon: const Icon(Icons.lock_outline, size: AppSizes.iconSm),
                label: const Text(AppStrings.changeWarehouse),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              AppStrings.changeWarehouseSoon,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(AppStrings.salesSettings),

          // السماح بالبيع في السالب — server-side boolean setting.
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.trending_down_outlined),
              title: const Text(AppStrings.allowNegativeSale),
              subtitle: const Text(AppStrings.allowNegativeSaleHint),
              value: allowNegativeAsync.value ?? false,
              onChanged: allowNegativeAsync.isLoading
                  ? null
                  : (v) => _setAllowNegative(context, ref, v),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(AppStrings.connectivitySection),

          // وضع عدم الاتصال اليدوي — يُجبر التطبيق على العمل من الكاش وتطبير الكتابات.
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.cloud_off_outlined),
              title: const Text(AppStrings.offlineMode),
              subtitle: const Text(AppStrings.offlineModeHint),
              value: ref.watch(workModeControllerProvider) == WorkMode.offline,
              onChanged: (v) => ref
                  .read(workModeControllerProvider.notifier)
                  .toggleOffline(v),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // تحديث بيانات العمل دون اتصال — مزامنة شاملة (ترحيل الفواتير ثم سحب الكاش).
          _SyncDataTile(),
          const SizedBox(height: AppSpacing.sm),

          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(AppStrings.help),

          // إعادة الجولة التعليمية — ترجع إلى الشاشة الرئيسية وتعيد تشغيلها.
          Card(
            child: ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text(AppStrings.replayTour),
              trailing: const Icon(Icons.chevron_left),
              onTap: () {
                Navigator.of(context).popUntil((r) => r.isFirst);
                ref.read(onboardingControllerProvider.notifier).restart();
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // تسجيل الخروج
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade700),
              title: Text(AppStrings.logout,
                  style: TextStyle(color: Colors.red.shade700)),
              onTap: () async {
                final ok = await showConfirmationDialog(
                  context,
                  title: AppStrings.logout,
                  message: AppStrings.logoutConfirm,
                  confirmLabel: AppStrings.logout,
                  icon: Icons.logout,
                  destructive: true,
                );
                if (!ok) return;
                await ref.read(sessionControllerProvider.notifier).clear();
                // Router redirect sends the user to the login screen.
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setAllowNegative(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final result = await ref
        .read(settingsRepositoryProvider)
        .setValue(AppConstants.allowNegativeSaleKey, value ? 'true' : 'false');

    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(allowNegativeSaleProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.settingsSaved)),
        );
      },
      (_) {
        ref.invalidate(allowNegativeSaleProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.saveFailed)),
        );
      },
    );
  }

  Future<void> _editPharmacyName(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) async {
    final controller = TextEditingController(text: current ?? '');
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.local_pharmacy_outlined,
                          color: theme.colorScheme.primary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(AppStrings.pharmacyName,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          iconSize: 16,
                          tooltip: AppStrings.close,
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration:
                        const InputDecoration(hintText: AppStrings.pharmacyName),
                    onSubmitted: (_) =>
                        Navigator.pop(dialogContext, controller.text.trim()),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 96,
                        height: 32,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            textStyle: theme.textTheme.bodyMedium,
                          ),
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text(AppStrings.cancel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 96,
                        height: 32,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            textStyle: theme.textTheme.bodyMedium,
                          ),
                          onPressed: () =>
                              Navigator.pop(dialogContext, controller.text.trim()),
                          child: const Text(AppStrings.save),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (value == null) return;

    final result = await ref
        .read(settingsRepositoryProvider)
        .setValue(AppConstants.pharmacyNameKey, value);

    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(pharmacyNameProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.settingsSaved)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.saveFailed)),
        );
      },
    );
  }
}

/// "تحديث البيانات" — runs a full sync (push queued writes, then re-pull the
/// catalogs into the local cache) and reflects progress / last-synced time.
class _SyncDataTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(dataSyncControllerProvider);
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;

    String baseSubtitle;
    if (sync.running) {
      baseSubtitle = '${AppStrings.syncing} ${sync.step ?? ''}'.trim();
    } else if (sync.lastSyncedAt != null) {
      baseSubtitle = '${AppStrings.lastSynced}: ${_fmtTime(sync.lastSyncedAt!)}';
    } else {
      baseSubtitle = AppStrings.syncDataHint;
    }
    final subtitle = pending > 0
        ? '$baseSubtitle • ${AppStrings.pendingOperations}: $pending'
        : baseSubtitle;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.cloud_sync_outlined),
        title: const Text(AppStrings.syncData),
        subtitle: Text(subtitle),
        trailing: sync.running
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.chevron_left),
        onTap: sync.running
            ? null
            : () async {
                await ref.read(dataSyncControllerProvider.notifier).syncAll();
                if (!context.mounted) return;
                final st = ref.read(dataSyncControllerProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(st.offline
                        ? AppStrings.noInternetToRefresh
                        : AppStrings.syncDone),
                  ),
                );
              },
      ),
    );
  }

  static String _fmtTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.sm,
          right: AppSpacing.xs,
        ),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
}
