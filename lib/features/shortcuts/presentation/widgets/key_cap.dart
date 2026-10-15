import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';

/// مفتاح واحد مرسوم كزرّ لوحة مفاتيح صغير.
class KeyCap extends StatelessWidget {
  const KeyCap(this.label, {this.tone = KeyCapTone.neutral, super.key});

  final String label;
  final KeyCapTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (bg, fg, border) = switch (tone) {
      KeyCapTone.neutral => (
          theme.colorScheme.surface,
          theme.colorScheme.onSurface,
          context.semantic.border,
        ),
      KeyCapTone.active => (
          theme.colorScheme.primary.withValues(alpha: 0.10),
          theme.colorScheme.primary,
          theme.colorScheme.primary.withValues(alpha: 0.45),
        ),
      KeyCapTone.error => (
          theme.colorScheme.error.withValues(alpha: 0.08),
          theme.colorScheme.error,
          theme.colorScheme.error.withValues(alpha: 0.45),
        ),
      KeyCapTone.muted => (
          theme.colorScheme.surface,
          context.semantic.textSecondary,
          context.semantic.border,
        ),
    };

    return Container(
      constraints: const BoxConstraints(minWidth: 30),
      height: 26,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: AppRadius.brXs,
        // حافّة سفلية أغمق تُوحي بسمك المفتاح — أثر خفيف لا ظلّ ثقيل.
        boxShadow: [
          BoxShadow(
            color: border,
            offset: const Offset(0, 1.4),
          ),
        ],
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: theme.textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

enum KeyCapTone { neutral, active, error, muted }

/// تركيبة كاملة مرسومة كمفاتيح متتابعة: `Ctrl` + `S`.
class KeyComboView extends StatelessWidget {
  const KeyComboView(this.combo, {this.tone = KeyCapTone.neutral, super.key});

  final KeyCombo combo;
  final KeyCapTone tone;

  @override
  Widget build(BuildContext context) {
    final parts = combo.parts;
    return Directionality(
      // التركيبة تُقرأ يساراً-يميناً دوماً (Ctrl ثم المفتاح) حتى في واجهة RTL.
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < parts.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  '+',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.semantic.textSecondary,
                      ),
                ),
              ),
            KeyCap(parts[i], tone: tone),
          ],
        ],
      ),
    );
  }
}
