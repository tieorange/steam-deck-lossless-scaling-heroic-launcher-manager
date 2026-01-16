# Architecture Documentation

## Overview

Heroic LSFG Applier is a Flutter desktop application for Linux (targeting Steam Deck) that enables Lossless Scaling Frame Generation (LSFG-VK) for games from multiple launchers.

## Architecture Pattern

The app follows **Clean Architecture** principles with three layers:

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│           (Pages, Widgets, Cubits, States)              │
├─────────────────────────────────────────────────────────┤
│                      Domain Layer                        │
│         (Entities, Repositories, Use Cases)             │
├─────────────────────────────────────────────────────────┤
│                       Data Layer                         │
│       (Repository Implementations, Datasources)         │
└─────────────────────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/                     # Shared utilities
│   ├── constants.dart        # App-wide constants
│   ├── di/                   # Dependency injection
│   │   └── injection.dart    # GetIt configuration
│   ├── error/                # Error handling
│   │   └── failures.dart     # Failure types, Result typedef
│   ├── logging/              # Logging infrastructure
│   │   └── logger_service.dart
│   ├── platform/             # Platform abstractions
│   │   └── platform_service.dart
│   ├── router/               # Navigation
│   │   ├── app_router.dart   # GoRouter config
│   │   └── app_shell.dart    # Shell with bottom nav
│   ├── services/             # Core services
│   │   └── vdf_binary_service.dart  # Steam VDF parser
│   └── theme/                # UI theming
│       ├── app_theme.dart
│       └── steam_deck_constants.dart
│
└── features/                 # Feature modules
    ├── backup/               # Backup management
    ├── games/                # Game list & LSFG
    └── settings/             # User preferences
```

## Feature Structure

Each feature follows the same structure:

```
feature/
├── data/
│   ├── datasources/          # External data access
│   ├── models/               # Data models (JSON serializable)
│   └── repositories/         # Repository implementations
├── domain/
│   ├── entities/             # Business objects (freezed)
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # Business logic operations
└── presentation/
    ├── cubit/                # State management
    ├── pages/                # Full-screen views
    └── widgets/              # Reusable UI components
```

## Dependency Injection

Uses **get_it** for service location. Configured in `lib/core/di/injection.dart`.

```dart
// Access dependencies anywhere:
final repo = getIt<GameRepository>();
```

Registration order:
1. Core services (PlatformService, VdfBinaryService)
2. Datasources (OgiDatasource, LutrisDatasource)
3. Repositories (GameRepository, BackupRepository, SettingsRepository)
4. Use cases (ApplyLsfgUseCase, RemoveLsfgUseCase)

## State Management

Uses **flutter_bloc** with Cubits for each feature:

- `GamesCubit` - Game list, selection, filtering, LSFG operations
- `BackupCubit` - Backup creation, restoration, deletion
- `SettingsCubit` - User preferences (theme, auto-backup, etc.)

States are defined using **freezed** for immutability and pattern matching.

## Data Flow

### Loading Games

```
GamesPage.initState()
    ↓
GamesCubit.loadGames()
    ↓
GameRepository.getGames()
    ↓
┌─────────────────────────────────────────┐
│  Parallel data fetch from all sources:  │
│  - Heroic JSON configs                  │
│  - OGI JSON + Steam shortcuts.vdf       │
│  - Lutris YAML configs                  │
└─────────────────────────────────────────┘
    ↓
List<Game> returned
    ↓
emit(GamesState.loaded(...))
    ↓
UI rebuilds via BlocBuilder
```

### Applying LSFG

```
User selects games → GamesCubit.toggleGameSelection()
    ↓
User taps "Apply LSFG"
    ↓
GamesPage._showApplyConfirmation()
    ↓
GamesCubit.applyLsfgToSelected()
    ↓
ApplyLsfgUseCase.call()
    ├─→ Check auto-backup setting
    ├─→ Create backup if enabled
    └─→ GameRepository.applyLsfgToGames()
         ├─→ Heroic: Modify JSON configs
         ├─→ OGI: Modify Steam shortcuts.vdf
         └─→ Lutris: Modify YAML configs
    ↓
emit(GamesState.loading())
GamesCubit.loadGames() // Refresh
```

## Game Sources

### Heroic Games Launcher

- **Config Path:** `~/.config/heroic/GamesConfig/` or Flatpak path
- **Format:** JSON files with `environmentOptions` field
- **Modification:** Prepend `LSFG_PROCESS=decky-lsfg-vk` to `environmentOptions`

### OpenGameInstaller (OGI)

- **Library Path:** `~/.local/share/OpenGameInstaller/library/`
- **Steam Integration:** Games appear in Steam's `shortcuts.vdf`
- **Format:** Binary VDF (Valve Data Format)
- **Modification:** Add env var to `LaunchOptions` field

### Lutris

- **Config Path:** `~/.config/lutris/games/` or `~/.local/share/lutris/games/`
- **Format:** YAML files with `env.LSFG_PROCESS` field
- **Modification:** Add/remove `LSFG_PROCESS` in env section

## Error Handling

Uses **dartz** `Either` type for functional error handling:

```dart
typedef Result<T> = Either<Failure, T>;

// Usage:
Future<Result<List<Game>>> getGames() async {
  try {
    // ... success
    return Right(games);
  } catch (e) {
    return Left(FileSystemFailure('Failed: $e'));
  }
}

// Handling:
result.fold(
  (failure) => emit(GamesState.error(message: failure.message)),
  (games) => emit(GamesState.loaded(games: games)),
);
```

## Platform Support

### Development

- **macOS:** Uses mock repositories (or test data in `~/HeroicTest/`)
- **Linux:** Uses real file system paths

### Production

- **Target:** Steam Deck (Arch Linux with SteamOS)
- **Distribution:** Flatpak (planned), local install script

## Adding a New Game Source

1. Create datasource: `lib/features/games/data/datasources/new_datasource.dart`
2. Add source type to `GameType` enum in `game_entity.dart`
3. Add path getter to `PlatformService`
4. Register datasource in `injection.dart`
5. Integrate in `GameRepositoryImpl.getGames()`
6. Add tab in `games_page.dart`
7. Update `GamesEmptyState` help text

## UI Design Principles

### Steam Deck Optimization

- Minimum touch target: 48px
- Large fonts and icons
- High contrast colors
- Focus indicators for gamepad navigation
- Bottom action bar for easy thumb access

### Theme

Uses Material 3 with custom color schemes:
- Light theme: Blue/cyan palette
- Dark theme: Optimized for OLED screens

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Testing

For Steam Deck testing:
```bash
# On development machine
make setup-test  # Creates test data in ~/HeroicTest

# Verify OGI modifications
make verify-test
```

## Building

### Local Development
```bash
make run          # Run on macOS
flutter run -d linux  # Run on Linux
```

### Release Build
```bash
make build-linux  # Uses Docker for cross-compilation
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, DI setup |
| `lib/core/di/injection.dart` | Dependency configuration |
| `lib/core/services/vdf_binary_service.dart` | Steam VDF parsing |
| `lib/features/games/data/repositories/game_repository_impl.dart` | Multi-source game loading |
| `lib/features/games/data/datasources/ogi_datasource.dart` | OGI + Steam shortcuts |
| `lib/features/games/domain/usecases/apply_lsfg_usecase.dart` | LSFG application logic |
