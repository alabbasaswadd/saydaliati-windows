/// Payload for `POST pharmacy-api/DamagedGoods`.
/// Each item identifies a medicine + optional warehouse and a quantity to write off.
/// The backend applies FEFO to decide which stock batches to consume.
class CreateDamagedGoodsInput {
  const CreateDamagedGoodsInput({
    required this.date,
    required this.items,
    this.note,
  });

  final DateTime date;
  final String? note;
  final List<DamagedGoodsItemInput> items;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'note': note,
        'items': items.map((i) => i.toJson()).toList(),
      };
}

class DamagedGoodsItemInput {
  const DamagedGoodsItemInput({
    required this.medicineId,
    required this.quantity,
    this.warehouseId,
    this.note,
  });

  final String medicineId;
  final String? warehouseId;
  final double quantity;
  final String? note;

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'warehouseId': warehouseId,
        'quantity': quantity,
        'note': note,
      };
}
