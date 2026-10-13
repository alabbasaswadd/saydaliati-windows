/// One entry in a currency's exchange-rate history: the rate and when it
/// took effect. (rate = units of this currency per 1 unit of the base currency)
class CurrencyRateEntry {
  const CurrencyRateEntry({required this.rate, required this.effectiveDate});

  final double rate;
  final DateTime effectiveDate;

  factory CurrencyRateEntry.fromJson(Map<String, dynamic> json) =>
      CurrencyRateEntry(
        rate: (json['exchangeRate'] as num?)?.toDouble() ?? 0,
        effectiveDate: DateTime.tryParse(json['effectiveDate']?.toString() ?? '')
                ?.toLocal() ??
            DateTime(1970),
      );
}
