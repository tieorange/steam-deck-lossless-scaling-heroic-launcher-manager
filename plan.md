# Heroic LSFG Applier - Project Plan & Status

You are an expert Flutter developer building a Linux desktop application for the Steam Deck (SteamOS, Arch Linux-based). The goal is to create a standalone Flatpak-packaged app called "Heroic LSFG Applier" that runs in Desktop Mode on the Steam Deck.

The app's purpose: Allow users to easily enable the LSFG-VK Decky plugin (Lossless Scaling frame generation via Vulkan layer) for selected (or all) games installed via **Heroic Games Launcher**, **Lutris**, and **OpenGameInstaller**. It does this by modifying each game's config file (JSON or YAML) to add the environment variable `LSFG_PROCESS=decky-lsfg-vk`.

## Current Status (January 2026)

### ✅ Completed Features
- **Heroic Integration**:
  - Detection of installed games (JSON parsing).
  - Modifying `environmentOptions` to toggle LSFG.
  - Handling legacy config typos (`enviromentOptions`).
- **Lutris Integration**:
  - Detection of installed games (YAML parsing).
  - Modifying `system: env` section safely using `yaml_edit`.
- **Game ID Collision Fix**:
  - Implemented unique ID system (`source:internalId`) to handle games with same names across launchers.
- **Logging System**:
  - File-based logging to `heroic_lsfg_logs.txt`.
  - **Manual Export**: Users can save logs to any location via native file picker.
- **UI/UX**:
  - Tabbed interface for Heroic, OGI, and Lutris.
  - Search functionality (by title or internal ID).
  - Bulk apply/remove actions.
- **Safety**:
  - Flatpak permissions updated for access to necessary config directories.

### 🚧 Works In Progress / Limitation
- **OpenGameInstaller (OGI)**:
  - Game detection (JSON) is working.
  - **Limitation**: Applying LSFG requires editing binary Steam shortcuts (`shortcuts.vdf`), which is currently **not implemented**.

## Key requirements:
- **Tech stack**: Flutter for Linux desktop. Material 3 design.
- **Packaging**: Flatpak (org.example.heroic_lsfg_applier).
- **Safety**: The app MUST always create a timestamped backup of the entire ~/.config/heroic/games_config/ directory before changes (Backup feature is implemented).

## Technical Architecture
- **State Management**: flutter_bloc.
- **DI**: GetIt/Manual injection.
- **Repositories**: `GameRepository` (Facade), `HeroicDatasource`, `LutrisDatasource`, `OgiDatasource`.
- **Entities**: `Game(id, internalId, source, type, hasLsfgEnabled)`.

## Implementation Plan

### 1. Research phase (Completed)
- Confirmed paths for Heroic (`~/.config/heroic`), Lutris (`~/.config/lutris`), OGI (`~/.local/share/OpenGameInstaller`).

### 2. Project setup (Completed)
- Flutter project with Linux desktop.
- Dependencies: `flutter_bloc`, `dartz`, `freezed`, `json_serializable`, `go_router`, `path_provider`, `yaml`, `file_picker`.

### 3. Implement core logic (Completed)
- [x] List games from all launchers.
- [x] Backup/restore.
- [x] Apply/Remove LSFG env vars (Heroic/Lutris).

### 4. Build polished UI (Completed)
- [x] Responsive layout.
- [x] Dark/light theme.
- [x] Tabbed view for launchers.

### 5. Flatpak packaging (In Progress)
- [x] Manifest created (`org.example.heroic_lsfg_applier_prebuilt.yaml`).
- [x] Permissions updated.
- [ ] Final build verification.

### 6. Testing instructions:
- **Build Locally**: `flutter run -d linux`.
- **Build Flatpak**: `flatpak-builder --user --install --force-clean build flatpak/org.example.heroic_lsfg_applier_prebuilt.yaml`.

## Future Work
- Implement binary VDF parser for OGI/Steam shortcuts.
- Add "Restore Backup" UI (currently backend logic exists).