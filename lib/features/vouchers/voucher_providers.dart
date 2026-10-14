import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/vouchers/data/datasources/voucher_remote_data_source.dart';
import 'package:saydaliati/features/vouchers/data/repositories/voucher_repository_impl.dart';
import 'package:saydaliati/features/vouchers/domain/entities/voucher.dart';
import 'package:saydaliati/features/vouchers/domain/repositories/voucher_repository.dart';

part 'voucher_providers.g.dart';

@riverpod
VoucherRemoteDataSource voucherRemoteDataSource(Ref ref) =>
    VoucherRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
VoucherRepository voucherRepository(Ref ref) =>
    VoucherRepositoryImpl(ref.watch(voucherRemoteDataSourceProvider));

@riverpod
Future<List<Voucher>> vouchersList(Ref ref) async {
  final result = await ref.watch(voucherRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}
