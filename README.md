# صيدليتي (saydaliati)

تطبيق فلاتر لإدارة صيدلية (نقطة بيع ومخزون). هذا المستودع يحتوي حالياً على
**البنية الأساسية القابلة لإعادة الاستخدام** فقط — جاهزة لبناء مزايا الأعمال فوقها.

A Flutter app for pharmacy management (POS + inventory). This repo currently
ships the **reusable foundation** only, ready to build business features on top.

## البنية / Architecture

Feature-first Clean Architecture with a strict dependency direction
(`presentation → domain ← data`).

- **Riverpod** (with code generation) — state management + dependency injection.
- **Freezed** — immutable entities and sealed unions (`Failure`, `SessionState`).
- **go_router** — declarative navigation with a `StatefulShellRoute` bottom-nav shell.
- **Dio** — networking, behind an `ApiClient` abstraction with envelope unwrapping
  and a status-code → `Failure` error contract.
- **drift** — offline cache + write-queue (outbox) primitives.
- **Arabic-first / RTL** — locale `ar`, Cairo variable font.

```
lib/
  app/        app widget, bootstrap (ProviderScope), router, bottom-nav shell
  core/       theme · constants · config · network · errors · result · usecase
              session · storage · observers · offline (cache/outbox/connectivity) · utils
  shared/     reusable widget library (buttons, cards, inputs, forms, states,
              dialogs, feedback, async/list views) + models + utils
  features/   feature-first modules (home / products / sales / more scaffolds)
```

## الألوان / Theme

A clean pharmacy palette — emerald-green primary (`#0FA06A`) with a medical-blue
accent — defined in `core/theme/app_colors.dart` and assembled into a Material 3
theme in `core/theme/app_theme.dart`. Widgets read styling from
`Theme.of(context)` / `context.semantic`, never hard-coded colors.

## التشغيل / Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generate *.g.dart / *.freezed.dart
flutter run
```

Point the app at your backend with:

```bash
flutter run --dart-define=API_BASE_URL=https://your-host
```

See `lib/features/README.md` for how to add a feature.
