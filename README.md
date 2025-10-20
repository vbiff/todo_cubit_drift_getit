# todo_cubit

A simple Todo app built with Flutter using:
- Cubit (flutter_bloc) for state management
- Clean Architecture layering (domain/data/presentation)
- GetIt for dependency injection
- Drift (SQLite) for local persistence

## Requirements
- Flutter SDK (3.x)
- Dart SDK (compatible with your Flutter version)

## Project Structure
```
lib/
  core/                # service locator (GetIt)
  data/
    datasources/
      local/
        app_database.dart         # Drift DB setup
        tables/                   # Drift tables
        extensions/               # Drift<->Entity converters
    repository/                   # Repository implementations
  domain/
    entity/                       # Business entities
    repository/                   # Repository interfaces
  presentation/
    home-screen/                  # List screen (TodosCubit)
    to-do-screen/                 # Detail screen (TodoCubit)
  main.dart
```

## Getting Started
1) Install dependencies
```bash
flutter pub get
```

2) Generate Drift code (run after changing tables or DB)
```bash
dart run build_runner build --delete-conflicting-outputs
```

3) Run the app
```bash
flutter run
```

## State Management
- `TodosCubit` manages the list on the Home screen (load/create/delete and optional stream updates).
- `TodoCubit` manages a single todo on the Detail screen (load/update/delete).
- UI listens via `BlocBuilder` and reacts to state changes.

## Dependency Injection (GetIt)
- `core/service_locator.dart` registers:
  - `AppDatabase` as a lazy singleton
  - `TodoRepository` implementation as a lazy singleton
  - Cubits as factories

Initialize in `main()`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}
```

Use in widgets via `BlocProvider(create: (_) => sl<TodosCubit>())`, or `sl<TodoCubit>()` for detail.

## Persistence (Drift + SQLite)
- DB file lives in the app documents directory (via `path_provider`).
- Define tables in `data/datasources/local/tables/`.
- Map generated Drift data objects to domain entities using extensions in `extensions/`.

Common CRUD patterns:
```dart
// SELECT single
final q = db.select(db.todoTable)..where((t) => t.id.equals(id));
final row = await q.getSingle();

// INSERT
await db.into(db.todoTable).insert(todo.toDrift());

// UPDATE (write)
await (db.update(db.todoTable)
  ..where((t) => t.id.equals(todo.id)))
  .write(todo.toDrift());

// DELETE (go)
await (db.delete(db.todoTable)
  ..where((t) => t.id.equals(id)))
  .go();
```

## Editing Flow (Detail -> Home refresh)
- Fast path: return a boolean and refresh list on Home
```dart
// Detail
Navigator.of(context).pop(true);

// Home
final changed = await Navigator.push(...);
if (changed == true) context.read<TodosCubit>().getAllTodos();
```

- Reactive path: expose `watchTodos()` stream in repository and subscribe in `TodosCubit` to auto-update the list.

## Troubleshooting
- `MissingPluginException(getApplicationDocumentsDirectory)`: Ensure `WidgetsFlutterBinding.ensureInitialized();` in `main()`, then `flutter clean && flutter pub get && flutter run`.
- `Could not resolve annotation @DriftDatabase`: Ensure proper imports in `app_database.dart`:
  `package:drift/drift.dart`, `package:drift/native.dart`, `package:path_provider/path_provider.dart`.
- `where returns void` errors: Use cascade with `.go()` for delete/update, and `.write(...)` for update writes.
- After changing tables, re-run codegen: `dart run build_runner build --delete-conflicting-outputs`.

## Notes
- IDs use UUID v4 as String (generated in Cubit when creating todos).
- Keep entities DB-agnostic; handle conversions in `extensions/`.

## Scripts (optional)
You may find these handy:
```bash
# one-off codegen
dart run build_runner build --delete-conflicting-outputs
# watch mode
dart run build_runner watch --delete-conflicting-outputs
```

---
Happy hacking!
