#!/usr/bin/env bash

# Neovim Update Script
# Updates Neovim to the latest nightly build

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "🚀 Neovim Updater"
echo "================="
echo ""

# Detect OS and architecture
OS="unknown"
ARCH="unknown"

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    if [[ $(uname -m) == "arm64" ]]; then
        ARCH="arm64"
    else
        ARCH="x86_64"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    ARCH=$(uname -m)
fi

echo -e "${GREEN}Detected: $OS $ARCH${NC}"
echo ""

# Show current version
if command -v nvim &> /dev/null; then
    echo "Current version:"
    nvim --version | head -n1
    echo ""
fi

# Confirm update
read -p "Update to latest nightly? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Update cancelled."
    exit 0
fi
echo ""

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📥 Downloading latest nightly..."

if [ "$OS" = "macos" ]; then
    if [ "$ARCH" = "arm64" ]; then
        URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"
        FILENAME="nvim-macos-arm64.tar.gz"
        DIRNAME="nvim-macos-arm64"
    else
        URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz"
        FILENAME="nvim-macos-x86_64.tar.gz"
        DIRNAME="nvim-macos-x86_64"
    fi
elif [ "$OS" = "linux" ]; then
    URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"
    FILENAME="nvim-linux64.tar.gz"
    DIRNAME="nvim-linux64"
else
    echo -e "${RED}Unsupported OS${NC}"
    exit 1
fi

curl -LO "$URL"
tar xzf "$FILENAME"

echo -e "${GREEN}✓ Downloaded${NC}"
echo ""

# Backup old installation
if [ -d "/usr/local/nvim" ]; then
    echo "📦 Backing up old installation..."
    sudo mv /usr/local/nvim "/usr/local/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓ Backup complete${NC}"
    echo ""
fi

# Install new version
echo "📦 Installing new version..."
sudo mv "$DIRNAME" /usr/local/nvim

# Ensure symlink exists
if [ -L "/usr/local/bin/nvim" ]; then
    sudo rm /usr/local/bin/nvim
fi
sudo ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim

echo -e "${GREEN}✓ Installation complete${NC}"
echo ""

# Cleanup
cd ~
rm -rf "$TEMP_DIR"

# Show new version
echo "New version:"
nvim --version | head -n1
echo ""

echo "🎉 Update complete!"
echo ""
echo "Note: You may need to update plugins if there are breaking changes."
echo "Run: nvim +Lazy sync +qa"
