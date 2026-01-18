# 💻 Contributing to Heroic LSFG Applier

Thank you for your interest in contributing! This document contains information for developers who want to build, test, and improve the application.

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

## 🏗️ Building from Source

### Building for Linux from Mac (Apple Silicon)

1. **Install Docker Desktop** (enable Rosetta for x86/amd64)
2. Run:
   ```bash
   make build-linux
   ```
3. Output: `releases/heroic_lsfg_applier_linux_x64.zip`

### Build on Steam Deck / Linux

```bash
# Clone the repo
git clone https://github.com/tieorange/heroic-lsfg-applier.git
cd heroic-lsfg-applier

# Build on Steam Deck
./scripts/build_on_deck.sh

# Install
./scripts/install_local.sh
```

## 🧪 Testing

### Testing OGI Support (macOS)

```bash
# 1. Setup test environment
make setup-test

# 2. Run the app and apply LSFG to "Test OGI Game"
make run

# 3. Verify the change
make verify-test
```

## 📂 Project Structure

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
