import 'package:saydaliati/core/errors/exceptions.dart';
import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/offline/outbox/outbox_repository.dart';
import 'package:saydaliati/core/result/result.dart';

/// True for errors worth retrying later (offline / transient): no connectivity,
/// a timeout, or a reached-but-failing server (5xx). Business and validation
/// errors are NOT transient — the user must fix the data, so they surface as a
/// [Failure] instead of being queued.
bool isTransientError(Object error) =>
    error is NetworkException ||
    error is TimeoutException ||
    error is ServerException;

/// Wraps a write so it works offline-first: when online it performs the request
/// and, only on a transient failure, falls back to the outbox; when offline it
/// enqueues immediately and returns an optimistic entity. Non-transient errors
/// are returned as a [Failure] and never queued.
class OfflineWriteGate {
  const OfflineWriteGate({
    required this.outbox,
    required this.tenantId,
    required this.isOnline,
  });

  final OutboxRepository outbox;
  final String tenantId;
  final bool Function() isOnline;

  Future<Result<T>> run<T>({
    required String id,
    required String kind,
    required Map<String, dynamic> payload,
    required Future<T> Function() online,
    required T optimistic,
    String? dependsOn,
    Future<void> Function()? onQueued,
  }) async {
    if (isOnline()) {
      try {
        return Result.success(await online());
      } catch (error) {
        if (!isTransientError(error)) {
          return Result.failure(mapExceptionToFailure(error));
        }
        // Reached here online but the network dropped mid-flight → queue it.
      }
    }
    await outbox.enqueue(
      id: id,
      tenantId: tenantId,
      kind: kind,
      payload: payload,
      dependsOn: dependsOn,
    );
    // The write was queued (offline, or a mid-flight drop): let the caller apply
    // its optimistic local side effects (e.g. decrement cached stock).
    if (onQueued != null) await onQueued();
    return Result.success(optimistic);
  }
}
