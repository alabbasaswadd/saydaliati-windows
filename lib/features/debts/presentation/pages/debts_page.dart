import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/debts/debt_providers.dart';
import 'package:saydaliati/features/debts/domain/party_debt.dart';
import 'package:saydaliati/features/debts/presentation/widgets/settle_debt_dialog.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// ديون العملاء — المستحقّ لنا.
class CustomerDebtsPage extends StatelessWidget {
  const CustomerDebtsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const _DebtsGridPage(partyType: PartyType.customer);
}

/// ديون الموردين — المستحقّ علينا.
class SupplierDebtsPage extends StatelessWidget {
  const SupplierDebtsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const _DebtsGridPage(partyType: PartyType.supplier);
}

/// شبكة الذمم — بأسلوب بقية الشاشات: شريط إحصاءات فوق جدول واحد.
///
/// صفحتان لا تبويبان: الاتجاهان لا يُجمعان في جدول واحد — دين العميل **أصل**
/// لنا ودين المورّد **خصم** علينا، وجمع العمودين يُنتج رقماً بلا معنى
/// محاسبي. والشريط الجانبي يفتح كلاً منهما مباشرةً.
///
/// الأرقام من **أرصدة دفتر الأستاذ** لا من دفتر الذمم، فالتسديد يظهر فوراً.
class _DebtsGridPage extends ConsumerStatefulWidget {
  const _DebtsGridPage({required this.partyType});

  final PartyType partyType;

  @override
  ConsumerState<_DebtsGridPage> createState() => _DebtsGridPageState();
}

class _DebtsGridPageState extends ConsumerState<_DebtsGridPage> {
  static const _fName = 'name';
  static const _fBalance = 'balance';
  static const _fCurrency = 'currency';
  static const _fAction = 'action';
  static const _fId = 'id';

  bool get _isCustomer => widget.partyType == PartyType.customer;

  /// المزوّدان مختلفا النوع المولَّد، فالاختيار عند الاستعمال لا في حقل
  /// مشترك — الحقل المشترك يُفقد التنميط فيصير كل شيء `dynamic`.
  AsyncValue<List<PartyDebt>> _watch() => _isCustomer
      ? ref.watch(customerDebtsProvider)
      : ref.watch(supplierDebtsProvider);

  /// يُعيد `Future` لا `void`: زرّ التحديث ينتظره ليدور إلى أن تصل البيانات.
  Future<void> _refresh() => _isCustomer
      ? ref.refresh(customerDebtsProvider.future)
      : ref.refresh(supplierDebtsProvider.future);

