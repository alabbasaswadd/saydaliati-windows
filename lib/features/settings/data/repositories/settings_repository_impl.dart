import 'package:saydaliati/core/errors/exceptions.dart';
import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:saydaliati/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._remote);

  final SettingsRemoteDataSource _remote;

  @override
  Future<Result<String?>> getValue(String key) async {
    try {
      return Result.success(await _remote.getValue(key));
    } on NotFoundException {
      // A missing key is not an error — it just isn't set yet.
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> setValue(String key, String value) async {
    try {
      await _remote.setValue(key, value);
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
