import 'package:intl/intl.dart';

/// Shared, reusable formatting helpers so numbers/money/dates look identical
/// everywhere. Uses Arabic (Syria) grouping but keeps Western digits for clarity
/// on receipts and reports.
abstract final class Formatters {
  const Formatters._();

  static final NumberFormat _decimal = NumberFormat('#,##0.##', 'en');
  static final NumberFormat _integer = NumberFormat('#,##0', 'en');

  /// `1234.5` → `1,234.5`. Drops a trailing `.0`.
  static String number(num value) => _decimal.format(value);

  /// `1234` → `1,234`.
  static String integer(num value) => _integer.format(value);

  /// A money amount with an optional currency symbol/code suffix:
  /// `money(1234.5, 'ل.س')` → `1,234.5 ل.س`.
  static String money(num value, [String? symbol]) {
    final n = _decimal.format(value);
    return symbol == null || symbol.isEmpty ? n : '$n $symbol';
  }

  /// A short quantity, dropping a redundant `.0` (3 not 3.0, but 1.5 stays).
  static String qty(num value) {
    final d = value.toDouble();
    return d == d.roundToDouble() ? d.toStringAsFixed(0) : d.toString();
  }
}
