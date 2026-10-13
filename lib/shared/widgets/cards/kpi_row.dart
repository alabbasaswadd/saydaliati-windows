import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// Responsive KPI strip: fixed-width tiles that wrap on narrow panes instead
/// of a `Row` of `Expanded`s stretching (or a lone tile spanning the window).
///
/// Give it `StatTile`/`StatCard`-like children; each is clamped to
/// [tileWidth] and the strip wraps as needed.
class KpiRow extends StatelessWidget {
  const KpiRow({
    required this.tiles,
    this.tileWidth = 240,
    super.key,
  });

  final List<Widget> tiles;
  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          for (final t in tiles) SizedBox(width: tileWidth, child: t),
        ],
      ),
    );
  }
}
