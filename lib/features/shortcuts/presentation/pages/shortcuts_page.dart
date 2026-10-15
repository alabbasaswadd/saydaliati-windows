import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/shortcuts/domain/entities/shortcut_binding.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcuts_controller.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/key_cap.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/shortcut_recorder.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// شاشة اختصارات لوحة المفاتيح — عرض كل إجراء قابل للربط وتعديل تركيبته.
///
/// التحرير يجري على مسوّدة محلية ثم يُحفظ دفعة واحدة، فيستطيع المستخدم إعادة
/// ترتيب عدّة اختصارات (وتبديل تركيبتين بينهما) قبل أن يُثبّت أيّ شيء.
class ShortcutsPage extends ConsumerStatefulWidget {
  const ShortcutsPage({super.key});

  @override
  ConsumerState<ShortcutsPage> createState() => _ShortcutsPageState();
}

class _ShortcutsPageState extends ConsumerState<ShortcutsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(shortcutsControllerProvider);
    final theme = Theme.of(context);

    if (draft.loading) {
      return const Scaffold(
        appBar: _ShortcutsAppBar(),
        body: LoadingState(message: 'جارٍ تحميل الاختصارات…'),
      );
    }

    final conflicts = draft.conflicts;
    final q = _query.trim();
    final sections = [
      for (final section in ShortcutSection.values)
        (
          section,
          draft.bindings
              .where((b) => b.action.section == section)
              .where((b) => q.isEmpty || _matches(b, q))
              .toList(),
        ),
    ].where((e) => e.$2.isNotEmpty).toList();

    return Scaffold(
      appBar: const _ShortcutsAppBar(),
      body: Column(
        children: [
          _Toolbar(
            onSearch: (v) => setState(() => _query = v),
            conflictCount: conflicts.length,
            saving: draft.saving,
            onResetAll: _resetAll,
            onSave: conflicts.isEmpty ? _save : null,
          ),
          Container(height: 1, color: context.semantic.border),
          Expanded(
            child: sections.isEmpty
                ? const EmptyState(message: 'لا إجراء يطابق البحث')
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      for (final (section, bindings) in sections) ...[
                        _SectionHeader(section: section),
                        const SizedBox(height: AppSpacing.sm),
                        Card(
                          child: Column(
                            children: [
                              for (var i = 0; i < bindings.length; i++) ...[
                                if (i > 0) const Divider(height: 1),
                                _ShortcutRow(
                                  binding: bindings[i],
                                  conflict:
                                      conflicts.contains(bindings[i].combo),
                                  conflictWith: draft.conflictingWith(
                                      bindings[i].action, bindings[i].combo),
                                  onRecord: () => _record(bindings[i]),
                                  onReset: () => ref
                                      .read(shortcutsControllerProvider.notifier)
                                      .resetOne(bindings[i].action),
                                  onToggle: (v) => ref
                                      .read(shortcutsControllerProvider.notifier)
                                      .setEnabled(bindings[i].action, v),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      _HintFooter(theme: theme),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  bool _matches(ShortcutBinding b, String q) {
    final needle = q.toLowerCase();
    return b.action.label.toLowerCase().contains(needle) ||
        b.combo.wire.toLowerCase().contains(needle) ||
        (b.action.hint?.toLowerCase().contains(needle) ?? false);
  }

  Future<void> _record(ShortcutBinding binding) async {
    final combo = await showShortcutRecorder(context, action: binding.action);
    if (combo == null || !mounted) return;
    ref.read(shortcutsControllerProvider.notifier)
        .setCombo(binding.action, combo);
  }

  Future<void> _resetAll() async {
    final ok = await showConfirmationDialog(
      context,
      title: 'إعادة الاختصارات الافتراضية؟',
      message: 'ستعود كل الاختصارات لتركيباتها الأصلية. لن يُطبَّق ذلك قبل الحفظ.',
      confirmLabel: 'إعادة',
      icon: Icons.restart_alt,
    );
    if (!ok || !mounted) return;
    ref.read(shortcutsControllerProvider.notifier).resetAll();
  }

  Future<void> _save() async {
    final failure = await ref.read(shortcutsControllerProvider.notifier).save();
    if (!mounted) return;
    if (failure != null) {
      showFailureSnackbar(context, failure);
      return;
    }
    AppSnackbar.success(context, 'حُفظت الاختصارات وصارت فعّالة');
  }
}

class _ShortcutsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ShortcutsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      AppBar(title: const Text('اختصارات لوحة المفاتيح'));
}

/// شريط الأدوات: بحث + حالة التعارض + إعادة الافتراضي + حفظ.
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.onSearch,
    required this.conflictCount,
    required this.saving,
    required this.onResetAll,
    required this.onSave,
  });

  final ValueChanged<String> onSearch;
  final int conflictCount;
  final bool saving;
  final VoidCallback onResetAll;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 320,
            child: AppSearchField(
              hint: 'ابحث عن إجراء أو تركيبة',
              onChanged: onSearch,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (conflictCount > 0)
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.error_outline,
                      size: AppSizes.iconSm, color: theme.colorScheme.error),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      'تركيبة واحدة لأكثر من إجراء — عدّل التعارض قبل الحفظ',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            )
          else
            const Spacer(),
          AppButton.text(
            label: 'إعادة الافتراضي',
            icon: Icons.restart_alt,
            onPressed: onResetAll,
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 160,
            child: AppButton.primary(
              label: saving ? 'جارٍ الحفظ…' : 'حفظ',
              icon: Icons.save_outlined,
              isLoading: saving,
              onPressed: onSave,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.section});

  final ShortcutSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(section.icon,
            size: AppSizes.iconSm, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(section.label, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

/// سطر إجراء واحد: الاسم والشرح، ثم التركيبة كمفاتيح، ثم أزرار التعديل.
class _ShortcutRow extends StatefulWidget {
  const _ShortcutRow({
    required this.binding,
    required this.conflict,
    required this.conflictWith,
    required this.onRecord,
    required this.onReset,
    required this.onToggle,
  });

  final ShortcutBinding binding;
  final bool conflict;
  final ShortcutAction? conflictWith;
  final VoidCallback onRecord;
  final VoidCallback onReset;
  final ValueChanged<bool> onToggle;

  @override
  State<_ShortcutRow> createState() => _ShortcutRowState();
}

class _ShortcutRowState extends State<_ShortcutRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = widget.binding;
    final enabled = b.isEnabled;

    final tone = widget.conflict
        ? KeyCapTone.error
        : !enabled
            ? KeyCapTone.muted
            : b.isCustom
                ? KeyCapTone.active
                : KeyCapTone.neutral;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: enabled ? widget.onRecord : null,
        child: Container(
          color: _hovered
              ? theme.colorScheme.primary.withValues(alpha: 0.04)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(b.action.icon,
                  size: AppSizes.iconSm,
                  color: enabled
                      ? context.semantic.textSecondary
                      : context.semantic.textSecondary.withValues(alpha: 0.5)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      b.action.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: enabled
                            ? theme.colorScheme.onSurface
                            : context.semantic.textSecondary,
                      ),
                    ),
                    if (widget.conflict && widget.conflictWith != null)
                      Text(
                        'تتعارض مع «${widget.conflictWith!.label}»',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.error),
                      )
                    else if (b.action.hint != null)
                      Text(b.action.hint!, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              KeyComboView(b.combo, tone: tone),
              const SizedBox(width: AppSpacing.md),
              // التخصيص يُعلَن بأيقونة إرجاع تظهر فقط لمن خُصِّص — فلا يزدحم
              // السطر الافتراضي بأزرار لا تفعل شيئاً.
              SizedBox(
                width: 36,
                child: b.isCustom
                    ? IconButton(
                        icon: const Icon(Icons.restart_alt, size: 18),
                        tooltip: 'إرجاع الافتراضي (${b.action.defaultCombo})',
                        visualDensity: VisualDensity.compact,
                        onPressed: widget.onReset,
                      )
                    : null,
              ),
              Tooltip(
                message: enabled ? 'تعطيل الاختصار' : 'تفعيل الاختصار',
                child: Switch(
                  value: enabled,
                  onChanged: widget.onToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HintFooter extends StatelessWidget {
  const _HintFooter({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline,
            size: AppSizes.iconSm, color: context.semantic.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'الاختصار رمزان كحدّ أقصى: مُعدِّل (Ctrl أو Alt أو Shift) مع مفتاح، '
            'أو مفتاح وظيفي وحده (F1…F12) أو أحد مفاتيح التنقّل. '
            'الحرف أو الرقم وحده غير مسموح لأنه يبتلع الكتابة في الحقول.',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
