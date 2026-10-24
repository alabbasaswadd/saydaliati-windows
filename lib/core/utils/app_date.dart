/// Central date formatting for user-facing dates. Keeps the `YYYY-MM-DD` format
/// consistent app-wide and adds the Arabic weekday name (اليوم) shown under the
/// date, so a screen never re-implements either.
///
/// Every entry point converts to local time first: the API stores/returns
/// UTC (correct for a PostgreSQL `timestamptz`), but a pharmacist reading a
/// report wants Syria time, not GMT. `toLocal()` on an already-local
/// [DateTime] is a no-op, so this is always safe to call.
abstract final class AppDate {
  const AppDate._();

  /// `DateTime.weekday` is Mon=1 … Sun=7, so index with `weekday - 1`.
  static const List<String> _weekdaysAr = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  /// `2026-09-09`.
  static String ymd(DateTime d) {
    final l = d.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')}';
  }

  /// `14:30`.
  static String hm(DateTime d) {
    final l = d.toLocal();
    return '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }

  /// `2026-09-09 14:30`.
  static String ymdHm(DateTime d) => '${ymd(d)} ${hm(d)}';

  /// Arabic weekday name, e.g. `الأحد`.
  static String weekdayAr(DateTime d) => _weekdaysAr[d.toLocal().weekday - 1];
}
