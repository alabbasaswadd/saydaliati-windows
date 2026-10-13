/// A still-queued (un-synced) sale, summarized for the POS "cloud" screen.
///
/// A plain view model decoded from the outbox row's request body — kept free of
/// the drift row type so it can cross the Riverpod provider boundary cleanly.
class PendingSale {
  const PendingSale({
    required this.id,
    required this.status,
    required this.total,
    required this.itemCount,
    required this.payload,
    this.lastError,
    this.date,
  });

  /// The outbox entry id (used to edit/delete the queued item).
  final String id;

  /// pending | syncing | failed.
  final String status;
  final String? lastError;

  final double total;
  final int itemCount;
  final DateTime? date;

  /// The original request body (CreateSaleInput.toJson) — used to prefill the POS
  /// when editing the queued invoice.
  final Map<String, dynamic> payload;

  bool get failed => status == 'failed';
}
