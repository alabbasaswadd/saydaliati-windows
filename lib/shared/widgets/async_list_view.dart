import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/shared/widgets/async_value_widget.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// A pull-to-refresh list backed by `AsyncValue<List<T>>`, with consistent
/// loading / empty / error states. Used by the simple (non-paged) list pages.
class AsyncListView<T> extends StatelessWidget {
  const AsyncListView({
    required this.value,
    required this.itemBuilder,
    required this.onRefresh,
    this.emptyMessage,
    this.padding,
    super.key,
  });

  final AsyncValue<List<T>> value;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Future<void> Function() onRefresh;
  final String? emptyMessage;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: AsyncValueWidget(
        value: value,
        onRetry: onRefresh,
        data: (items) {
          if (items.isEmpty) {
            return _ScrollableFill(child: EmptyState(message: emptyMessage));
          }
          return ListView.builder(
            padding: padding,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(context, items[index]),
          );
        },
      ),
    );
  }
}

/// Makes a placeholder fill the viewport so pull-to-refresh works when empty.
class _ScrollableFill extends StatelessWidget {
  const _ScrollableFill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );
  }
}
