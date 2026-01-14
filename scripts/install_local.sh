#!/bin/bash
# Install the app locally on Steam Deck
# Run this after build_on_deck.sh

set -e

echo "==================================="
echo "Installing Heroic LSFG Applier"
echo "==================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build/linux/x64/release/bundle"

# Installation directory
INSTALL_DIR="$HOME/.local/share/heroic_lsfg_applier"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"

# Check if build exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build not found! Run build_on_deck.sh first."
    exit 1
fi

echo -e "${YELLOW}Installing to $INSTALL_DIR...${NC}"

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$ICON_DIR"

# Copy the app bundle
cp -r "$BUILD_DIR"/* "$INSTALL_DIR/"

# Create a symlink in bin
ln -sf "$INSTALL_DIR/heroic_lsfg_applier" "$BIN_DIR/heroic_lsfg_applier"

# Create desktop entry
cat > "$DESKTOP_DIR/heroic-lsfg-applier.desktop" << EOF
[Desktop Entry]
Name=Heroic LSFG Applier
Comment=Enable Lossless Scaling frame generation for Heroic games
Exec=$INSTALL_DIR/heroic_lsfg_applier
Icon=heroic-lsfg-applier
Type=Application
Categories=Game;Utility;
Keywords=heroic;lossless;scaling;frame;generation;
StartupWMClass=heroic_lsfg_applier
EOF

# Copy icon if exists, or create a placeholder
if [ -f "$PROJECT_DIR/flatpak/icon.png" ]; then
    cp "$PROJECT_DIR/flatpak/icon.png" "$ICON_DIR/heroic-lsfg-applier.png"
else
    echo -e "${YELLOW}Note: No icon.png found in flatpak/, using default${NC}"
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

# Make sure PATH includes .local/bin
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo -e "${YELLOW}Added ~/.local/bin to PATH in ~/.bashrc${NC}"
fi

echo -e "${GREEN}==================================="
echo "Installation complete!"
echo "==================================="
echo ""
echo "You can now run the app:"
echo "  1. From terminal: heroic_lsfg_applier"
echo "  2. From application menu: Search for 'Heroic LSFG Applier'"
echo ""
echo "To uninstall, run:"
echo "  rm -rf $INSTALL_DIR"
echo "  rm $BIN_DIR/heroic_lsfg_applier"
echo "  rm $DESKTOP_DIR/heroic-lsfg-applier.desktop"
echo "===================================${NC}"
