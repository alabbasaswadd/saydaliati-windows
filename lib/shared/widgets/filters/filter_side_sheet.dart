import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// A right-side filter panel (an [endDrawer], which Flutter auto-flips to slide
/// in from the right in RTL). Hosts arbitrary filter controls with a header that
/// carries a "clear filters" action. This is the single filtering UX reused
/// across list screens (stock movements, sales invoices, …): a filter button in
/// the AppBar opens this panel.
class FilterSideSheet extends StatelessWidget {
  const FilterSideSheet({required this.children, this.onClear, super.key});

  final List<Widget> children;

  /// When provided, a "مسح الفلاتر" action is shown in the header.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(AppStrings.filters,
                        style: theme.textTheme.titleLarge),
                  ),
                  if (onClear != null)
                    TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                      label: const Text(AppStrings.clearFilters),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
