#!/bin/bash
# Build script for Steam Deck
# Run this in Desktop Mode on your Steam Deck

set -e

echo "==================================="
echo "Heroic LSFG Applier - Build Script"
echo "==================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${RED}Error: This script must be run on Linux (Steam Deck)${NC}"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo -e "${YELLOW}Step 1: Checking Flutter installation...${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}Flutter not found. Installing Flutter...${NC}"
    
    # Install Flutter using snap or manual download
    if command -v snap &> /dev/null; then
        sudo snap install flutter --classic
    else
        # Manual installation
        FLUTTER_DIR="$HOME/.flutter"
        if [ ! -d "$FLUTTER_DIR" ]; then
            echo "Downloading Flutter..."
            git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
        fi
        export PATH="$FLUTTER_DIR/bin:$PATH"
        echo "export PATH=\"$FLUTTER_DIR/bin:\$PATH\"" >> ~/.bashrc
    fi
fi

echo -e "${GREEN}Flutter found: $(flutter --version | head -1)${NC}"

echo -e "${YELLOW}Step 2: Installing Linux build dependencies...${NC}"

# Install required packages for Flutter Linux build
# Steam Deck uses Arch-based SteamOS
if command -v pacman &> /dev/null; then
    echo "Detected Arch-based system (SteamOS)"
    # Unlock the filesystem if needed (Steam Deck specific)
    if [ -f /usr/bin/steamos-readonly ]; then
        echo -e "${YELLOW}Note: You may need to disable read-only mode first:${NC}"
        echo "  sudo steamos-readonly disable"
    fi
    
    # Required packages for Flutter Linux
    sudo pacman -S --needed --noconfirm \
        clang \
        cmake \
        ninja \
        pkgconf \
        gtk3 \
        2>/dev/null || true
elif command -v apt &> /dev/null; then
    echo "Detected Debian-based system"
    sudo apt update
    sudo apt install -y \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev
fi

echo -e "${YELLOW}Step 3: Getting dependencies...${NC}"
flutter pub get

echo -e "${YELLOW}Step 4: Generating code...${NC}"
dart run build_runner build --delete-conflicting-outputs

echo -e "${YELLOW}Step 5: Building Linux release...${NC}"
flutter build linux --release

BUILD_DIR="$PROJECT_DIR/build/linux/x64/release/bundle"

if [ -d "$BUILD_DIR" ]; then
    echo -e "${GREEN}==================================="
    echo "Build successful!"
    echo "==================================="
    echo ""
    echo "The app is built at:"
    echo "  $BUILD_DIR"
    echo ""
    echo "To run the app:"
    echo "  $BUILD_DIR/heroic_lsfg_applier"
    echo ""
    echo "To install as a standalone app, run:"
    echo "  $SCRIPT_DIR/install_local.sh"
    echo "===================================${NC}"
else
    echo -e "${RED}Build failed! Check the output above for errors.${NC}"
    exit 1
fi
