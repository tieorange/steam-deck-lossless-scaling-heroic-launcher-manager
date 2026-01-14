#!/bin/bash
# Complete build script: Flutter Linux Binary -> Flatpak -> .flatpak file

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}===============================================${NC}"
echo -e "${YELLOW}    Heroic LSFG Applier - Flatpak Builder      ${NC}"
echo -e "${YELLOW}===============================================${NC}"

# Add common Docker paths on macOS
export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin:/Applications/Docker.app/Contents/Resources/bin"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_FILE="$PROJECT_ROOT/docker/Dockerfile.flatpak"

# 1. Build the Docker Image
echo -e "${YELLOW}Step 1: Building Docker image...${NC}"
docker build -t flutter-flatpak-builder -f "$DOCKER_FILE" "$PROJECT_ROOT/docker"

# 2. Run the Build Container
echo -e "${YELLOW}Step 2: Building App and Flatpak...${NC}"
echo "This needs to download Flatpak runtimes (several GBs) on the first run."
echo "Please be patient."

# We use a volume for flatpak-cache to speed up subsequent builds
docker volume create flatpak-cache

docker run --privileged --rm \
    -v "$PROJECT_ROOT:/app" \
    -v flatpak-cache:/var/lib/flatpak \
    flutter-flatpak-builder \
    bash -c "
    set -e
    
    echo '--- Configuring git safety ---'
    git config --global --add safe.directory /app
    
    echo '--- Building Linux Binary ---'
    flutter pub get
    flutter build linux --release
    
    echo '--- Setting up Flatpak ---'
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # We allow the install to fail strictly if it's already there/cached issues, but check explicitly
    echo '--- Installing Runtimes (may take a while) ---'
    flatpak install --user -y flathub org.freedesktop.Platform//24.08 org.freedesktop.Sdk//24.08
    
    echo '--- Building Flatpak ---'
    # Clean previous builds
    rm -rf .flatpak-builder
    rm -rf build-dir
    
    # Build using the prebuilt manifest
    # We disable sandboxing issues with --sandbox-build-dir (or relies on privileged)
    flatpak-builder --user --force-clean --repo=repo --install-deps-from=flathub build-dir flatpak/org.example.heroic_lsfg_applier_prebuilt.yaml
    
    echo '--- Exporting Bundle ---'
    # Create the single-file bundle
    flatpak build-bundle repo releases/heroic_lsfg_applier.flatpak org.example.heroic_lsfg_applier
    
    echo '--- Done inside container ---'
    "

echo -e "${YELLOW}Step 3: Fixing permissions...${NC}"
# Docker creates files as root
if [ -d "$PROJECT_ROOT/releases" ]; then
    sudo chown -R $(id -u):$(id -g) "$PROJECT_ROOT/releases"
    sudo chown -R $(id -u):$(id -g) "$PROJECT_ROOT/build"
    sudo chown -R $(id -u):$(id -g) "$PROJECT_ROOT/.dart_tool"
fi

OUTPUT_FILE="$PROJECT_ROOT/releases/heroic_lsfg_applier.flatpak"
if [ -f "$OUTPUT_FILE" ]; then
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}    Flatpak Build Successful!    ${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    echo "Files available in releases/:"
    ls -lh "$PROJECT_ROOT/releases/"
    echo ""
    echo "To install on Steam Deck:"
    echo "1. Copy 'heroic_lsfg_applier.flatpak' to your Deck"
    echo "2. Run: flatpak install --user heroic_lsfg_applier.flatpak"
    echo "==============================================="
else
    echo -e "${RED}Build failed! Output file not found.${NC}"
    exit 1
fi
