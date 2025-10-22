#!/usr/bin/env bash

# Neovim Configuration Installation Script
# This script installs Neovim config from the current directory

set -e  # Exit on error

echo "🚀 Neovim Configuration Installer"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/config"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}❌ Neovim is not installed!${NC}"
    echo "Please install Neovim first."
    echo "Visit: https://github.com/neovim/neovim/releases"
    exit 1
fi

echo -e "${GREEN}✓ Neovim found: $(nvim --version | head -n1)${NC}"
echo ""

# Check if config files exist in repo
if [ ! -d "$CONFIG_SOURCE" ]; then
    echo -e "${RED}❌ Config directory not found: $CONFIG_SOURCE${NC}"
    echo "Make sure you're running this script from the repository root."
    echo ""
    echo "Expected structure:"
    echo "  your-repo/"
    echo "  ├── install.sh"
    echo "  └── config/"
    echo "      ├── init.lua"
    echo "      └── lua/..."
    exit 1
fi

echo -e "${GREEN}✓ Config source found: $CONFIG_SOURCE${NC}"
echo ""

# Backup existing configuration
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}⚠ Existing Neovim configuration found${NC}"
    read -p "Do you want to backup your existing config? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Backing up to: $BACKUP_DIR"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        echo -e "${GREEN}✓ Backup complete${NC}"
    else
        echo "⚠ Removing existing configuration..."
        rm -rf "$NVIM_CONFIG_DIR"
    fi
    echo ""
fi

# Copy configuration files
echo "📁 Copying configuration files..."
cp -r "$CONFIG_SOURCE" "$NVIM_CONFIG_DIR"
echo -e "${GREEN}✓ Configuration files copied${NC}"
echo ""

# Verify structure
echo "📋 Verifying installation..."
if [ -f "$NVIM_CONFIG_DIR/init.lua" ] && \
   [ -d "$NVIM_CONFIG_DIR/lua/config" ] && \
   [ -d "$NVIM_CONFIG_DIR/lua/plugins" ]; then
    echo -e "${GREEN}✓ All files installed correctly${NC}"
else
    echo -e "${RED}❌ Installation verification failed${NC}"
    echo "Expected files not found. Check your config/ directory structure."
    exit 1
fi
echo ""

# Launch Neovim to install plugins
echo "🎉 Installation complete!"
echo ""
echo "Configuration installed to: $NVIM_CONFIG_DIR"
echo ""
echo "Next steps:"
echo "1. Launch Neovim: nvim"
echo "2. Lazy.nvim will automatically install all plugins"
echo "3. Wait for all plugins to install (this may take a minute)"
echo "4. Run :checkhealth to verify everything is working"
echo ""
echo "Optional: Install external tools for full functionality"
echo "  - Language servers (rust-analyzer, pyright, etc.)"
echo "  - Formatters (stylua, autopep8, prettierd, etc.)"
echo "  - ripgrep or ag for better search"
echo ""
read -p "Would you like to launch Neovim now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nvim
fi
