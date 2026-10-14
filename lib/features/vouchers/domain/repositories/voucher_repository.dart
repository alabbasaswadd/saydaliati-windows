import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/vouchers/domain/entities/voucher.dart';

/// السندات (قيود JournalEntry): اتصال مباشر دوماً، بلا outbox.
abstract interface class VoucherRepository {
  Future<Result<List<Voucher>>> getAll();

  Future<Result<bool>> create(CreateVoucherInput input);

  Future<Result<bool>> delete(String id);
}
