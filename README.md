# 🎮 Heroic LSFG Applier

A Flutter desktop application for **Steam Deck** that enables **Lossless Scaling Frame Generation (LSFG-VK)** for games installed via:
- 🦸 Heroic Games Launcher
- 🦎 Lutris  
- 📦 OpenGameInstaller (OGI)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Steam%20Deck-orange)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📋 **Game List** | View all games from Heroic, Lutris, and OGI |
| ✅ **Apply LSFG** | Enable frame generation with one click |
| ❌ **Remove LSFG** | Disable frame generation when needed |
| 🔍 **Search & Filter** | Find games quickly, filter by LSFG status |
| 💾 **Backup & Restore** | Automatic backups before changes |
| 🌙 **Dark/Light Theme** | Follows system preference |
| 🔧 **Export Logs** | Debug issues easily |

---

## 📦 Installation

### Method 1: Download Release (Recommended) 

1. **Download** the latest `heroic_lsfg_applier_linux_x64.zip` from Releases
2. **Transfer** the zip to your Steam Deck (Desktop Mode)
3. **Extract** the zip file
4. **Run the installer**:
   ```bash
   ./install_local.sh
   ```

The app will appear in your application menu! 🎉

### Method 2: Build from Source

```bash
# Clone the repo
git clone https://github.com/yourusername/heroic-lsfg-applier.git
cd heroic-lsfg-applier

# Build on Steam Deck
./scripts/build_on_deck.sh

# Install
./scripts/install_local.sh
```

---

## 🛠️ Makefile Commands

We provide a `Makefile` for easy development:

| Command | Description |
|---------|-------------|
| `make run` | Run the app on macOS |
| `make analyze` | Run Flutter analyzer |
| `make gen` | Generate freezed/json code |
| `make setup-test` | Create test environment (macOS) |
| `make verify-test` | Check if LSFG applied correctly |
| `make build-linux` | Build Linux release via Docker |
| `make install` | Install app locally |
| `make clean` | Clean build artifacts |

---

## 🚀 Usage

1. **Launch** the app from your application menu
2. **Create a backup** first (backup icon in top bar)
3. **Select games** you want to enable LSFG for
4. **Click "Apply LSFG"** ✅
5. **Launch your games** - Frame generation is now active!

### Removing LSFG

1. Select games → Click **"Remove LSFG"** ❌

### Restoring from Backup

1. Go to Backup & Restore → Select backup → Restore 🔄

---

## ⚙️ How It Works

The app modifies game configuration files:

| Launcher | Config Location | Method |
|----------|-----------------|--------|
| **Heroic** | `~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/*.json` | Adds `LSFG_PROCESS` to `environmentOptions` |
| **Lutris** | `~/.config/lutris/games/*.yml` | Adds `LSFG_PROCESS` to `system.env` |
| **OGI** | `~/.steam/steam/userdata/*/config/shortcuts.vdf` | Injects env var into `LaunchOptions` |

---

## 💻 Development

### Building for Linux from Mac (Apple Silicon)

1. **Install Docker Desktop** (enable Rosetta for x86/amd64)
2. Run:
   ```bash
   make build-linux
   ```
3. Output: `releases/heroic_lsfg_applier_linux_x64.zip`

### Testing OGI Support (macOS)

```bash
# 1. Setup test environment
make setup-test

# 2. Run the app and apply LSFG to "Test OGI Game"
make run

# 3. Verify the change
make verify-test
```

### Project Structure

```
lib/
├── core/
│   ├── logging/        # LoggerService
│   ├── platform/       # Platform paths
│   ├── services/       # VdfBinaryService
│   └── theme/          # Material 3 themes
├── features/
│   ├── games/          # Main game list feature
│   ├── backup/         # Backup & restore
│   └── settings/       # App settings
└── main.dart
```

---

## 📋 Requirements

- 🎮 Steam Deck (SteamOS) or Linux
- 🦸 [Heroic Games Launcher](https://heroicgameslauncher.com/) (optional)
- 🦎 [Lutris](https://lutris.net/) (optional)
- 📦 [OpenGameInstaller](https://github.com/Nat3z/OpenGameInstaller) (optional)
- 🔌 [LSFG-VK Decky Plugin](https://github.com/xMasterZx/decky-lsfg-vk) installed

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues and pull requests.

---

## 🙏 Acknowledgments

- [Heroic Games Launcher](https://heroicgameslauncher.com/) team
- [LSFG-VK](https://github.com/xMasterZx/decky-lsfg-vk) developers
- [OpenGameInstaller](https://github.com/Nat3z/OpenGameInstaller) by Nat3z
- Flutter team for excellent Linux desktop support
