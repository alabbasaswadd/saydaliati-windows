import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';

/// A customer. Pure domain model.
@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) = _Customer;

  const Customer._();

  String get fullName => [firstName, lastName].where((x) => x.isNotEmpty).join(' ');
}
