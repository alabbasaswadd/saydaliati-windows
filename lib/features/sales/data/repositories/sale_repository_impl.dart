import 'dart:convert';

import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/offline/outbox/offline_write_gate.dart';
import 'package:saydaliati/core/offline/outbox/outbox_repository.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:saydaliati/features/sales/data/dtos/sale_dto.dart';
import 'package:saydaliati/features/sales/data/mappers/sale_mapper.dart';
import 'package:saydaliati/features/sales/domain/entities/create_sale_input.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/domain/repositories/sale_repository.dart';
import 'package:saydaliati/features/stock/data/datasources/stock_local_data_source.dart';
import 'package:uuid/uuid.dart';

/// Outbox kind used to replay a queued sale (registered in `outboxEndpoints`).
const String kSaleOutboxKind = 'createSale';

class SaleRepositoryImpl implements SaleRepository {
  const SaleRepositoryImpl({
    required this.remote,
    required this.outbox,
    required this.stockLocal,
    required this.tenantId,
    required this.isOnline,
  });

  final SaleRemoteDataSource remote;
  final OutboxRepository outbox;
  final StockLocalDataSource stockLocal;
  final String tenantId;
  final bool Function() isOnline;
  static const _uuid = Uuid();

  @override
  Future<Result<bool>> createSale(CreateSaleInput input) {
    // نفس المعرّف يُستخدم لصفّ الطابور وللبيعة ذاتها (`clientRequestId`
    // بالحمولة) — الخادم يكتشف به إعادة إرسال نفس الطلب (مهلة شبكة وصلت
    // فعلاً، أو مزامنة تعطّلت بعد نجاحها) فيُعيد البيعة الموجودة بدل تكرارها.
    final id = _uuid.v4();
    final payload = {...input.toJson(), 'clientRequestId': id};
    final gate = OfflineWriteGate(
      outbox: outbox,
      tenantId: tenantId,
      isOnline: isOnline,
    );
    return gate.run<bool>(
      id: id,
      kind: kSaleOutboxKind,
      payload: payload,
      online: () async {
        await remote.create(payload);
        return true;
      },
      optimistic: true,
      // Queued offline → decrement the cached on-hand quantities optimistically
      // so the POS reflects the sale until the real push re-pulls from server.
      onQueued: () async {
        for (final line in input.lines) {
          if (line.stockId != null && line.stockId!.isNotEmpty) {
            await stockLocal.decrement(line.stockId!, line.quantity);
          } else {
            await stockLocal.decrementFefo(line.medicineId, line.quantity);
          }
        }
      },
    );
  }

  @override
  Future<Result<List<Sale>>> getSales({
    int? limit,
    int? offset,
    String? fromIso,
    String? toIso,
    String? customerId,
    String? medicineId,
    String? currencyId,
    bool? isPrescription,
  }) async {
    try {
      final raw = await remote.list(
        limit: limit,
        offset: offset,
        fromIso: fromIso,
        toIso: toIso,
        customerId: customerId,
        medicineId: medicineId,
        currencyId: currencyId,
        isPrescription: isPrescription,
      );
      return Result.success(
          raw.map((m) => SaleDto.fromJson(m).toEntity()).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<Sale>> getSale(String id) async {
    try {
      final raw = await remote.getById(id);
      return Result.success(SaleDto.fromJson(raw).toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> updateSale(String id, CreateSaleInput input) async {
    try {
      final body = <String, dynamic>{
        'id': id,
        'customerId': input.customerId,
        'currencyId': input.currencyId,
        'userId': null,
        'saleDate': input.saleDate.toIso8601String(),
        'totalAmount': input.totalAmount,
        'paymentMethod': input.paymentMethod.wire,
        'paymentAccountId': input.paymentAccountId,
        'saleItems': input.lines
            .map((l) => l.toJson(input.currencyId, input.warehouseId))
            .toList(),
      };
      await remote.update(id, body);
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> deleteSale(String id) async {
    try {
      await remote.delete(id);
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> deleteQueuedSale(String outboxId) async {
    try {
      final row = await outbox.find(outboxId);
      if (row != null) {
        await _restoreStock(
            jsonDecode(row.payloadJson) as Map<String, dynamic>);
        await outbox.remove(outboxId);
      }
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> updateQueuedSale(
      String outboxId, CreateSaleInput input) async {
    try {
      final row = await outbox.find(outboxId);
      if (row != null) {
        // Reverse the old deduction, then apply the new one, so the cached
        // quantities net out to the edited invoice.
        await _restoreStock(jsonDecode(row.payloadJson) as Map<String, dynamic>);
      }
      for (final line in input.lines) {
        if (line.stockId != null && line.stockId!.isNotEmpty) {
          await stockLocal.decrement(line.stockId!, line.quantity);
        } else {
          await stockLocal.decrementFefo(line.medicineId, line.quantity);
        }
      }
      await outbox.updatePayload(outboxId, input.toJson());
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  /// Adds the quantities of a queued sale's lines back to the local stock cache.
  Future<void> _restoreStock(Map<String, dynamic> payload) async {
    final items = (payload['items'] as List?) ?? const [];
    for (final raw in items) {
      if (raw is! Map) continue;
      final qty = ((raw['quantity'] ?? 0) as num).toDouble();
      if (qty <= 0) continue;
      final stockId = (raw['stockId'] ?? '').toString();
      final medicineId = (raw['medicineId'] ?? '').toString();
      final restored =
          stockId.isNotEmpty && await stockLocal.increment(stockId, qty);
      if (!restored && medicineId.isNotEmpty) {
        await stockLocal.incrementForMedicine(medicineId, qty);
      }
    }
  }
}
