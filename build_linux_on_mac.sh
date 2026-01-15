#!/bin/bash
# Build the Linux version of the app using Docker on macOS

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}===============================================${NC}"
echo -e "${YELLOW}    Heroic LSFG Applier - Docker Build Tool    ${NC}"
echo -e "${YELLOW}===============================================${NC}"

# Add common Docker paths on macOS
export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin:/Applications/Docker.app/Contents/Resources/bin"

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH.${NC}"
    echo "Please install Docker Desktop for Mac first: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running.${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$PROJECT_ROOT/docker"

echo -e "${YELLOW}Step 1: Building Docker image (forcing amd64)...${NC}"
# Use the standard Dockerfile for binary build, not the flatpak one
docker build --platform linux/amd64 -t flutter-linux-builder "$DOCKER_DIR"

echo -e "${YELLOW}Step 2: Building Linux app in container...${NC}"
echo "This may take a few minutes..."

# Run the container mapping the current directory to /app
docker run --platform linux/amd64 --rm \
    -v "$PROJECT_ROOT:/app" \
    flutter-linux-builder \
    bash -c "git config --global --add safe.directory /app && flutter pub get && flutter build linux --release"

echo -e "${YELLOW}Step 3: Creating Release ZIP...${NC}"

BUILD_OUTPUT="$PROJECT_ROOT/build/linux/x64/release/bundle"

if [ -d "$BUILD_OUTPUT" ]; then
    echo "Bundling helper scripts and icon..."
    # Copy install script and icon to the bundle so they are included in the zip
    cp "$PROJECT_ROOT/scripts/install_local.sh" "$BUILD_OUTPUT/"
    chmod +x "$BUILD_OUTPUT/install_local.sh"
    
    if [ -f "$PROJECT_ROOT/flatpak/icon.png" ]; then
        cp "$PROJECT_ROOT/flatpak/icon.png" "$BUILD_OUTPUT/"
    fi
    
    # Create releases directory
    mkdir -p "$PROJECT_ROOT/releases"
    
    # Create the zip file
    ZIP_PATH="$PROJECT_ROOT/releases/heroic_lsfg_applier_linux_x64.zip"
    
    # Remove existing zip if any
    rm -f "$ZIP_PATH"
    
    # Zip the bundle contents
    # We cd into the bundle dir so the zip doesn't contain the full path
    pushd "$BUILD_OUTPUT" > /dev/null
    zip -r "$ZIP_PATH" .
    popd > /dev/null
    
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}    Build Successful!    ${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    echo "The Linux app release has been created at:"
    echo "  $ZIP_PATH"
    echo ""
    echo "Next Steps:"
    echo "1. Transfer the zip to your Steam Deck"
    echo "2. Unzip and run 'heroic_lsfg_applier'"
    echo ""
else
    echo -e "${RED}Build failed! Output directory not found.${NC}"
    exit 1
fi
