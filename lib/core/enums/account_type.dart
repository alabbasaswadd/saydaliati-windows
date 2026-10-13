/// Chart-of-accounts classification. Mirrors the backend `AccountTypeEnum` —
/// serialized as an **integer** (1..6) on the wire.
enum AccountType {
  asset,
  liability,
  equity,
  revenue,
  expense,
  contraAsset;

  int get wire => index + 1; // Asset=1 … ContraAsset=6.

  String get label => switch (this) {
        AccountType.asset => 'أصول',
        AccountType.liability => 'خصوم',
        AccountType.equity => 'حقوق ملكية',
        AccountType.revenue => 'إيرادات',
        AccountType.expense => 'مصروفات',
        AccountType.contraAsset => 'أصول مقابلة',
      };

  static AccountType fromWire(int? value) {
    if (value == null || value < 1 || value > AccountType.values.length) {
      return AccountType.asset;
    }
    return AccountType.values[value - 1];
  }
}