  Future<void> _settle(PartyDebt debt) async {
    final done = await showSettleDebtDialog(
      context,
      partyType: widget.partyType,
      debt: debt,
    );
    // تُقرأ القائمة من الخادم لا يُعدَّل الرقم محلياً: الرصيد قد تغيّر
    // بفاتورة أو تسديد آخر بين العرض والتسديد.
    if (done) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final async = _watch();
    final base = ref.watch(baseCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isCustomer ? 'ديون العملاء' : 'ديون الموردين'),
        actions: [
          AppRefreshButton(onRefresh: _refresh),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e, onRetry: _refresh),
        data: (items) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              _stats(items, base?.code),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: items.isEmpty
                    ? EmptyState(
                        icon: Icons.check_circle_outline,
                        message: _isCustomer
                            ? 'لا ديون على العملاء'
                            : 'لا ديون للموردين',
                      )
                    : _grid(context, items, base?.code),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stats(List<PartyDebt> items, String? code) {
    final total = items.fold<double>(0, (sum, d) => sum + d.balance);
    final largest = items.isEmpty
        ? 0.0
        : items.map((d) => d.balance).reduce((a, b) => a > b ? a : b);
    final unit = code == null ? '' : ' $code';

    return StatChipsBar(
      chips: [
        StatChip(
          icon: Icons.account_balance_wallet_outlined,
          label: _isCustomer ? 'المستحقّ لنا' : 'المستحقّ علينا',
          value: '${Formatters.number(total)}$unit',
          color: Theme.of(context).colorScheme.error,
        ),
        StatChip(
          icon: _isCustomer
              ? Icons.person_outline
              : Icons.local_shipping_outlined,
          label: _isCustomer ? 'عملاء مدينون' : 'موردون دائنون',
          value: '${items.length}',
        ),
        StatChip(
          icon: Icons.arrow_upward,
          label: 'أكبر دين',
          value: '${Formatters.number(largest)}$unit',
        ),
      ],
    );
  }

  Widget _grid(BuildContext context, List<PartyDebt> items, String? code) {
    final byId = {for (final d in items) d.partyId: d};

    return AppGrid(
      columns: [
        appGridTextColumn(
          _isCustomer ? 'العميل' : 'المورّد',
          _fName,
          width: 280,
          flexible: true,
        ),
        appGridNumberColumn(
          'الدين',
          _fBalance,
          width: 150,
          renderer: (ctx) {
            final v = ctx.cell.value;
            final n = v is num ? v.toDouble() : 0.0;
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                Formatters.number(n),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          },
        ),
        // العملة في عمودها لا في ترويسة الدين: الترويسة تُقرأ مرّة ثم تُنسى
        // عند التمرير، والعمود يبقى بجانب كل رقم.
        //
        // الرمز واحدٌ في كل الصفوف بالضرورة: حساب الطرف بلا عملة خاصة،
        // فالدين يُسجَّل بالأساسية بسعر الفاتورة. وفاتورة بالدولار وأخرى
        // بالليرة لنفس العميل تصيران رقماً واحداً — فلا عملة «خاصة بالعميل»
        // تُعرَض، بل وحدة قياس الرصيد.
        appGridTextColumn(
          'العملة',
          _fCurrency,
          width: 90,
          textAlign: TrinaColumnTextAlign.center,
        ),
        // عمود إجراء: الزرّ داخل الصفّ لا في شريط علوي — فلا يُسأل «أيّ صفّ
        // سيُسدَّد؟» بعد اختيار الزرّ.
        appGridTextColumn(
          'التسديد',
          _fAction,
          width: 130,
          textAlign: TrinaColumnTextAlign.center,
          renderer: (ctx) {
            final id = ctx.row.cells[_fId]?.value?.toString();
            final debt = id == null ? null : byId[id];
            if (debt == null) return const SizedBox.shrink();

            return _SettleButton(
              isCustomer: _isCustomer,
              partyName: debt.partyName,
              onPressed: () => _settle(debt),
            );
          },
        ),
        appGridTextColumn('المعرّف', _fId, hide: true),
      ],
      // النقر المزدوج على الصفّ يفتح التسديد أيضاً — نفس عادة بقية الشبكات.
      onRowDoubleTap: (event) {
        final id = event.row.cells[_fId]?.value?.toString();
        final debt = id == null ? null : byId[id];
        if (debt != null) _settle(debt);
      },
      rows: [
        for (final d in items)
          TrinaRow(cells: {
            _fName: TrinaCell(
                value: d.partyName.isEmpty ? widget.partyType.label : d.partyName),
            _fBalance: TrinaCell(value: d.balance),
            _fCurrency: TrinaCell(value: code ?? ''),
            _fAction: TrinaCell(value: ''),
            _fId: TrinaCell(value: d.partyId),
          }),
      ],
    );
  }
}

/// زرّ التسديد داخل خليّة الشبكة.
///
/// مكوّن مخصَّص لا `FilledButton`: ارتفاع صفّ الشبكة **٣٦** بكسلاً، وأزرار
/// ماتيريال لها ارتفاع أدنى ٤٠ — فكان الزرّ يُضغَط ويقضم حدود الصفّ. هنا
/// الارتفاع مضبوط بـ٢٦ فيبقى داخل الصفّ بهامش مريح.
///
/// ملوَّن بلون أساسي خفيف لا مُفرَغاً: هو الإجراء الوحيد في الصفّ وأهمّ ما
/// فيه، لكنه يتكرّر في كل سطر — فلون صريح في كل صفّ يُنتج جداراً من اللون.
class _SettleButton extends StatefulWidget {
  const _SettleButton({
    required this.isCustomer,
    required this.partyName,
    required this.onPressed,
  });

  final bool isCustomer;
  final String partyName;
  final VoidCallback onPressed;

  @override
  State<_SettleButton> createState() => _SettleButtonState();
}

class _SettleButtonState extends State<_SettleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final label = widget.isCustomer ? 'قبض' : 'دفع';
    final name = widget.partyName.trim();

    return Center(
      child: Tooltip(
        message: widget.isCustomer
            ? (name.isEmpty ? 'قبض دفعة من العميل' : 'قبض دفعة من $name')
            : (name.isEmpty ? 'دفع دفعة للمورّد' : 'دفع دفعة إلى $name'),
        waitDuration: const Duration(milliseconds: 400),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: 26,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: _hovered ? 0.18 : 0.09),
                borderRadius: AppRadius.brXs,
                border: Border.all(
                  color: primary.withValues(alpha: _hovered ? 0.55 : 0.28),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isCustomer
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    size: 14,
                    color: primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
