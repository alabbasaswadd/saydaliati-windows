import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/manufacturers/domain/entities/manufacturer.dart';

abstract interface class ManufacturerRepository {
  Future<Result<List<Manufacturer>>> getManufacturers();
  Future<Result<void>> create({required String name, String location});
  Future<Result<void>> update({
    required String id,
    required String name,
    String location,
  });
  Future<Result<void>> delete(String id);
}
