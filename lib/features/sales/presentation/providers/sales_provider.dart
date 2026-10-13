import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/sale_providers.dart';

part 'sales_provider.g.dart';

/// The sales invoices as an [AsyncValue] (online), with optional filters
/// (date range + customer + medicine + currency). No args → all invoices.
@riverpod
Future<List<Sale>> salesList(
  Ref ref, {
  String? fromIso,
  String? toIso,
  String? customerId,
  String? medicineId,
  String? currencyId,
  bool? isPrescription,
}) async {
  final result = await ref.watch(saleRepositoryProvider).getSales(
        fromIso: fromIso,
        toIso: toIso,
        customerId: customerId,
        medicineId: medicineId,
        currencyId: currencyId,
        isPrescription: isPrescription,
      );
  return result.fold((list) => list, (failure) => throw failure);
}
