import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// The single, uniform way the UI renders a Riverpod [AsyncValue].
///
/// Every screen backed by async state pipes it through here and supplies only the
/// data builder; loading and error presentations are consistent app-wide via
/// [LoadingState] / [ErrorState]. Notifiers surface a `Failure` through
/// [AsyncValue.error], which [ErrorState.fromError] renders (including the
/// "no internet" treatment for connectivity failures).
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final WidgetBuilder? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: false,
      data: data,
      loading: () => loading?.call(context) ?? const LoadingState(),
      error: (err, stack) =>
          error?.call(err, stack) ?? ErrorState.fromError(err, onRetry: onRetry),
    );
  }
}
