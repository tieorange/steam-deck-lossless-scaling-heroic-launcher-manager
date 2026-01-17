#!/bin/bash
# Heroic LSFG Applier - Uninstall Script
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/heroic-lsfg-applier/main/uninstall.sh | bash

set -e

# Configuration
APP_NAME="heroic_lsfg_applier"
DISPLAY_NAME="Heroic LSFG Applier"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
BIN_LINK="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/heroic-lsfg-applier.desktop"
ICON_FILE="$HOME/.local/share/icons/hicolor/256x256/apps/heroic-lsfg-applier.png"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║          🗑️  Heroic LSFG Applier Uninstaller 🗑️            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if installed
if [[ ! -d "$INSTALL_DIR" ]] && [[ ! -f "$DESKTOP_FILE" ]]; then
    echo -e "${YELLOW}$DISPLAY_NAME does not appear to be installed.${NC}"
    exit 0
fi

echo -e "${YELLOW}This will remove:${NC}"
[[ -d "$INSTALL_DIR" ]] && echo "  • $INSTALL_DIR"
[[ -L "$BIN_LINK" ]] && echo "  • $BIN_LINK"
[[ -f "$DESKTOP_FILE" ]] && echo "  • $DESKTOP_FILE"
[[ -f "$ICON_FILE" ]] && echo "  • $ICON_FILE"
echo ""

# Ask for confirmation (skip if piped)
if [[ -t 0 ]]; then
    read -p "Are you sure you want to uninstall? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Uninstall cancelled.${NC}"
        exit 0
    fi
fi

echo -e "${YELLOW}Removing $DISPLAY_NAME...${NC}"

# Remove files
[[ -d "$INSTALL_DIR" ]] && rm -rf "$INSTALL_DIR"
[[ -L "$BIN_LINK" ]] && rm -f "$BIN_LINK"
[[ -f "$DESKTOP_FILE" ]] && rm -f "$DESKTOP_FILE"
[[ -f "$ICON_FILE" ]] && rm -f "$ICON_FILE"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              ✅ Uninstall Complete!                        ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo "Thank you for using $DISPLAY_NAME!"
echo ""
