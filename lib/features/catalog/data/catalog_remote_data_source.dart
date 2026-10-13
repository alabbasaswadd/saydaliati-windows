import 'dart:convert';

import 'package:flutter/foundation.dart' show compute;
import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/features/catalog/data/catalog_item_dto.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';

/// Top-level (isolate-safe) parser for the bulk catalog response. Runs inside
/// `compute`, so decoding the ~22.5k-item JSON happens OFF the UI isolate.
/// Accepts either the raw `ApiResult` envelope or a bare list.
List<Map<String, dynamic>> parseCatalogList(String body) {
  if (body.isEmpty) return const [];
  final decoded = jsonDecode(body);
  final data = decoded is Map<String, dynamic> ? decoded['data'] : decoded;
  final list = (data as List?) ?? const [];
  return list.whereType<Map<String, dynamic>>().toList();
}

/// Reads the global medicine catalog from the backend (`/pharmacy-api/MedicineCatalog`).
/// Read-only: search, group-by-company, lookup-by-barcode, detail, alternatives.
class CatalogRemoteDataSource {
  const CatalogRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<CatalogItem>> search({
    String? name,
    String? manufacturer,
    int limit = 50,
    int offset = 0,
  }) async {
    final data = await _api.get(ApiEndpoints.catalog, queryParameters: {
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (manufacturer != null && manufacturer.isNotEmpty) 'manufacturer': manufacturer,
      'limit': limit,
      'offset': offset,
    });
    return _list(data);
  }

  /// The WHOLE catalog in one request (for the offline mirror), decoded OFF the
  /// UI isolate via `compute`. Replaces the old 20+ sequential offset pages and
  /// the server-side OFFSET slowdown — one query, one parse on a background
  /// isolate.
  Future<List<Map<String, dynamic>>> fetchAllRaw() async {
    final body = await _api.getRaw(ApiEndpoints.catalogAll);
    if (body.isEmpty) return const [];
    return compute(parseCatalogList, body);
  }

  /// A raw page of catalog items (undecoded maps) for the offline mirror. Pages
  /// by offset (stable order) so a full pull can't stall on equal timestamps.
  Future<List<Map<String, dynamic>>> pageRaw({required int limit, required int offset}) async {
    final data = await _api.get(ApiEndpoints.catalog,
        queryParameters: {'limit': limit, 'offset': offset});
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<CatalogItem?> byId(String id) async {
    final data = await _api.get(ApiEndpoints.catalogById(id));
    return data is Map<String, dynamic> ? CatalogItemDto.fromJson(data) : null;
  }

  Future<CatalogItem?> byBarcode(String barcode) async {
    final data = await _api.get(ApiEndpoints.catalogByBarcode(barcode));
    return data is Map<String, dynamic> ? CatalogItemDto.fromJson(data) : null;
  }

  Future<List<CatalogItem>> alternatives(String id) async {
    final data = await _api.get(ApiEndpoints.catalogAlternatives(id));
    return _list(data);
  }

  Future<List<CatalogManufacturer>> manufacturers() async {
    final data = await _api.get(ApiEndpoints.catalogManufacturers);
    final list = (data as List?) ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(CatalogItemDto.manufacturerFromJson)
        .toList();
  }

  /// Copies a catalog item into the pharmacy's own stock: creates (or reuses,
  /// no duplication) a pharmacy medicine from the catalog fields + an initial
  /// stock batch. Returns the created/updated medicine id.
  Future<String> addToStock({
    required String catalogId,
    required double quantity,
    required double purchasePrice,
    required double salePrice,
    required DateTime expiryDate,
    String? barcode,
    String? supplierId,
  }) async {
    final data = await _api.post(ApiEndpoints.medicineFromCatalog, data: {
      'catalogId': catalogId,
      'quantity': quantity,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'expiryDate': expiryDate.toUtc().toIso8601String(),
      if (barcode != null && barcode.trim().isNotEmpty) 'barcode': barcode.trim(),
      if (supplierId != null && supplierId.isNotEmpty) 'supplierId': supplierId,
    });
    final map = (data as Map?)?.cast<String, dynamic>() ?? const {};
    return (map['medicineId'] ?? '').toString();
  }

  List<CatalogItem> _list(Object? data) {
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().map(CatalogItemDto.fromJson).toList();
  }
}
