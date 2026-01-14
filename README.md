# Heroic LSFG Applier

A Flutter desktop application for Steam Deck that enables **Lossless Scaling frame generation (LSFG-VK)** for games installed via Heroic Games Launcher.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Steam%20Deck-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- 📋 **Game List**: View all games installed via Heroic Games Launcher
- ✅ **Apply LSFG**: Enable frame generation for selected games with one click
- ❌ **Remove LSFG**: Disable frame generation when needed
- 🔍 **Search**: Quickly find games in your library
- 💾 **Backup**: Create timestamped backups before making changes
- 🔄 **Restore**: Easily restore from any backup if needed
- 🌙 **Dark/Light Theme**: Follows system preference

## Requirements

- Steam Deck (SteamOS) or any Linux system
- [Heroic Games Launcher](https://heroicgameslauncher.com/) (Flatpak version recommended)
- [LSFG-VK Decky Plugin](https://github.com/your-decky-plugin) installed

## Installation

### On Steam Deck (Recommended)

The easiest way to install is directly on your Steam Deck in Desktop Mode:

```bash
# 1. Clone or copy the project to your Steam Deck
git clone https://github.com/example/heroic-lsfg-applier.git
cd heroic-lsfg-applier

# 2. Run the build script
./scripts/build_on_deck.sh

# 3. Install locally (adds to app menu)
./scripts/install_local.sh
```

The app will appear in your application menu as "Heroic LSFG Applier".

### From Flatpak (Advanced)

```bash
# Install from local build (requires flatpak-builder)
flatpak-builder --user --install --force-clean build flatpak/org.example.heroic_lsfg_applier.yaml

# Or install from Flathub (when available)
flatpak install flathub org.example.heroic_lsfg_applier
```

### From Source

```bash
# Clone the repository
git clone https://github.com/example/heroic-lsfg-applier.git
cd heroic-lsfg-applier

# Install dependencies
flutter pub get

# Generate code
dart run build_runner build

# Run on Linux
flutter run -d linux
```

## Usage

1. **Launch the app** from the application menu in Desktop Mode
2. **Create a backup first** - Click the backup icon in the top right, then "Create Backup Now"
3. **Select games** - Check the games you want to enable LSFG for
4. **Apply LSFG** - Click "Apply LSFG" button at the bottom
5. **Launch your games** - The LSFG-VK plugin will now work with these games

### Removing LSFG

1. Select the games you want to disable LSFG for
2. Click "Remove LSFG" button
3. The games will return to their original state

### Restoring from Backup

If something goes wrong:
1. Go to Backup & Restore (backup icon)
2. Find the backup you want to restore
3. Click the restore icon
4. Confirm the restoration

## How It Works

The app modifies game configuration files located at:
- **Flatpak Heroic**: `~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/`
- **Native Heroic**: `~/.config/heroic/GamesConfig/`

For each selected game, it adds the environment variable:
```json
{
  "enviromentOptions": {
    "LSFG_PROCESS": "decky-lsfg-vk"
  }
}
```

This tells the LSFG-VK Vulkan layer to inject frame generation into the game.

## Development

### macOS Testing

The app includes mock paths for macOS development. Create test files at:
```bash
mkdir -p ~/HeroicTest/config/heroic/GamesConfig

# Create sample game configs
echo '{"app_name":"test_game","title":"Test Game"}' > ~/HeroicTest/config/heroic/GamesConfig/test_game.json
```

### Project Structure

```
lib/
├── core/
│   ├── error/          # Failure classes
│   ├── platform/       # Platform-specific paths
│   ├── router/         # go_router setup
│   └── theme/          # Material 3 themes
├── features/
│   ├── games/          # Game list feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── backup/         # Backup feature
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

### Building Flatpak

```bash
# Install flatpak-builder if not already installed
sudo apt install flatpak-builder

# Build and install locally
flatpak-builder --user --install --force-clean build flatpak/org.example.heroic_lsfg_applier.yaml
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- [Heroic Games Launcher](https://heroicgameslauncher.com/) team
- [LSFG-VK](https://github.com/lsfg-vk) developers
- Flutter team for excellent Linux desktop support
