/// The pharmaceutical form of a medicine. Mirrors the backend `DosageFormEnum`
/// — serialized as an **integer** (1..12) on the wire.
enum DosageForm {
  tablet,
  capsule,
  syrup,
  injection,
  cream,
  ointment,
  gel,
  drops,
  inhaler,
  suppository,
  powder,
  lotion;

  int get wire => index + 1; // Tablet=1 … Lotion=12, in declaration order.

  String get label => switch (this) {
        DosageForm.tablet => 'أقراص',
        DosageForm.capsule => 'كبسولات',
        DosageForm.syrup => 'شراب',
        DosageForm.injection => 'حقن',
        DosageForm.cream => 'كريم',
        DosageForm.ointment => 'مرهم',
        DosageForm.gel => 'جل',
        DosageForm.drops => 'قطرة',
        DosageForm.inhaler => 'بخّاخ',
        DosageForm.suppository => 'تحاميل',
        DosageForm.powder => 'مسحوق',
        DosageForm.lotion => 'غسول',
      };

  /// Maps a wire integer (1-based) back to the enum; out-of-range falls back to
  /// [DosageForm.tablet].
  static DosageForm fromWire(int? value) {
    if (value == null || value < 1 || value > DosageForm.values.length) {
      return DosageForm.tablet;
    }
    return DosageForm.values[value - 1];
  }
}
