# Heroic LSFG Applier - Makefile
# Common commands for development and building

.PHONY: help run build-linux setup-test verify-test clean analyze gen install

# Default target
help:
	@echo "🎮 Heroic LSFG Applier - Available Commands"
	@echo "==========================================="
	@echo ""
	@echo "Development:"
	@echo "  make run          - Run the app on macOS"
	@echo "  make analyze      - Run Flutter analyzer"
	@echo "  make gen          - Generate freezed/json_serializable code"
	@echo ""
	@echo "Testing (macOS):"
	@echo "  make setup-test   - Create test environment in ~/HeroicTest"
	@echo "  make verify-test  - Check if LSFG was applied to test shortcuts"
	@echo ""
	@echo "Building:"
	@echo "  make build-linux  - Build Linux release using Docker (M-chip compatible)"
	@echo ""
	@echo "Installation (Steam Deck/Linux):"
	@echo "  make install      - Install app locally (run after build or from release)"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean        - Clean build artifacts"

# Run the app on macOS
run:
	flutter run -d macos

# Run Flutter analyzer
analyze:
	flutter analyze

# Generate code (freezed, json_serializable)
gen:
	dart run build_runner build --delete-conflicting-outputs

# Setup macOS test environment
setup-test:
	@echo "🔧 Setting up test environment..."
	dart run scripts/setup_macos_test.dart

# Verify OGI test (check shortcuts.vdf)
verify-test:
	@echo "🔍 Verifying shortcuts.vdf..."
	dart run scripts/verify_ogi_test.dart

# Build Linux release using Docker
build-linux:
	@echo "🐧 Building Linux release..."
	./build_linux_on_mac.sh

# Install app locally (for Steam Deck/Linux)
install:
	@echo "📦 Installing app locally..."
	./scripts/install_local.sh

# Clean build artifacts
clean:
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/
	@echo "✅ Cleaned!"
