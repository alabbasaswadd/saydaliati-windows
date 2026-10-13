import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/announcements/domain/announcement.dart';
import 'package:url_launcher/url_launcher.dart';

/// A polished one-time announcement popup. The type drives the accent color,
/// icon and chip label (نظام/معلومة/فائدة…). Shown once on app open, then
/// acknowledged by the caller so it never reappears.
///
/// When there are several, [index]/[total] render a subtle "1 / 3" counter and
/// the primary button becomes "التالي" until the last one.
class AnnouncementDialog extends StatelessWidget {
  const AnnouncementDialog({
    required this.announcement,
    this.index = 0,
    this.total = 1,
    super.key,
  });

  final Announcement announcement;
  final int index;
  final int total;

  Future<void> _openLink() async {
    final url = announcement.linkUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = announcement.type.color;
    final isLast = index >= total - 1;

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Accent header: icon badge + type chip =====
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent.withValues(alpha: 0.16), accent.withValues(alpha: 0.04)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(announcement.type.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: 3),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.18),
                            borderRadius: AppRadius.brSm,
                          ),
                          child: Text(
                            announcement.type.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (total > 1) ...[
                          const SizedBox(height: 4),
                          Text('${index + 1} / $total',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: theme.hintColor)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== Body: title + text (scrolls if long) =====
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      announcement.body,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                    if (announcement.linkUrl != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          onPressed: _openLink,
                          style: TextButton.styleFrom(foregroundColor: accent),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('فتح الرابط'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ===== Action =====
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.brMd),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(isLast ? 'تم' : 'التالي',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
