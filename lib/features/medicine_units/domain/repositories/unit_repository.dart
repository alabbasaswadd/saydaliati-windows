import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';

abstract interface class UnitRepository {
  Future<Result<List<Unit>>> getUnits();
  Future<Result<void>> create({required String name, String description});
  Future<Result<void>> update({
    required String id,
    required String name,
    String description,
  });
  Future<Result<void>> delete(String id);
}
