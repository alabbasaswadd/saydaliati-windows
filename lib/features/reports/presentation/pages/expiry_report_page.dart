import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/entities/expiry_report.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

enum _ExpiryView { all, soon, expired }

/// Batch-level expiry report — the project-standard grid: clickable stat chips
/// (الكل / قريبة الانتهاء / منتهية) filter the rows, a menu chip picks the
/// warning window, and the batches render as one sortable/filterable grid with
/// colored status + days-left.
class ExpiryReportPage extends ConsumerStatefulWidget {
  const ExpiryReportPage({super.key});

  @override
  ConsumerState<ExpiryReportPage> createState() => _ExpiryReportPageState();
}

class _ExpiryReportPageState extends ConsumerState<ExpiryReportPage> {
  static const _windows = <int>[30, 60, 90, 180, 36500];
  int _window = 60;
  _ExpiryView _view = _ExpiryView.all;

  TrinaGridStateManager? _gridManager;

  static const _fName = 'name';
  static const _fWarehouse = 'warehouse';
  static const _fExpiry = 'expiry';
  static const _fDays = 'days';
  static const _fQty = 'qty';
  static const _fStatus = 'status';

  String _windowLabel(int w) =>
      w >= 36500 ? AppStrings.windowAll : '$w ${AppStrings.daysUnit}';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(expiryReportProvider(_window));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expiryReport),
        actions: [
          AppGridColumnsButton(managerGetter: () => _gridManager),
          AppRefreshButton(
            onRefresh: () => ref.refresh(expiryReportProvider(_window).future),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(expiryReportProvider(_window)),
        ),
        data: (r) => _content(context, r),
      ),
    );
  }

  Widget _content(BuildContext context, ExpiryReport r) {
    final soonColor = Colors.orange.shade800;
    final expiredColor = Colors.red.shade700;

    final rows = switch (_view) {
      _ExpiryView.all => [...r.expiringSoon, ...r.expired],
      _ExpiryView.soon => r.expiringSoon,
      _ExpiryView.expired => r.expired,
    };
    final expiredIds = r.expired.map(identityHashCode).toSet();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شرائح الحالة القابلة للنقر (تفلتر العرض) + نافذة التنبيه.
          FilterBar(
            children: [
              AppMenuChip<int>(
                icon: Icons.filter_list,
                tooltip: AppStrings.expiryWindow,
                label: '${AppStrings.expiryWindow}: ${_windowLabel(_window)}',
                items: [
                  for (final w in _windows)
                    PopupMenuItem(value: w, child: Text(_windowLabel(w))),
                ],
                onSelected: (w) => setState(() => _window = w),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          StatChipsBar(chips: [
            StatChip(
              label: AppStrings.windowAll,
              value: Formatters.integer(
                  r.expiringSoon.length + r.expired.length),
              icon: Icons.list_alt_rounded,
              selected: _view == _ExpiryView.all,
              onTap: () => setState(() => _view = _ExpiryView.all),
            ),
            StatChip(
              label: AppStrings.expiringSoonTab,
              value: Formatters.integer(r.expiringSoon.length),
              icon: Icons.schedule_outlined,
              color: soonColor,
              selected: _view == _ExpiryView.soon,
              onTap: () => setState(() => _view = _ExpiryView.soon),
            ),
            StatChip(
              label: AppStrings.expiredTab,
              value: Formatters.integer(r.expired.length),
              icon: Icons.event_busy_outlined,
              color: expiredColor,
              selected: _view == _ExpiryView.expired,
              onTap: () => setState(() => _view = _ExpiryView.expired),
            ),
          ]),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: rows.isEmpty
                ? EmptyState(
                    icon: Icons.event_busy_outlined,
                    message: _view == _ExpiryView.expired
                        ? AppStrings.noExpired
                        : AppStrings.noExpiringSoon,
                  )
                : AppGrid(
                    // نفس إصلاح stocktake_report_page.dart: عدد الدفعات وحده
                    // لا يلتقط تغيّر كمية دفعةٍ قائمة فتبقى TrinaGrid على
                    // صفوفها المخبَّأة القديمة.
                    key: ValueKey(Object.hash(
                      _window,
                      _view,
                      rows.length,
                      Object.hashAllUnordered(
                          rows.map((b) => Object.hash(b.stockId, b.quantityAvailable))),
                    )),
                    columns: _columns(soonColor, expiredColor),
                    rows: [
                      for (final b in rows)
                        _row(b, expired: expiredIds.contains(identityHashCode(b))),
                    ],
                    onLoaded: (m) => _gridManager = m,
                    // تلوين السطر بلون الحالة (برتقالي قريب / أحمر منتهٍ).
                    rowColorCallback: (ctx) {
                      final expired =
                          ctx.row.cells[_fStatus]?.value == AppStrings.expiredTab;
                      return (expired ? expiredColor : soonColor)
                          .withValues(alpha: 0.05);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<TrinaColumn> _columns(Color soonColor, Color expiredColor) {
    return [
      appGridTextColumn(AppStrings.medicineName, _fName, width: 240),
      appGridTextColumn(AppStrings.warehouseColumn, _fWarehouse,
          width: 140, hide: true),
      appGridTextColumn(AppStrings.expiryColumn, _fExpiry,
          width: 110, textAlign: TrinaColumnTextAlign.center),
      // المتبقي بالأيام — سالب للمنتهي، ملوّن بالحالة، LTR لإشارة السالب.
      appGridNumberColumn(AppStrings.daysLeftColumn, _fDays, width: 100,
          format: '#', renderer: (ctx) {
        final v = ctx.cell.value;
        final n = v is num ? v.toInt() : int.tryParse(v?.toString() ?? '');
        if (n == null) return const SizedBox.shrink();
        final color = n < 0 ? expiredColor : soonColor;
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            '$n',
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        );
      }),
      appGridNumberColumn(AppStrings.qtyLabel, _fQty, width: 100),
      // الحالة: شريحة ملوّنة.
      TrinaColumn(
        title: AppStrings.stockStatus,
        field: _fStatus,
        type: TrinaColumnType.text(),
        width: 120,
        enableEditingMode: false,
        textAlign: TrinaColumnTextAlign.center,
        renderer: (ctx) {
          final label = ctx.cell.value?.toString() ?? '';
          final expired = label == AppStrings.expiredTab;
          final color = expired ? expiredColor : soonColor;
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppRadius.brSm,
              ),
              child: Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          );
        },
      ),
    ];
  }

  TrinaRow<dynamic> _row(ExpiryBatch b, {required bool expired}) {
    return TrinaRow(
      cells: {
        _fName: TrinaCell(value: b.brandName),
        _fWarehouse: TrinaCell(value: b.warehouseName),
        _fExpiry: TrinaCell(value: _ymd(b.expiryDate)),
        _fDays: TrinaCell(value: b.daysLeft),
        _fQty: TrinaCell(value: b.quantityAvailable),
        _fStatus: TrinaCell(
            value:
                expired ? AppStrings.expiredTab : AppStrings.expiringSoonTab),
      },
    );
  }

  static String _ymd(DateTime d) {
    final l = d.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')}';
  }
}
