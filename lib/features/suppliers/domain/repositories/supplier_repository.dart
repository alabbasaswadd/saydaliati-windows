import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';

/// Manage suppliers (online-only).
abstract interface class SupplierRepository {
  Future<Result<List<Supplier>>> getSuppliers();
  Future<Result<void>> create(
      {required String name, String contactPerson, String email});
  Future<Result<void>> update({
    required String id,
    required String name,
    String contactPerson,
    String email,
  });
  Future<Result<void>> delete(String id);
}
