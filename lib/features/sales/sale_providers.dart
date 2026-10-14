import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/sales/data/datasources/batch_remote_data_source.dart';
import 'package:saydaliati/features/sales/data/datasources/sale_remote_data_source.dart';
import 'package:saydaliati/features/sales/data/datasources/sale_return_remote_data_source.dart';
import 'package:saydaliati/features/sales/data/repositories/batch_repository_impl.dart';
import 'package:saydaliati/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:saydaliati/features/sales/data/repositories/sale_return_repository_impl.dart';
import 'package:saydaliati/features/sales/domain/entities/pending_sale.dart';
import 'package:saydaliati/features/sales/domain/entities/sale_return.dart';
import 'package:saydaliati/features/sales/domain/repositories/sale_repository.dart';
import 'package:saydaliati/features/sales/domain/repositories/sale_return_repository.dart';
import 'package:saydaliati/features/stock/stock_providers.dart';

part 'sale_providers.g.dart';

/// Composition root for the sales feature. The repository is wired with the
/// outbox + connectivity so `createSale` is offline-capable (queues + decrements
/// the local stock cache offline).

@riverpod
SaleRemoteDataSource saleRemoteDataSource(Ref ref) =>
    SaleRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
BatchRemoteDataSource batchRemoteDataSource(Ref ref) =>
    BatchRemoteDataSource(ref.watch(apiClientProvider));

/// Offline-aware batch loader for the POS: online fetch + write-through to the
/// stock cache; offline reads the cached batches.
@riverpod
BatchRepository batchRepository(Ref ref) => BatchRepository(
      remote: ref.watch(batchRemoteDataSourceProvider),
      stockLocal: ref.watch(stockLocalDataSourceProvider),
      isOnline: () => ref.read(effectiveOnlineProvider),
    );

@riverpod
SaleRepository saleRepository(Ref ref) => SaleRepositoryImpl(
      remote: ref.watch(saleRemoteDataSourceProvider),
      outbox: ref.watch(outboxRepositoryProvider),
      stockLocal: ref.watch(stockLocalDataSourceProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
      isOnline: () => ref.read(effectiveOnlineProvider),
    );

@riverpod
SaleReturnRemoteDataSource saleReturnRemoteDataSource(Ref ref) =>
    SaleReturnRemoteDataSource(ref.watch(apiClientProvider));

/// Sale returns — online-only (see SaleReturnRepository doc).
@riverpod
SaleReturnRepository saleReturnRepository(Ref ref) =>
    SaleReturnRepositoryImpl(ref.watch(saleReturnRemoteDataSourceProvider));

@riverpod
Future<List<SaleReturnableLine>> saleReturnableLines(Ref ref, String saleId) async {
  final result = await ref.watch(saleReturnRepositoryProvider).getReturnableLines(saleId);
  return result.fold((lines) => lines, (failure) => throw failure);
}

/// Saved sale return documents — drives the «مرتجع مبيعات» sidebar section.
@riverpod
Future<List<SaleReturnSummary>> saleReturnsList(Ref ref) async {
  final result = await ref.watch(saleReturnRepositoryProvider).getReturns();
  return result.fold((list) => list, (failure) => throw failure);
}

/// The still-queued (un-synced) sales for the current tenant — reactive, oldest
/// first — driving the POS "unsynced invoices" (cloud) screen.
@riverpod
Stream<List<PendingSale>> pendingSales(Ref ref) {
  final tenantId = ref.watch(currentTenantKeyProvider);
  final outbox = ref.watch(outboxRepositoryProvider);
  return outbox.watch(tenantId).map((rows) => rows
      .where((r) => r.kind == kSaleOutboxKind)
      .map((r) {
        final payload = jsonDecode(r.payloadJson) as Map<String, dynamic>;
        return PendingSale(
          id: r.id,
          status: r.status,
          lastError: r.lastError,
          total: ((payload['totalAmount'] ?? 0) as num).toDouble(),
          itemCount: (payload['items'] as List?)?.length ?? 0,
          date: DateTime.tryParse('${payload['saleDate'] ?? ''}'),
          payload: payload,
        );
      })
      .toList());
}
