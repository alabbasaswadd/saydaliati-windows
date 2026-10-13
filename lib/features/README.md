# Features

Feature-first, Clean Architecture. Each feature owns three layers with a strict
dependency direction:

```
presentation ─▶ domain ◀─ data
```

- **domain/** — pure Dart. Entities (Freezed allowed), repository *contracts*,
  and use cases. No Flutter, no Dio, no JSON.
- **data/** — DTOs (JSON lives here), mappers (DTO ⇄ entity), data sources
  (remote + an optional local cache seam), and the repository implementation.
  Depends on domain only.
- **presentation/** — pages, widgets, and Riverpod providers/notifiers. Depends
  on domain only. Bridges `Result` (returned by use cases) into Riverpod
  `AsyncValue` for the UI via `shared/widgets/async_value_widget.dart`.

Dependency injection is Riverpod. Give each feature a composition-root file
(e.g. `products/product_providers.dart`) — the only place that references
concrete data classes, exposing them as domain-typed providers.

## Building a new feature

Create the folders under `features/<name>/`:

```
<name>/
  <name>_providers.dart          # composition root (DI)
  data/
    datasources/                 # <name>_remote_data_source.dart
    dtos/                        # *_dto.dart (+ *_dto.g.dart from json_serializable)
    mappers/                     # dto ⇄ entity
    repositories/                # <name>_repository_impl.dart
  domain/
    entities/                    # *.dart (+ *.freezed.dart)
    repositories/                # <name>_repository.dart (contract)
    usecases/                    # one class per meaningful operation
  presentation/
    pages/
    providers/                   # notifiers (+ *.g.dart from riverpod_generator)
    widgets/
```

Reach for the shared building blocks instead of hand-rolling UI:
`AsyncValueWidget`, `AsyncListView` / `PagedListView`, `AppButton`, `AppCard`,
`AppTextField` & friends, `AppStrings`, `AppSpacing`, `context.semantic`.

## Offline-first

The `core/offline` layer is wired and running:
- `EntityCache<T>` — write-through local cache for catalog/reference data.
- `OutboxRepository` + `OfflineWriteGate` — queue writes while offline and return
  an optimistic result; transient failures re-queue, business errors surface.
- `SyncController` (`core/offline/sync/sync_service.dart`) — **drains the outbox
  automatically** at startup and whenever connectivity returns, and on demand via
  `pushNow()`. It's started in `app.dart` and needs no per-screen wiring.
- `outboxEndpointsProvider` (`core/offline/sync/outbox_handlers.dart`) — the
  registry the engine replays against. **A feature makes its writes syncable by
  adding its `kind → endpoint` here** (override the provider in the root scope).
- `pendingOperationsCountProvider` — reactive queue size (the Home app-bar badge).
- `isOnlineProvider` — reactive connectivity for `OnlineOnlyView`.

To make a feature offline-capable: enqueue writes through `OfflineWriteGate` with
a `kind`, register that `kind`'s endpoint in `outboxEndpointsProvider`, and cache
reads with `EntityCache<T>`. The engine handles replay, ordering, and retries.

## Barcode / QR scanning

`shared/widgets/scanner/barcode_scanner_page.dart` exposes `scanBarcode(context)`
→ returns the decoded string (or null). It beeps on a hit (`shared/audio/
scanner_beep.dart`) and needs camera permission (already declared for Android/iOS).
The Home screen's camera button uses it; point a real product lookup at the result.

## Current state

This is the **foundation** only: core infrastructure, the shared component
library, the app shell + router, and placeholder tab pages. No business feature
is implemented yet — each tab/section is a scaffold ready to be filled in.
