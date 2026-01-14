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

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCKER_DIR="$PROJECT_ROOT/docker"

echo -e "${YELLOW}Step 1: Building Docker image...${NC}"
docker build -t flutter-linux-builder "$DOCKER_DIR"

echo -e "${YELLOW}Step 2: Building Linux app in container...${NC}"
echo "This may take a few minutes..."

# Run the container mapping the current directory to /app
docker run --rm \
    -v "$PROJECT_ROOT:/app" \
    flutter-linux-builder \
    bash -c "git config --global --add safe.directory /app && flutter pub get && flutter build linux --release"

echo -e "${YELLOW}Step 3: Fixing permissions...${NC}"
# Docker creates files as root, we need to fix that
sudo chown -R $(id -u):$(id -g) "$PROJECT_ROOT/build/linux"

BUILD_OUTPUT="$PROJECT_ROOT/build/linux/x64/release/bundle"

if [ -d "$BUILD_OUTPUT" ]; then
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}    Build Successful!    ${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    echo "The Linux app has been built at:"
    echo "  $BUILD_OUTPUT"
    echo ""
    echo "Next Steps:"
    echo "1. Copy the 'bundle' folder to your Steam Deck"
    echo "2. Run 'heroic_lsfg_applier' inside that folder"
    echo "   (or use the scripts/install_local.sh script on the Deck)"
    echo ""
else
    echo -e "${RED}Build failed! Output directory not found.${NC}"
    exit 1
fi
