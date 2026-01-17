#!/bin/bash
# Heroic LSFG Applier - One-liner Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/heroic-lsfg-applier/main/install.sh | bash
#
# This script:
# 1. Downloads the latest release from GitHub
# 2. Extracts to ~/.local/share/heroic_lsfg_applier/
# 3. Creates desktop entry for application menu
# 4. The app itself handles auto-updates after installation

set -e

# Configuration
REPO_OWNER="tieorange"
REPO_NAME="steam-deck-lossless-scaling-heroic-launcher-manager"
APP_NAME="heroic_lsfg_applier"
DISPLAY_NAME="Heroic LSFG Applier"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
TEMP_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🎮 Heroic LSFG Applier Installer 🎮             ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check for required commands
for cmd in curl unzip; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}Error: $cmd is required but not installed.${NC}"
        exit 1
    fi
done

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    echo -e "${RED}Error: Only x86_64 architecture is supported.${NC}"
    echo "Detected architecture: $ARCH"
    exit 1
fi

# Check if running on Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo -e "${RED}Error: This installer is only for Linux/Steam Deck.${NC}"
    exit 1
fi

echo -e "${YELLOW}Fetching latest release information...${NC}"

# Get latest release info from GitHub API
RELEASE_INFO=$(curl -fsSL "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" 2>/dev/null || echo "")

if [[ -z "$RELEASE_INFO" ]]; then
    echo -e "${RED}Error: Could not fetch release information.${NC}"
    echo "Please check your internet connection and that the repository exists:"
    echo "https://github.com/$REPO_OWNER/$REPO_NAME"
    exit 1
fi

# Parse release info
VERSION=$(echo "$RELEASE_INFO" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep '"browser_download_url"' | grep -i 'linux.*zip\|linux_x64\.zip' | head -1 | sed -E 's/.*"browser_download_url": *"([^"]+)".*/\1/')

if [[ -z "$VERSION" ]] || [[ -z "$DOWNLOAD_URL" ]]; then
    echo -e "${RED}Error: Could not parse release information.${NC}"
    echo "Make sure there is a Linux release asset available."
    exit 1
fi

echo -e "${GREEN}Latest version: $VERSION${NC}"

# Check if already installed and same version
VERSION_FILE="$INSTALL_DIR/version.txt"
if [[ -f "$VERSION_FILE" ]]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo "")
    if [[ "$CURRENT_VERSION" == "$VERSION" ]]; then
        echo -e "${GREEN}✓ Already up to date (version $VERSION)${NC}"
        echo ""
        echo "Run the app from your application menu or:"
        echo "  $APP_NAME"
        exit 0
    else
        echo -e "${YELLOW}Upgrading from $CURRENT_VERSION to $VERSION...${NC}"
    fi
fi

echo -e "${YELLOW}Downloading $DISPLAY_NAME...${NC}"

# Download release
ARCHIVE_FILE="$TEMP_DIR/release.zip"
if ! curl -fsSL -o "$ARCHIVE_FILE" "$DOWNLOAD_URL"; then
    echo -e "${RED}Error: Download failed.${NC}"
    exit 1
fi

echo -e "${YELLOW}Extracting...${NC}"

# Extract to temp directory
EXTRACT_DIR="$TEMP_DIR/extract"
mkdir -p "$EXTRACT_DIR"
unzip -q "$ARCHIVE_FILE" -d "$EXTRACT_DIR"

# Find the bundle directory (handle both flat and nested structures)
if [[ -f "$EXTRACT_DIR/$APP_NAME" ]]; then
    BUNDLE_DIR="$EXTRACT_DIR"
elif [[ -d "$EXTRACT_DIR/bundle" ]]; then
    BUNDLE_DIR="$EXTRACT_DIR/bundle"
else
    # Find the directory containing the executable
    BUNDLE_DIR=$(find "$EXTRACT_DIR" -name "$APP_NAME" -type f -exec dirname {} \; | head -1)
    if [[ -z "$BUNDLE_DIR" ]]; then
        echo -e "${RED}Error: Could not find application in archive.${NC}"
        exit 1
    fi
fi

echo -e "${YELLOW}Installing to $INSTALL_DIR...${NC}"

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$ICON_DIR"

# Backup existing installation if it exists
if [[ -d "$INSTALL_DIR" ]] && [[ -f "$INSTALL_DIR/$APP_NAME" ]]; then
    echo -e "${YELLOW}Backing up existing installation...${NC}"
    rm -rf "$INSTALL_DIR.bak"
    mv "$INSTALL_DIR" "$INSTALL_DIR.bak"
    mkdir -p "$INSTALL_DIR"
fi

# Copy files
cp -r "$BUNDLE_DIR"/* "$INSTALL_DIR/"

# Save version info
echo "$VERSION" > "$INSTALL_DIR/version.txt"

# Make executable
chmod +x "$INSTALL_DIR/$APP_NAME"

# Create symlink in bin
ln -sf "$INSTALL_DIR/$APP_NAME" "$BIN_DIR/$APP_NAME"

# Create desktop entry
cat > "$DESKTOP_DIR/heroic-lsfg-applier.desktop" << EOF
[Desktop Entry]
Name=$DISPLAY_NAME
Comment=Enable Lossless Scaling frame generation for Heroic, Lutris, and OGI games
Exec=$INSTALL_DIR/$APP_NAME
Icon=heroic-lsfg-applier
Type=Application
Categories=Game;Utility;
Keywords=heroic;lossless;scaling;frame;generation;lutris;ogi;
StartupWMClass=$APP_NAME
Terminal=false
EOF

# Copy icon
if [[ -f "$INSTALL_DIR/icon.png" ]]; then
    cp "$INSTALL_DIR/icon.png" "$ICON_DIR/heroic-lsfg-applier.png"
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo -e "${YELLOW}Note: Added ~/.local/bin to PATH. Run 'source ~/.bashrc' or restart terminal.${NC}"
fi

# Clean up backup on success
rm -rf "$INSTALL_DIR.bak"

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              ✅ Installation Complete!                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo "Version: $VERSION"
echo "Location: $INSTALL_DIR"
echo ""
echo -e "${GREEN}How to run:${NC}"
echo "  • From application menu: Search for '$DISPLAY_NAME'"
echo "  • From terminal: $APP_NAME"
echo ""
echo -e "${YELLOW}Note: The app will automatically check for updates on startup.${NC}"
echo ""
echo -e "To uninstall, run: ${BLUE}curl -fsSL https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/uninstall.sh | bash${NC}"
echo ""
