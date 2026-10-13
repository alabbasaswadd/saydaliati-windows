/// Reusable field validators. These give immediate feedback and cut round-trips,
/// but the server (when present) remains the authoritative source of truth — its
/// 400/422 responses are still surfaced.
///
/// Each returns an error string (for Flutter form validators) or null when valid.
abstract final class Validators {
  const Validators._();

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value, {String field = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) return '$field مطلوب.';
    return null;
  }

  static String? email(String? value, {bool required = true}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return required ? 'البريد الإلكتروني مطلوب.' : null;
    if (!_email.hasMatch(v)) return 'أدخل بريداً إلكترونياً صحيحاً.';
    return null;
  }

  static String? minLength(String? value, int min, {String field = 'هذا الحقل'}) {
    if ((value ?? '').length < min) return '$field يجب أن يكون $min أحرف على الأقل.';
    return null;
  }

  static String? maxLength(String? value, int max, {String field = 'هذا الحقل'}) {
    if ((value ?? '').length > max) return '$field يجب ألا يتجاوز $max حرفاً.';
    return null;
  }

  /// Runs several validators, returning the first error.
  static String? compose(List<String? Function()> checks) {
    for (final check in checks) {
      final error = check();
      if (error != null) return error;
    }
    return null;
  }
}
