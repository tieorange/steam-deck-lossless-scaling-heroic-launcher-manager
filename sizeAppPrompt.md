# Game Size Manager - AI IDE Prompt

## Project Overview

Build a **Flutter desktop application** for **Steam Deck (Linux)** that displays games from multiple launchers sorted by disk size, allowing users to easily identify and uninstall the largest games to free up storage space.

**Problem**: Heroic Games Launcher, Lutris, and similar game managers don't offer a "sort by size" feature, making it hard to manage storage on the limited Steam Deck SSD.

**Solution**: A unified disk usage manager that reads game data from all configured launchers, calculates installation sizes, and provides one-click uninstall functionality.

---

## Tech Stack & Architecture

Use the **exact same architecture** as the reference project `heroic_lsfg_applier`:

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6        # State management (Cubits)
  dartz: ^0.10.1              # Functional error handling (Either)
  freezed_annotation: ^2.4.4  # Immutable state classes
  json_annotation: ^4.9.0     # JSON serialization
  go_router: ^14.6.2          # Navigation
  path_provider: ^2.1.5       # File paths
  path: ^1.9.0
  get_it: ^7.6.7              # Dependency injection
  shared_preferences: ^2.5.4  # User settings
  yaml: ^3.1.3                # Lutris config parsing

dev_dependencies:
  flutter_lints: ^5.0.0
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
```

### Clean Architecture Structure
```
lib/
├── main.dart
├── core/
│   ├── constants.dart
│   ├── di/injection.dart           # GetIt DI configuration
│   ├── error/failures.dart         # Result<T> = Either<Failure, T>
│   ├── logging/logger_service.dart
│   ├── platform/platform_service.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── app_shell.dart          # Bottom navigation shell
│   └── theme/
│       ├── app_theme.dart
│       └── steam_deck_constants.dart
│
└── features/
    ├── games/
    │   ├── data/
    │   │   ├── datasources/        # Per-launcher data access
    │   │   │   ├── heroic_datasource.dart
    │   │   │   ├── lutris_datasource.dart
    │   │   │   └── steam_datasource.dart
    │   │   ├── models/
    │   │   └── repositories/
    │   │       ├── game_repository_impl.dart
    │   │       └── mock_game_repository.dart
    │   ├── domain/
    │   │   ├── entities/game_entity.dart    # freezed
    │   │   ├── repositories/game_repository.dart
    │   │   └── usecases/
    │   │       ├── get_games_sorted_by_size_usecase.dart
    │   │       └── uninstall_game_usecase.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── games_cubit.dart
    │       │   └── games_state.dart         # freezed
    │       ├── pages/games_page.dart
    │       └── widgets/
    │           ├── game_list_item.dart
    │           └── size_breakdown_chart.dart
    │
    └── settings/
        ├── data/repositories/settings_repository_impl.dart
        ├── domain/
        │   ├── entities/settings_entity.dart
        │   └── repositories/settings_repository.dart
        └── presentation/
            ├── cubit/settings_cubit.dart
            └── pages/settings_page.dart
```

---

## Game Entity

```dart
@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required String title,
    required GameSource source,
    required String installPath,
    required int sizeBytes,          // KEY FIELD
    String? iconPath,
    @Default(false) bool isSelected,
  }) = _Game;
}

