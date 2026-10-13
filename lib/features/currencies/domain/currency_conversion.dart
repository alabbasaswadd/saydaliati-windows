import 'package:saydaliati/features/currencies/domain/entities/currency.dart';

/// Converts a price expressed in the **base** currency into [target].
///
/// The backend stores medicine prices without a currency, so we treat them as
/// base-currency amounts. `Currency.exchangeRate` means **how many units of
/// that currency equal one unit of the base currency** (base rate = 1). So for
/// base USD and target SYP with rate 48 (1 USD = 48 SYP):
/// `amountInTarget = baseAmount * target.rate / base.rate`.
///
/// Returns the amount unchanged when conversion isn't possible (missing/base
/// target, or a non-positive rate).
double convertFromBase(double baseAmount, Currency? base, Currency? target) {
  if (base == null || target == null) return baseAmount;
  if (base.id == target.id) return baseAmount;
  if (base.exchangeRate <= 0 || target.exchangeRate <= 0) return baseAmount;
  return baseAmount * target.exchangeRate / base.exchangeRate;
}

/// Inverse of [convertFromBase]: converts an amount expressed in [source] back
/// into the base currency. Used on write so everything is stored in the base
/// currency regardless of the currency the user entered it in.
double convertToBase(double sourceAmount, Currency? base, Currency? source) {
  if (base == null || source == null) return sourceAmount;
  if (base.id == source.id) return sourceAmount;
  if (base.exchangeRate <= 0 || source.exchangeRate <= 0) return sourceAmount;
  return sourceAmount * base.exchangeRate / source.exchangeRate;
}
