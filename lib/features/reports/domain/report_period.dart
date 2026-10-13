import 'package:saydaliati/core/constants/app_strings.dart';

/// The kind of reporting window the user picked.
enum ReportPeriodKind { today, week, month, year, custom }

/// A date window for reports. [start] is inclusive, [end] is exclusive
/// (half-open), so a single call covers `start <= x < end`. Times are local;
/// convert with `.toUtc()` when sending to the API (PostgreSQL timestamptz).
class ReportPeriod {
  const ReportPeriod({
    required this.kind,
    required this.start,
    required this.end,
  });

  final ReportPeriodKind kind;
  final DateTime start;
  final DateTime end;

  factory ReportPeriod.today([DateTime? now]) {
    final n = now ?? DateTime.now();
    final startOfDay = DateTime(n.year, n.month, n.day);
    return ReportPeriod(
      kind: ReportPeriodKind.today,
      start: startOfDay,
      end: startOfDay.add(const Duration(days: 1)),
    );
  }

  factory ReportPeriod.week([DateTime? now]) {
    final n = now ?? DateTime.now();
    final startOfDay = DateTime(n.year, n.month, n.day);
    // Week starts on Saturday (weekday 6 in Dart: Sat=6, Sun=7...). Normalize so
    // Saturday is day 0 of the week.
    final offset = (startOfDay.weekday + 1) % 7; // Sat->0, Sun->1, ... Fri->6
    final startOfWeek = startOfDay.subtract(Duration(days: offset));
    return ReportPeriod(
      kind: ReportPeriodKind.week,
      start: startOfWeek,
      end: startOfWeek.add(const Duration(days: 7)),
    );
  }

  factory ReportPeriod.month([DateTime? now]) {
    final n = now ?? DateTime.now();
    final startOfMonth = DateTime(n.year, n.month, 1);
    final startOfNextMonth = DateTime(n.year, n.month + 1, 1);
    return ReportPeriod(
      kind: ReportPeriodKind.month,
      start: startOfMonth,
      end: startOfNextMonth,
    );
  }

  factory ReportPeriod.year([DateTime? now]) {
    final n = now ?? DateTime.now();
    return ReportPeriod(
      kind: ReportPeriodKind.year,
      start: DateTime(n.year, 1, 1),
      end: DateTime(n.year + 1, 1, 1),
    );
  }

  /// A custom inclusive [from]..[to] range (both dates included; [end] is the
  /// day after [to] so the window is half-open).
  factory ReportPeriod.custom(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final endInclusive = DateTime(to.year, to.month, to.day);
    return ReportPeriod(
      kind: ReportPeriodKind.custom,
      start: start,
      end: endInclusive.add(const Duration(days: 1)),
    );
  }

  /// UTC ISO-8601 for the API (inclusive start).
  String get startUtcIso => start.toUtc().toIso8601String();

  /// UTC ISO-8601 for the API (exclusive end).
  String get endUtcIso => end.toUtc().toIso8601String();

  String get label {
    switch (kind) {
      case ReportPeriodKind.today:
        return AppStrings.periodToday;
      case ReportPeriodKind.week:
        return AppStrings.periodWeek;
      case ReportPeriodKind.month:
        return AppStrings.periodMonth;
      case ReportPeriodKind.year:
        return AppStrings.periodYear;
      case ReportPeriodKind.custom:
        final lastDay = end.subtract(const Duration(days: 1));
        return '${_ymd(start)} → ${_ymd(lastDay)}';
    }
  }

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
