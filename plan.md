You are an expert Flutter developer building a Linux desktop application for the Steam Deck (SteamOS, Arch Linux-based). The goal is to create a standalone Flatpak-packaged app called "Heroic LSFG Applier" that runs in Desktop Mode on the Steam Deck.

The app's purpose: Allow users to easily enable the LSFG-VK Decky plugin (Lossless Scaling frame generation via Vulkan layer) for selected (or all) games installed via Heroic Games Launcher (Flatpak version). It does this by modifying each game's config JSON file to add the environment variable `LSFG_PROCESS=decky-lsfg-vk` in the "environment" object.

Key requirements:
- Tech stack: Flutter for Linux desktop (latest stable version as of January 2026). Use Material 3 design for a clean, modern UI that fits KDE Plasma on Steam Deck.
- The app must be packaged as a Flatpak (org.example.HeroicLsfgApplier or similar ID) so it can be easily installed via Discover or flatpak install.
- Safety first: The app MUST always create a timestamped backup of the entire ~/.config/heroic/games_config/ directory (and optionally other relevant dirs like tools or runners) BEFORE any modifications. Provide explicit "Backup Now" and "Restore from Backup" features in the UI. Store backups in ~/.config/heroic_lsfg_applier/backups/ with folders named by timestamp (e.g., backup_2026-01-13_22-28).
- UI features:
  - Main screen: List of all installed Heroic games (read from ~/.config/heroic/games_config/*.json).
  - For each game: Checkbox, game title, optional game icon (Heroic caches icons in ~/.config/heroic/store_cache/images/ or similar – research exact path and load if possible; fall back to placeholder if missing).
  - Search/filter bar to find games quickly.
  - "Select All" / "Deselect All" buttons.
  - "Apply to Selected" button that adds the env var only to checked games (merge if "environment" already exists, create if not).
  - Status indicators: Show which games already have the env var enabled.
  - Separate "Backup & Restore" tab/section with list of existing backups, "Create Backup Now", and "Restore Selected Backup" (with confirmation dialog).
  - Info/toast messages for success/errors (e.g., using fluttertoast or snackbars).
  - Graceful handling: If no games found, show helpful message. Detect if Heroic config dir exists.
- File access: Use dart:io for reading/writing. Request necessary Flatpak permissions in the manifest (--filesystem=xdg-config/heroic:create,rw and xdg-config/heroic_lsfg_applier:create).
- Flatpak packaging: Generate a complete flatpak-builder manifest (use org.freedesktop.Platform 24.08 or latest, include Flutter runtime/modules as needed). Follow current best practices for Flutter Flatpak apps (reference official Flutter wiki or recent community examples).

Step-by-step plan you must follow in Cursor:
1. Research phase:
   - Confirm exact Heroic Games Launcher (Flatpak) config paths for games_config JSON files and icon cache locations (as of 2026).
   - Confirm current recommended way to package Flutter Linux apps as Flatpaks (runtime, SDK, extensions, modules).
   - Confirm structure of Heroic game JSON (fields like "title", "app_name", "environment", etc.).

2. Project setup:
   - Create a new Flutter project with Linux desktop enabled.
   - Set up necessary dependencies (path_provider, file_picker if needed for restore, intl for dates, etc.).

3. Implement core logic:
   - Functions to list games with titles, current LSFG status, and icon paths.
   - Backup/restore functions (copy entire directory recursively).
   - Apply function: Load JSON, add/merge environment object, save with proper indentation.

4. Build polished UI:
   - Responsive layout (works on Steam Deck 1280x800 and handheld mode).
   - Dark/light theme support (follow system).

5. Flatpak packaging:
   - Generate the .yaml manifest.
   - Include app icon, desktop file, metainfo.

6. Testing instructions:
   - Provide steps to build/run locally on Linux, then build Flatpak.
   - Safety checks to include in code.

7. Final deliverables:
   - Full working codebase.
   - flatpak-builder manifest.
   - README with installation/use instructions for Steam Deck users.

Start by researching the paths and Flatpak best practices, then scaffold the project structure, then implement step by step. Ask for confirmation before writing large files. Prioritize safety and user-friendliness – this app will modify user configs, so backups and confirmations are critical.


Most important notes:
- Must be in clean architecture (presentation, domain, data layers)
- Structured per feature
- If possible - make it possible to test it on macbook, so I don't have to connect steam deck to test it each time
- Use flutter_bloc cubit for state management
- Dartz for error handling
- Use freezed for data classes
- Use json_serializable for json serialization
- Use go_router for navigation
- Make it responsive
- Clean code, SOLID principles
- After finishing the project - refactor it to be more maintainable and scalable
- Use web search for research.