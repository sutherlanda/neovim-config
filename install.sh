#!/usr/bin/env bash

# Neovim Configuration Installation Script
# This script installs Neovim and configuration files

set -e  # Exit on error

echo "🚀 Neovim Configuration Installer"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/config"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

# Detect OS
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

echo -e "${BLUE}Detected OS: $OS $ARCH${NC}"
echo ""

# Function to install Neovim
install_neovim() {
    echo ""
    echo "🔧 Neovim Installation"
    echo "======================"
    echo ""
    
    read -p "Would you like to install the latest Neovim nightly? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping Neovim installation. Please install it manually.${NC}"
        echo "Visit: https://github.com/neovim/neovim/releases"
        exit 1
    fi
    echo ""
    
    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    echo "📥 Downloading Neovim nightly..."
    
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
    
    # Backup old installation if it exists
    if [ -d "/usr/local/nvim" ]; then
        echo "📦 Backing up old Neovim installation..."
        sudo mv /usr/local/nvim "/usr/local/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}✓ Backup complete${NC}"
        echo ""
    fi
    
    # Install new version
    echo "📦 Installing Neovim..."
    sudo mv "$DIRNAME" /usr/local/nvim
    
    # Create symlink
    if [ -L "/usr/local/bin/nvim" ]; then
        sudo rm /usr/local/bin/nvim
    fi
    sudo ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim
    
    echo -e "${GREEN}✓ Neovim installed${NC}"
    echo ""
    
    # Cleanup
    cd ~
    rm -rf "$TEMP_DIR"
    
    # Show version
    echo "Installed version:"
    nvim --version | head -n1
    echo ""
}

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${YELLOW}⚠ Neovim is not installed${NC}"
    install_neovim
else
    echo -e "${GREEN}✓ Neovim found: $(nvim --version | head -n1)${NC}"
    echo ""
    
    read -p "Neovim is already installed. Update to latest nightly? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_neovim
    fi
fi

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
echo "📋 External tools needed (install separately):"
echo ""
echo "Language Servers:"
echo "  • rust-analyzer     - Rust"
echo "  • pyright          - Python (via pipx)"
echo "  • gopls            - Go"
echo "  • typescript-ls    - TypeScript/JavaScript (via npm)"
echo "  • bash-ls          - Bash (via npm)"
echo ""
echo "Formatters:"
echo "  • stylua           - Lua (via cargo)"
echo "  • autopep8         - Python (via pipx)"
echo "  • prettierd        - JS/TS/JSON (via npm)"
echo "  • eslint_d         - JS/TS (via npm)"
echo "  • rustfmt          - Rust (via rustup)"
echo ""
echo "Optional Tools:"
echo "  • ripgrep or ag    - Better search"
echo "  • fd               - Better find"
echo "  • jq               - JSON formatting"
echo ""
echo "See README.md for installation instructions."
echo ""
read -p "Would you like to launch Neovim now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nvim
fi
