import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/alternatives/data/alternatives_remote_data_source.dart';
import 'package:saydaliati/features/medicines/data/dtos/medicine_dto.dart';
import 'package:saydaliati/features/medicines/data/mappers/medicine_mapper.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';

part 'alternatives_providers.g.dart';

@riverpod
AlternativesRemoteDataSource alternativesRemoteDataSource(Ref ref) =>
    AlternativesRemoteDataSource(ref.watch(apiClientProvider));

/// The alternatives of a medicine (same active ingredient), decoded to [Medicine]
/// so the UI reuses the existing model (brand name, manufacturer, priced units).
@riverpod
Future<List<Medicine>> medicineAlternatives(Ref ref, String medicineId) async {
  final raw = await ref.watch(alternativesRemoteDataSourceProvider).forMedicine(medicineId);
  return raw.map((m) => MedicineDto.fromJson(m).toEntity()).toList();
}
