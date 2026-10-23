import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/stocks/data/stock_remote_data_source.dart';
import 'package:saydaliati/features/stocks/domain/stock_adjustment.dart';

part 'stock_providers.g.dart';

@riverpod
StockRemoteDataSource stockRemoteDataSource(Ref ref) =>
    StockRemoteDataSource(ref.watch(apiClientProvider));

/// تسوية جرد دفعة — مباشر بلا تخزين مؤقّت: رقم الجرد قرارٌ يُسجَّل فوراً لا
/// يُقرأ من كاش (نفس أسلوب `settleDebt`).
@riverpod
Future<AdjustStockResult> Function(AdjustStockInput) adjustStock(Ref ref) {
  return (input) async {
    final json =
        await ref.read(stockRemoteDataSourceProvider).adjust(input.toJson());
    return AdjustStockResult.fromJson(json);
  };
}
