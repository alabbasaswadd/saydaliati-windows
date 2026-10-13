import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';

/// A standardized search box: search icon, clear button, and an `onChanged`
/// callback. Manages its own controller so callers just react to changes.
///
/// Pass [debounce] to coalesce rapid typing into a single [onChanged] after the
/// user pauses — useful when each change triggers an expensive query. Clearing
/// via the ✕ button always fires immediately. Default (null) = fire per keystroke.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.onChanged,
    this.hint,
    this.initialValue,
    this.debounce,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final String? hint;
  final String? initialValue;
  final Duration? debounce;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Fires [onChanged] now, or after [debounce] when set.
  void _emit(String value) {
    final d = widget.debounce;
    if (d == null) {
      widget.onChanged(value);
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(d, () => widget.onChanged(value));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (v) {
        _emit(v);
        setState(() {}); // toggle the clear button (immediate)
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint ?? AppStrings.search,
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _debounceTimer?.cancel();
                  _controller.clear();
                  widget.onChanged(''); // clear is immediate
                  setState(() {});
                },
              ),
      ),
    );
  }
}
