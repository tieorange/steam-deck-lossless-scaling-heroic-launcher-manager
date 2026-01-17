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
│   ├── constants.dart              # App-wide constants, size thresholds
│   ├── di/injection.dart           # GetIt DI configuration
│   ├── error/failures.dart         # Result<T> = Either<Failure, T>
│   ├── extensions/
│   │   └── size_formatter.dart     # int.toHumanReadableSize() extension
│   ├── logging/logger_service.dart
│   ├── platform/platform_service.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── app_shell.dart          # Bottom navigation shell
│   ├── services/
│   │   └── disk_size_service.dart  # Directory size calculation
│   └── theme/
│       ├── app_theme.dart
│       └── steam_deck_constants.dart
│
└── features/
    │
    ├── dashboard/                  # Overview & quick stats
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── dashboard_cubit.dart
    │       │   └── dashboard_state.dart
    │       ├── pages/dashboard_page.dart
    │       └── widgets/
    │           ├── storage_overview_card.dart   # Total used / free
    │           ├── launcher_breakdown_chart.dart # Pie chart by source
    │           └── top_games_list.dart          # Top 5 largest games
    │
    ├── games/                      # Full game list & uninstall
    │   ├── data/
    │   │   ├── datasources/        # Per-launcher data reading
    │   │   │   ├── heroic_datasource.dart
    │   │   │   ├── ogi_datasource.dart
    │   │   │   ├── lutris_datasource.dart
    │   │   │   └── steam_datasource.dart
    │   │   ├── models/
    │   │   │   └── game_model.dart
    │   │   └── repositories/
    │   │       ├── game_repository_impl.dart
    │   │       └── mock_game_repository.dart
    │   ├── domain/
    │   │   ├── entities/game_entity.dart
    │   │   ├── repositories/game_repository.dart
    │   │   └── usecases/
    │   │       ├── get_all_games_usecase.dart
    │   │       ├── calculate_game_size_usecase.dart
    │   │       └── uninstall_game_usecase.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── games_cubit.dart
    │       │   └── games_state.dart
    │       ├── pages/games_page.dart
    │       └── widgets/
    │           ├── game_list_item.dart
    │           ├── game_list_header.dart        # Sort controls
    │           ├── source_filter_chips.dart     # Heroic|Lutris|Steam tabs
    │           └── uninstall_confirm_dialog.dart
    │
    ├── storage/                    # Storage analytics & cleanup
    │   ├── data/
    │   │   └── repositories/
    │   │       └── storage_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/storage_info.dart       # Drive stats
    │   │   └── repositories/storage_repository.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── storage_cubit.dart
    │       │   └── storage_state.dart
    │       ├── pages/storage_page.dart
    │       └── widgets/
    │           ├── disk_usage_bar.dart          # Visual bar
    │           ├── folder_size_tree.dart        # Expandable tree view
    │           └── cleanup_suggestions.dart     # Cache, logs, etc.
    │
    └── settings/
        ├── data/repositories/settings_repository_impl.dart
        ├── domain/
        │   ├── entities/settings_entity.dart
        │   └── repositories/settings_repository.dart
        └── presentation/
            ├── cubit/settings_cubit.dart
            ├── pages/settings_page.dart
            └── widgets/
                └── launcher_path_config.dart    # Custom paths per launcher
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
  ogi,      // OpenGameInstaller
  lutris,
  steam,
}
```

---

## Data Sources - Where to Read Game Data (Steam Deck)

> **Note:** On Steam Deck, most apps are installed via Flatpak, which uses sandboxed paths under `~/.var/app/`.

### 1. Heroic Games Launcher (Epic + GOG)

**Config Locations (Steam Deck - Flatpak):**
```
~/.var/app/com.heroicgameslauncher.hgl/config/heroic/
```

| Path | Purpose |
|------|---------|
| `config/heroic/GamesConfig/*.json` | Per-game settings |
| `config/heroic/store_cache/gog_library.json` | GOG game metadata |
| `config/legendary/installed.json` | **Epic games install paths & sizes** |

**Key file: `installed.json`** (Epic Games via Legendary)
```json
{
  "Fortnite": {
    "app_name": "Fortnite",
    "title": "Fortnite",
    "install_path": "/home/deck/Games/Heroic/Fortnite",
    "install_size": 95367431168
  }
}
```

> **Tip:** `install_size` is already available in bytes! No need to calculate for Epic games.

### 2. Lutris

**Config Locations (Steam Deck - Flatpak):**
```
~/.var/app/net.lutris.Lutris/data/lutris/pga.db     # SQLite database
~/.var/app/net.lutris.Lutris/config/lutris/games/   # YAML configs
```

**Standard Linux (non-Flatpak):**
```
~/.local/share/lutris/pga.db
~/.config/lutris/games/*.yml
```

**From SQLite (`pga.db`):**
```sql
SELECT id, name, slug, directory, installed FROM games WHERE installed = 1;
```

The `directory` column contains the install path. Calculate size recursively.

### 3. Steam (Native)

**Config Locations (Steam Deck):**
```
/home/deck/.local/share/Steam/steamapps/            # Primary location
/home/deck/.steam/steam/steamapps/                  # Symlink (same location)
```

| File | Purpose |
|------|---------|
| `libraryfolders.vdf` | Lists all Steam library folders (internal + SD card) |
| `appmanifest_<appid>.acf` | Per-game metadata including **SizeOnDisk** |

**From `appmanifest_*.acf`:**
```
"AppState"
{
    "appid" "1245620"
    "name" "Elden Ring"
    "installdir" "ELDEN RING"
    "SizeOnDisk" "49283174400"
}
```

> **Tip:** Steam already provides `SizeOnDisk` in bytes! Parse directly, no calculation needed.

### 4. OpenGameInstaller (OGI)

[OpenGameInstaller](https://github.com/Nat3z/OpenGameInstaller) is a game installation platform that integrates with Steam as non-Steam games.

**Config Locations (Steam Deck):**
```
~/.local/share/OpenGameInstaller/library/    # Game metadata JSON files
```

**Library structure:**
```
library/
├── game-slug-1.json
├── game-slug-2.json
└── ...
```

**Game JSON format:**
```json
{
  "name": "Game Title",
  "appID": "game-slug",
  "titleImage": "https://...",
  "installLocation": "/home/deck/Games/OGI/GameTitle"
}
```

**Key fields:**
| Field | Purpose |
|-------|---------|
| `name` | Display title |
| `appID` | Unique game identifier (slug) |
| `installLocation` | **Path to game installation** |
| `titleImage` | URL to game cover art |

**Steam Integration:**
OGI games are added as non-Steam games, appearing in Steam's `shortcuts.vdf` (binary VDF format):
```
~/.local/share/Steam/userdata/<user_id>/config/shortcuts.vdf
```

To get size: Calculate `installLocation` directory size recursively.

---

## Core Features

### 1. Game List with Sorting
- Display all games from all sources in a unified list
- **Sort by size (descending)** by default
- Show: Title, Source icon, Size (human-readable), Install path
- Tab filters: All | Heroic | OGI | Lutris | Steam

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

| Source | Uninstall Method | Notes |
|--------|------------------|-------|
| **Heroic (Epic)** | `legendary uninstall <app_name>` | Uses bundled Legendary CLI |
| **Heroic (GOG)** | Delete `install_path` folder + remove entry from GOG cache | No CLI available |
| **OGI** | Delete `installLocation` folder + remove JSON from `library/` | Also removes from Steam shortcuts |
| **Lutris** | Delete `directory` folder + `DELETE FROM games WHERE slug='...'` in `pga.db` | **No CLI for uninstall** - must manually delete |
| **Steam** | `steam steam://uninstall/<appid>` | Opens Steam uninstall dialog |

**Recommended: Safe deletion approach**
1. Show confirmation dialog with game name and size
2. Delete the `install_path` directory recursively
3. Update/remove entry from launcher's database/config
4. Refresh game list

### 4. Visual Features
- Size breakdown pie/bar chart by launcher
- Total disk usage summary at the top
- Progress indicator during size calculation (can be slow for large libraries)
- Pull-to-refresh

---

## Platform Service

```dart
abstract class PlatformService {
  // Home directory
  String get homeDir; // /home/deck on Steam Deck
  
  // Heroic paths (check Flatpak first, then standard)
  String get heroicFlatpakPath => '$homeDir/.var/app/com.heroicgameslauncher.hgl/config';
  String get heroicStandardPath => '$homeDir/.config/heroic';
  String get heroicConfigPath; // Returns whichever exists
  String get legendaryInstalledJsonPath; // .../legendary/installed.json
  
  // OGI paths
  String get ogiLibraryPath => '$homeDir/.local/share/OpenGameInstaller/library';
  
  // Lutris paths (check Flatpak first, then standard)  
  String get lutrisFlatpakDbPath => '$homeDir/.var/app/net.lutris.Lutris/data/lutris/pga.db';
  String get lutrisStandardDbPath => '$homeDir/.local/share/lutris/pga.db';
  String get lutrisDbPath; // Returns whichever exists
  
  // Steam paths
  String get steamAppsPath => '$homeDir/.local/share/Steam/steamapps';
  String get steamUserDataPath => '$homeDir/.local/share/Steam/userdata'; // For shortcuts.vdf
  List<String> get allSteamLibraryPaths; // Parses libraryfolders.vdf for SD card paths
  
  // Launcher detection
  bool get isHeroicInstalled;
  bool get isOgiInstalled;
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

### Steam Deck Hardware Specs (for reference)
- **Screen:** 7" 1280x800 touchscreen
- **Input:** Touchscreen, trackpads, D-pad, ABXY buttons, triggers
- **Recommended touch target:** 48-64px minimum

### Steam Deck Optimization
- **Minimum touch target:** 48px height (64px preferred)
- **Large fonts:** 16px minimum for body, 14px minimum for secondary text
- **High contrast:** Dark theme optimized for LCD/OLED
- **Bottom action bar:** Easy thumb access when holding device
- **Focus indicators:** Visible highlight rings for gamepad navigation
- **D-pad navigation:** Logical focus order (up/down through list, left/right for tabs)
- **Button prompts:** Show A/B/X/Y prompts for actions (e.g., "A: Select, X: Uninstall")

### Gamepad Navigation Implementation
```dart
// Use Flutter's Focus system
FocusableActionDetector(
  onShowFocusHighlight: (focused) => setState(() => _focused = focused),
  actions: {
    ActivateIntent: CallbackAction(onInvoke: (_) => _onTap()),
  },
  child: Container(
    decoration: _focused ? focusDecoration : null,
    child: gameListItem,
  ),
)
```

### Key UI Components

1. **Header Card:** Total disk usage with progress bar
   - "Games: 245 GB / 512 GB (48%)"
   - Color-coded: green (<70%), yellow (70-90%), red (>90%)

2. **Source Tabs:** Horizontal chip row (All | Heroic | Lutris | Steam)
   - Show count per source: "Heroic (12)"

3. **Game List:** Scrollable, sorted by size descending
   - Pull-to-refresh support
   - Lazy loading for large libraries

4. **Game Item (64px height):**
   ```
   ┌────────────────────────────────────────────────────┐
   │ [✓] [Icon] Cyberpunk 2077          [Heroic] 75.2 GB│
   │                                    /home/deck/Games│
   └────────────────────────────────────────────────────┘
   ```
   - Checkbox (left), Icon (48x48), Title, Source badge, Size (bold)
   - Secondary line: truncated install path

5. **Bottom Action Bar (sticky):**
   - Left: "X selected (120 GB)"
   - Right: [Uninstall] [Refresh] buttons
   - Gamepad: X = Uninstall, Y = Refresh

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
