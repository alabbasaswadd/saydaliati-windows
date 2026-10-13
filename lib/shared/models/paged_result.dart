/// A page of items plus the paging metadata the API returns.
///
/// Matches a common wrapper shape for paged endpoints:
/// `{ "items": [...], "totalCount": N, "limit": L, "offset": O }`.
/// (List endpoints that return a bare array don't use this wrapper.)
class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  final List<T> items;
  final int totalCount;
  final int limit;
  final int offset;

  /// Whether more rows exist beyond this page.
  bool get hasMore => offset + items.length < totalCount;

  /// Offset to request the next page.
  int get nextOffset => offset + limit;

  /// Parses the wrapper. [itemFromJson] maps each raw item map.
  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> item) itemFromJson,
  ) {
    final rawItems = (json['items'] as List?) ?? const [];
    return PagedResult<T>(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(itemFromJson)
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt() ?? rawItems.length,
      limit: (json['limit'] as num?)?.toInt() ?? rawItems.length,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }

  PagedResult<R> map<R>(R Function(T item) transform) => PagedResult<R>(
        items: items.map(transform).toList(),
        totalCount: totalCount,
        limit: limit,
        offset: offset,
      );
}
