import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saydaliati/core/constants/app_strings.dart';

/// (code, arabic name) — Syria first (default).
const List<(String, String)> kDialCodes = [
  ('+963', 'سوريا'),
  ('+90', 'تركيا'),
  ('+961', 'لبنان'),
  ('+962', 'الأردن'),
  ('+964', 'العراق'),
  ('+966', 'السعودية'),
  ('+971', 'الإمارات'),
  ('+20', 'مصر'),
];

/// Phone input with a country dial-code dropdown (defaults to Syria +963).
/// Reports the full international number (digits only, no '+') via [onChanged].
class PhoneField extends StatefulWidget {
  const PhoneField({
    required this.controller,
    required this.onChanged,
    this.required = true,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool required;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String _dial = kDialCodes.first.$1; // +963

  String get _full => '${_dial.replaceAll('+', '')}${widget.controller.text.trim()}';

  void _emit() => widget.onChanged(_full);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _emit());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      textDirection: TextDirection.ltr, // keep [code][number] order tidy
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _dial,
              borderRadius: BorderRadius.circular(12),
              items: [
                for (final c in kDialCodes)
                  DropdownMenuItem(
                    value: c.$1,
                    child: Text('${c.$1}  ${c.$2}',
                        style: theme.textTheme.bodyMedium),
                  ),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _dial = v);
                _emit();
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: AppStrings.phoneField,
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: widget.required
                ? (v) => (v == null || v.trim().isEmpty)
                    ? AppStrings.requiredField
                    : null
                : null,
            onChanged: (_) => _emit(),
          ),
        ),
      ],
    );
  }
}
