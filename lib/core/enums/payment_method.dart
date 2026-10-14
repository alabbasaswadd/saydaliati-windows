/// How money changed hands on a sale/purchase. Mirrors the backend
/// `PaymentMethodEnum` — serialized as an **integer** on the wire.
enum PaymentMethod {
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  mobileWallet,
  credit;

  /// The integer sent to / read from the API.
  int get wire => switch (this) {
        PaymentMethod.cash => 1,
        PaymentMethod.creditCard => 2,
        PaymentMethod.debitCard => 3,
        PaymentMethod.bankTransfer => 4,
        PaymentMethod.mobileWallet => 5,
        PaymentMethod.credit => 6,
      };

  /// The Arabic label shown to the user.
  String get label => switch (this) {
        PaymentMethod.cash => 'نقدي',
        PaymentMethod.creditCard => 'بطاقة ائتمان',
        PaymentMethod.debitCard => 'بطاقة خصم',
        PaymentMethod.bankTransfer => 'تحويل بنكي',
        PaymentMethod.mobileWallet => 'محفظة إلكترونية',
        PaymentMethod.credit => 'آجل',
      };

  /// آجل يتطلب عميلاً/مورّداً مُختاراً — تُستخدم لإلزام الاختيار بالواجهة.
  bool get requiresParty => this == PaymentMethod.credit;

  /// Maps a wire integer back to the enum; anything unexpected falls back to cash.
  static PaymentMethod fromWire(int? value) => switch (value) {
        2 => PaymentMethod.creditCard,
        3 => PaymentMethod.debitCard,
        4 => PaymentMethod.bankTransfer,
        5 => PaymentMethod.mobileWallet,
        6 => PaymentMethod.credit,
        _ => PaymentMethod.cash,
      };
}
