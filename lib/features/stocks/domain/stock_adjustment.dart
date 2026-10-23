/// تسوية جرد دفعة واحدة (دواء + صلاحية + مستودع) — يضبط الكمية المتوفّرة إلى
/// العدد الفعليّ. الفرق يُصدِر فاتورة **حقيقية** بالخادم: شراء عند الزيادة
/// (بضاعة موجودة ولم تُسجَّل)، بيع عند النقص (بضاعة خرجت ولم تُسجَّل) —
/// تظهر في قوائم الفواتير وتُنشئ قيدها المحاسبي كأي فاتورة عادية.
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
    this.invoiceId,
    this.invoiceType,
  });

  final double previousQuantity;
  final double newQuantity;
  final double delta;

  /// معرّف فاتورة الشراء/البيع الصادرة فعلياً عن التسوية — null إذا Delta = 0.
  final String? invoiceId;

  /// "Purchase" أو "Sale".
  final String? invoiceType;

  bool get isPurchaseInvoice => invoiceType == 'Purchase';
  bool get isSaleInvoice => invoiceType == 'Sale';

  factory AdjustStockResult.fromJson(Map<String, dynamic> j) => AdjustStockResult(
        previousQuantity: ((j['previousQuantity'] ?? 0) as num).toDouble(),
        newQuantity: ((j['newQuantity'] ?? 0) as num).toDouble(),
        delta: ((j['delta'] ?? 0) as num).toDouble(),
        invoiceId: j['invoiceId'] as String?,
        invoiceType: j['invoiceType'] as String?,
      );
}