enum GameSource {
  heroic,
  lutris,
  steam,
  // Add more as needed
}
```

---

## Data Sources - Where to Read Game Data

### 1. Heroic Games Launcher (Epic + GOG)

**Config Locations (Linux/Steam Deck):**
- Standard: `~/.config/heroic/`
- Flatpak: `~/.var/app/com.heroicgameslauncher.hgl/config/heroic/`

**Key Files:**
| File | Purpose |
|------|---------|
| `GamesConfig/*.json` | Per-game settings, contains `install.install_path` |
| `store_cache/gog_library.json` | GOG game metadata |
| `legendaryConfig/legendary/installed.json` | Epic games install info |

**How to get install path:**
1. Read `legendaryConfig/legendary/installed.json`
2. Each game has `install_path` field
3. Calculate directory size with `du -sb` or Dart's recursive file listing

### 2. Lutris

**Config Locations:**
- Games DB: `~/.local/share/lutris/pga.db` (SQLite)
- Game configs: `~/.config/lutris/games/*.yml`

**From SQLite (`pga.db`):**
```sql
SELECT name, slug, directory FROM games WHERE installed = 1;
```

The `directory` column contains the install path. Calculate its size.

**From YAML files:**
Each `.yml` file has a `game.prefix` or `game.exe` field that points to the installation.

### 3. Steam (Native)

**Config Locations:**
- Library folders: `~/.steam/steam/steamapps/libraryfolders.vdf`
- App manifests: `~/.steam/steam/steamapps/appmanifest_*.acf`

**From `appmanifest_*.acf`:**
```
"AppState"
{
    "appid" "123456"
    "name" "Game Name"
    "installdir" "GameFolder"
    "SizeOnDisk" "12345678900"   // Already has size!
}
```

---

## Core Features

### 1. Game List with Sorting
- Display all games from all sources in a unified list
- **Sort by size (descending)** by default
- Show: Title, Source icon, Size (human-readable), Install path
- Tab filters: All | Heroic | Lutris | Steam

### 2. Size Calculation
```dart
Future<int> calculateDirectorySize(String path) async {
  final dir = Directory(path);
  if (!dir.existsSync()) return 0;
  
  int totalSize = 0;
  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      totalSize += await entity.length();
    }
  }
  return totalSize;
}
```

### 3. Uninstall Games

| Source | Uninstall Method |
|--------|------------------|
| **Heroic** | Run `heroic --uninstall <appName>` or delete install folder + remove from `installed.json` |
| **Lutris** | Run `lutris -r <slug>` to remove or delete directory + update `pga.db` |
| **Steam** | Use `steam steam://uninstall/<appid>` protocol |

### 4. Visual Features
- Size breakdown pie/bar chart by launcher
- Total disk usage summary at the top
- Progress indicator during size calculation (can be slow for large libraries)
- Pull-to-refresh

---

## Platform Service

```dart
abstract class PlatformService {
  // Heroic paths
  String get heroicConfigPath;
  String get heroicFlatpakConfigPath;
  String get legendaryInstalledJsonPath;
  
  // Lutris paths  
  String get lutrisDbPath;      // ~/.local/share/lutris/pga.db
  String get lutrisConfigPath;  // ~/.config/lutris/games/
  
  // Steam paths
  String get steamAppsPath;     // ~/.steam/steam/steamapps/
  
  // Check which launchers are installed
  bool get isHeroicInstalled;
  bool get isLutrisInstalled;
  bool get isSteamInstalled;
}
```

---

## Development Strategy

### macOS Development with Mock Data
Since development happens on macOS but target is Linux/Steam Deck:

```dart
bool _shouldUseMockRepository() {
  if (!Platform.isMacOS) return false;
  
  // Use mocks unless test directory exists
  final testDir = Directory('${Platform.environment['HOME']}/GameSizeTest');
  return !testDir.existsSync();
}
```

Create `~/GameSizeTest/` with sample game folder structure for local testing.

### Mock Repository
```dart
class MockGameRepository implements GameRepository {
  @override
  Future<Result<List<Game>>> getGames() async {
    return Right([
      Game(id: '1', title: 'Cyberpunk 2077', source: GameSource.heroic, 
           installPath: '/fake/path', sizeBytes: 75 * 1024 * 1024 * 1024), // 75GB
      Game(id: '2', title: 'Witcher 3', source: GameSource.steam,
           installPath: '/fake/path', sizeBytes: 50 * 1024 * 1024 * 1024), // 50GB
      // ... more mock games
    ]);
  }
}
```

---

## UI Design Requirements

### Steam Deck Optimization
- **Minimum touch target:** 48px height
- **Large fonts:** 16px minimum for body text
- **High contrast:** Ensure readability on Steam Deck's screen
- **Bottom action bar:** Easy thumb access for delete/refresh actions
- **Gamepad navigation support:** Focus indicators, D-pad navigation

### Key UI Components

1. **Header:** Total disk usage summary (e.g., "Games: 245 GB / 512 GB")
2. **Game List:** Scrollable list sorted by size
3. **Game Item:** 
   - Large touch target (64px height minimum)
   - Game icon (48x48)
   - Title + Source badge
   - Size (bold, right-aligned)
   - Selection checkbox
4. **Action Bar:** 
   - "Uninstall Selected" button
   - "Refresh Sizes" button
   - Sort options dropdown

---

## Error Handling

Use `Either<Failure, T>` pattern:

```dart
typedef Result<T> = Either<Failure, T>;

abstract class Failure {
  String get message;
}

class FileSystemFailure extends Failure { ... }
class LauncherNotFoundFailure extends Failure { ... }
class UninstallFailure extends Failure { ... }
```

---

## Building & Deployment

```makefile
# Development
run:
	flutter run -d macos

# Cross-compile for Steam Deck (Linux)
build-linux:
	docker run --rm -v $(PWD):/app aspect/flutter-linux flutter build linux --release

# Deploy to Steam Deck
deploy:
	scp -r build/linux/x64/release/bundle/* deck@steamdeck:~/Applications/GameSizeManager/
```

---

## Summary

Build a Flutter app that:
1. Reads game data from Heroic, Lutris, and Steam config files
2. Calculates actual disk usage of each game installation
3. Displays games sorted by size in a Steam Deck-optimized UI
4. Allows selecting and uninstalling multiple games at once
5. Uses Clean Architecture with BLoC/Cubit state management
6. Supports mock data for macOS development, real data on Linux

The goal is to solve the missing "sort by size" feature that all these launchers lack.
