import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/vouchers/data/datasources/voucher_remote_data_source.dart';
import 'package:saydaliati/features/vouchers/domain/entities/voucher.dart';
import 'package:saydaliati/features/vouchers/domain/repositories/voucher_repository.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  const VoucherRepositoryImpl(this.remote);

  final VoucherRemoteDataSource remote;

  @override
  Future<Result<List<Voucher>>> getAll() async {
    try {
      final raw = await remote.list();
      return Result.success(raw.map(_fromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> create(CreateVoucherInput input) async {
    try {
      await remote.create(input.toJson());
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> delete(String id) async {
    try {
      await remote.delete(id);
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  Voucher _fromJson(Map<String, dynamic> j) {
    final rawLines = (j['journalEntryDetails'] as List?) ?? const [];
    return Voucher(
      id: (j['id'] ?? '').toString(),
      date: DateTime.tryParse('${j['date']}') ?? DateTime(1970),
      description: (j['description'] ?? '').toString(),
      // الاسم بالباك "totalDepit" (كذا، خطأ كتابي قديم بالموديل).
      totalDebit: ((j['totalDepit'] ?? 0) as num).toDouble(),
      totalCredit: ((j['totalCredit'] ?? 0) as num).toDouble(),
      hasOrigin: j['hasOrigin'] == true,
      lines: rawLines.whereType<Map<String, dynamic>>().map(_lineFromJson).toList(),
      originType: j['originType'] as String?,
      originId: j['originId'] as String?,
      originNumber: (j['originNumber'] as num?)?.toInt(),
    );
  }

  VoucherLine _lineFromJson(Map<String, dynamic> j) {
    final account = j['account'] as Map<String, dynamic>?;
    return VoucherLine(
      accountId: (j['accountId'] ?? '').toString(),
      accountName: (account?['name'] ?? '').toString(),
      accountCurrencyCode: account?['currencyCode'] as String?,
      debit: ((j['debit'] ?? 0) as num).toDouble(),
      credit: ((j['credit'] ?? 0) as num).toDouble(),
      notes: j['notes'] as String?,
    );
  }
}
