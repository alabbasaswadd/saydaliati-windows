/// Period presets for reports/filters (today / this week / month / year / custom).
/// Week starts on Saturday (Arabic convention).
enum DatePeriod { today, week, month, year, custom }

/// Computes the inclusive `[from, to]` whole-day window for a period preset.
/// For [DatePeriod.custom] pass the picked bounds.
({DateTime from, DateTime to}) periodRange(
  DatePeriod preset, {
  DateTime? customFrom,
  DateTime? customTo,
}) {
  final today = _dateOnly(DateTime.now());
  switch (preset) {
    case DatePeriod.today:
      return (from: today, to: today);
    case DatePeriod.week:
      final start =
          today.subtract(Duration(days: (today.weekday - DateTime.saturday) % 7));
      return (from: start, to: today);
    case DatePeriod.month:
      final n = DateTime.now();
      return (from: DateTime(n.year, n.month, 1), to: today);
    case DatePeriod.year:
      final n = DateTime.now();
      return (from: DateTime(n.year, 1, 1), to: today);
    case DatePeriod.custom:
      final f = _dateOnly(customFrom ?? today);
      final t = _dateOnly(customTo ?? today);
      return (from: f.isAfter(t) ? t : f, to: f.isAfter(t) ? f : t);
  }
}

/// True when [date]'s day falls within the inclusive `[from, to]` window.
bool inRange(DateTime date, DateTime from, DateTime to) {
  final d = _dateOnly(date);
  return !d.isBefore(from) && !d.isAfter(to);
}

String fmtDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
