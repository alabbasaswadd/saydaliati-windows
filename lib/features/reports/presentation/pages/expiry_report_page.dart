import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/entities/expiry_report.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Batch-level expiry report: two tabs (expiring soon / expired) as readable
/// tables, with the warning-window filter in a side sheet (end drawer).
class ExpiryReportPage extends ConsumerStatefulWidget {
  const ExpiryReportPage({super.key});

  @override
  ConsumerState<ExpiryReportPage> createState() => _ExpiryReportPageState();
}

class _ExpiryReportPageState extends ConsumerState<ExpiryReportPage> {
  static const _windows = <int, String>{
    30: '30',
    60: '60',
    90: '90',
    180: '180',
    36500: AppStrings.windowAll,
  };
  int _window = 60;

  String _windowLabel(int w) =>
      w >= 36500 ? AppStrings.windowAll : '$w ${AppStrings.daysUnit}';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(expiryReportProvider(_window));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.expiryReport),
          actions: [
            Builder(
              builder: (ctx) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: ActionChip(
                  avatar: const Icon(Icons.filter_list, size: 16),
                  label: Text(_windowLabel(_window)),
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(expiryReportProvider(_window)),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.expiringSoonTab),
              Tab(text: AppStrings.expiredTab),
            ],
          ),
        ),
        endDrawer: Drawer(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Text(AppStrings.expiryWindow,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                const Divider(),
                for (final e in _windows.entries)
                  ListTile(
                    leading: Icon(_window == e.key
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off),
                    title: Text(_windowLabel(e.key)),
                    selected: _window == e.key,
                    onTap: () {
                      setState(() => _window = e.key);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ),
        body: async.when(
          loading: () => const LoadingState(),
          error: (e, _) => ErrorState.fromError(
            e,
            onRetry: () => ref.invalidate(expiryReportProvider(_window)),
          ),
          data: (r) => TabBarView(
            children: [
              _table(r.expiringSoon, AppStrings.noExpiringSoon, soon: true),
              _table(r.expired, AppStrings.noExpired, soon: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _table(List<ExpiryBatch> items, String emptyMsg, {required bool soon}) {
    final color = soon ? Colors.orange.shade800 : Colors.red.shade700;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        ReportList(
          emptyMessage: emptyMsg,
          items: [
            for (final b in items)
              ReportItem(
                title: b.brandName,
                subtitle: b.warehouseName,
                accentColor: color,
                trailing: _daysText(b.daysLeft),
                trailingColor: color,
                trailingCaption: AppStrings.daysLeftColumn,
                fields: [
                  ReportField(AppStrings.expiryColumn, _ymd(b.expiryDate)),
                  ReportField(
                      AppStrings.qtyLabel, Formatters.qty(b.quantityAvailable)),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static String _daysText(int days) => days >= 0
      ? '$days ${AppStrings.daysUnit}'
      : '-${-days} ${AppStrings.daysUnit}';

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
