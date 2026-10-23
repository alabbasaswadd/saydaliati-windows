/// تسوية جرد دفعة واحدة (دواء + صلاحية + مستودع) — يضبط الكمية المتوفّرة إلى
/// العدد الفعليّ، فينشئ الخادم حركة مخزون (+/-) وقيداً محاسبياً بالفرق تلقائياً.
class AdjustStockInput {
  const AdjustStockInput({
    required this.medicineId,
    required this.warehouseId,
    required this.newQuantity,
    this.expiryDate,
    this.note,
  });

  final String medicineId;
  final String warehouseId;

  /// الكمية الفعلية بعد الجرد — لا الفرق.
  final double newQuantity;
  final DateTime? expiryDate;
  final String? note;

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'expiryDate': expiryDate?.toIso8601String(),
        'warehouseId': warehouseId,
        'newQuantity': newQuantity,
        'note': note,
      };
}

/// نتيجة التسوية — الفرق محسوبٌ بالخادم لا مقدَّراً بالواجهة.
class AdjustStockResult {
  const AdjustStockResult({
    required this.previousQuantity,
    required this.newQuantity,
    required this.delta,
  });

  final double previousQuantity;
  final double newQuantity;
  final double delta;

  factory AdjustStockResult.fromJson(Map<String, dynamic> j) => AdjustStockResult(
        previousQuantity: ((j['previousQuantity'] ?? 0) as num).toDouble(),
        newQuantity: ((j['newQuantity'] ?? 0) as num).toDouble(),
        delta: ((j['delta'] ?? 0) as num).toDouble(),
      );
}
