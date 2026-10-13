/// An available stock batch of a medicine (for choosing the expiry in the POS).
class MedicineBatch {
  const MedicineBatch({
    required this.stockId,
    required this.quantityAvailable,
    this.expiryDate,
  });

  final String stockId;
  final double quantityAvailable;
  final DateTime? expiryDate;

  factory MedicineBatch.fromJson(Map<String, dynamic> json) => MedicineBatch(
        stockId: (json['stockId'] ?? '') as String,
        quantityAvailable: ((json['quantityAvailable'] ?? 0) as num).toDouble(),
        expiryDate: json['expiryDate'] == null
            ? null
            : DateTime.tryParse(json['expiryDate'] as String),
      );

  /// e.g. "2027-12-01".
  String get expiryLabel => expiryDate == null
      ? '—'
      : '${expiryDate!.year}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}';
}
