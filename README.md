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

### Method 1: Download Release (Recommended)

1. **Download** the latest `heroic_lsfg_applier_linux_x64.zip` from the [Releases page](#).
2. **Transfer** the zip file to your Steam Deck (Desktop Mode).
3. **Right-click and Extract** the zip file.
4. Open the extracted folder, right-click inside, and choosing "Open Terminal Here".
5. Run the installer:
   ```bash
   ./install_local.sh
   ```
   *This will add "Heroic LSFG Applier" to your application menu.*

### Method 2: Build from Source

If you prefer to build it yourself on the Deck:

```bash
# 1. Clone the project
git clone https://github.com/example/heroic-lsfg-applier.git
cd heroic-lsfg-applier

# 2. Run the build script (automates fetching Flutter & dependencies)
./scripts/build_on_deck.sh

# 3. Install locally
./scripts/install_local.sh
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

### Building Linux App from Mac (M-chip)

To build the Linux version on a MacBook with Apple Silicon (M1/M2/M3):

1. **Install Docker Desktop**: Ensure Docker Desktop for Mac is installed and running.
   - Go to Settings -> General -> Ensure "Use Rosetta for x86/amd64 emulation on Apple Silicon" is ENABLED.

2. **Run the Build Script**:
   ```bash
   ./build_linux_on_mac.sh
   ```
   *Note: This script uses a Docker container to cross-compile the Linux binary (x64) and packages it as a ZIP file. The first run may take several minutes to download dependencies.*

   **Output**:
   - The script produces `releases/heroic_lsfg_applier_linux_x64.zip`.
   - Tranfser this file to your Steam Deck, unzip, and run the binary.

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
