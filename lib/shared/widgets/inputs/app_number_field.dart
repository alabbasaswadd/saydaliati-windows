import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// Numeric input. [allowDecimal] permits a single decimal point; otherwise
/// integers only. Builds on [AppTextField].
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
    this.allowDecimal = true,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool enabled;
  final bool allowDecimal;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      isRequired: isRequired,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      onChanged: onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
        ),
      ],
    );
  }
}

/// Price/amount input — decimal number with an optional currency symbol suffix.
class AppCurrencyField extends StatelessWidget {
  const AppCurrencyField({
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
    this.currencySymbol,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool enabled;
  final String? currencySymbol;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppNumberField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      isRequired: isRequired,
      enabled: enabled,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.payments_outlined),
      suffixIcon: currencySymbol == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Align(
                alignment: Alignment.center,
                widthFactor: 1,
                child: Text(currencySymbol!),
              ),
            ),
    );
  }
}
