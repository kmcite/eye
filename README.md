# Eye

Offline-first Flutter app for MCQ study and question authoring.

**ObjectBox** is the source of truth on device (users, categories, questions, auth session). **PocketBase** is optional: an outbox + background engine pushes/pulls `sync_events` when the server is reachable.

## Architecture

| Layer | Role |
|--------|------|
| `domain/models/` | ObjectBox entities (`Question`, `Category`, `AppUser`, sync metadata) |
| `domain/api/` | Repositories — read/write locally, enqueue sync on mutations; `sync_readiness.dart` gates PocketBase before sync |
| `domain/validation/` | Stateless input rules (e.g. auth forms) |
| `business/sync_notifier.dart` | `SyncNotifier` — 30s timer + manual sync |
| `domain/api/sync_repository.dart` | Outbox push, incremental pull, apply remote events |
| `utils/pocketbase_*` | URL, health check, admin auth store (Hive) |

Local writes always hit ObjectBox first. Sync failures do not block the UI; pending rows stay in `SyncOutboxEntry` until the next cycle.

## UI / UX

Material 3 + no-blur liquid glass (`lib/ui/`). See `lib/ui/eye_ui.dart` for the design system.

## Stack

- Flutter · kaisel signals · ObjectBox · Hive (PocketBase prefs) · PocketBase SDK

## Getting started

```bash
flutter pub get
dart run build_runner build   # when entity models change
flutter run
```

### Optional PocketBase sync

1. Run PocketBase (default `http://127.0.0.1:8090`; emulator `http://10.0.2.2:8090`).
2. **Settings → PocketBase** or home banner → **Cloud setup** (superuser email/password).
3. App provisions the `sync_events` collection and starts the sync engine on launch.
4. Tap the **status strip** under the app bar → **Sync management** / outbox.

## Roadmap

- Study vs exam modes, timers, post-quiz review, bookmarks
- Export/import backup (still ObjectBox-centric)
- Richer profile fields

---

**Eye** — learn · practice · sync
