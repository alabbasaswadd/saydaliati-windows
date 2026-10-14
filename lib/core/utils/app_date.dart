/// Central date formatting for user-facing dates. Keeps the `YYYY-MM-DD` format
/// consistent app-wide and adds the Arabic weekday name (اليوم) shown under the
/// date, so a screen never re-implements either.
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
  static String ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// `14:30`.
  static String hm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// `2026-09-09 14:30`.
  static String ymdHm(DateTime d) => '${ymd(d)} ${hm(d)}';

  /// Arabic weekday name, e.g. `الأحد`.
  static String weekdayAr(DateTime d) => _weekdaysAr[d.weekday - 1];
}
