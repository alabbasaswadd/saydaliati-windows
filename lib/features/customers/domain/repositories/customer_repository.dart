import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';

/// Manage customers (online-only).
abstract interface class CustomerRepository {
  Future<Result<List<Customer>>> getCustomers();
  Future<Result<void>> create({
    required String firstName,
    String lastName,
    String phone,
    String address,
  });
  Future<Result<void>> update({
    required String id,
    required String firstName,
    String lastName,
    String phone,
    String address,
  });
  Future<Result<void>> delete(String id);
}
