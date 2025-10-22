#!/usr/bin/env bash

# Neovim Configuration Installation Script
# This script installs Neovim, config, and all required tooling

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

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install npm packages globally
install_npm_global() {
    if command_exists npm; then
        echo "📦 Installing npm packages..."
        npm install -g \
            bash-language-server \
            typescript \
            typescript-language-server \
            eslint_d \
            @fsouza/prettierd
        echo -e "${GREEN}✓ npm packages installed${NC}"
    else
        echo -e "${YELLOW}⚠ npm not found. Skipping npm packages.${NC}"
        echo "  Install Node.js to get: bash-language-server, typescript-language-server, eslint_d, prettierd"
    fi
}

# Function to install Python packages
install_python_packages() {
    if command_exists pip3; then
        echo "📦 Installing Python packages..."
        pip3 install --user pyright autopep8
        echo -e "${GREEN}✓ Python packages installed${NC}"
    elif command_exists pip; then
        echo "📦 Installing Python packages..."
        pip install --user pyright autopep8
        echo -e "${GREEN}✓ Python packages installed${NC}"
    else
        echo -e "${YELLOW}⚠ pip not found. Skipping Python packages.${NC}"
        echo "  Install Python to get: pyright, autopep8"
    fi
}

# Function to install Rust tools
install_rust_tools() {
    if command_exists cargo; then
        echo "📦 Installing Rust tools..."
        cargo install stylua
        
        # Check if rust-analyzer is available via rustup
        if command_exists rustup; then
            echo "📦 Installing rust-analyzer..."
            rustup component add rust-analyzer rustfmt clippy
        fi
        echo -e "${GREEN}✓ Rust tools installed${NC}"
    else
        echo -e "${YELLOW}⚠ Cargo not found. Skipping Rust tools.${NC}"
        echo "  Install Rust to get: stylua, rust-analyzer, rustfmt"
    fi
}

# Function to install Go tools
install_go_tools() {
    if command_exists go; then
        echo "📦 Installing Go tools..."
        go install golang.org/x/tools/gopls@latest
        echo -e "${GREEN}✓ Go tools installed${NC}"
    else
        echo -e "${YELLOW}⚠ Go not found. Skipping gopls.${NC}"
        echo "  Install Go to get: gopls"
    fi
}

# Function to install system packages on macOS
install_macos_packages() {
    if command_exists brew; then
        echo "📦 Installing macOS packages via Homebrew..."
        
        # Optional but useful tools
        local optional_tools=()
        
        ! command_exists ag && optional_tools+=(the_silver_searcher)
        ! command_exists rg && optional_tools+=(ripgrep)
        ! command_exists fd && optional_tools+=(fd)
        ! command_exists jq && optional_tools+=(jq)
        ! command_exists ctags && optional_tools+=(universal-ctags)
        
        if [ ${#optional_tools[@]} -gt 0 ]; then
            echo "Installing optional tools: ${optional_tools[*]}"
            brew install "${optional_tools[@]}"
        fi
        
        echo -e "${GREEN}✓ macOS packages installed${NC}"
    else
        echo -e "${YELLOW}⚠ Homebrew not found. Skipping system packages.${NC}"
        echo "  Install Homebrew to get optional tools: ripgrep, fd, jq, ctags, etc."
    fi
}

# Function to install system packages on Linux
install_linux_packages() {
    if command_exists apt-get; then
        echo "📦 Installing Linux packages via apt..."
        echo "This may require sudo password for system packages."
        
        local optional_tools=()
        
        ! command_exists ag && optional_tools+=(silversearcher-ag)
        ! command_exists rg && optional_tools+=(ripgrep)
        ! command_exists fd && optional_tools+=(fd-find)
        ! command_exists jq && optional_tools+=(jq)
        ! command_exists ctags && optional_tools+=(universal-ctags)
        ! command_exists xclip && optional_tools+=(xclip)
        
        if [ ${#optional_tools[@]} -gt 0 ]; then
            echo "Installing optional tools: ${optional_tools[*]}"
            sudo apt-get update
            sudo apt-get install -y "${optional_tools[@]}"
        fi
        
        echo -e "${GREEN}✓ Linux packages installed${NC}"
    elif command_exists pacman; then
        echo "📦 Installing Linux packages via pacman..."
        echo "This may require sudo password for system packages."
        
        local optional_tools=()
        
        ! command_exists ag && optional_tools+=(the_silver_searcher)
        ! command_exists rg && optional_tools+=(ripgrep)
        ! command_exists fd && optional_tools+=(fd)
        ! command_exists jq && optional_tools+=(jq)
        ! command_exists ctags && optional_tools+=(ctags)
        ! command_exists xclip && optional_tools+=(xclip)
        
        if [ ${#optional_tools[@]} -gt 0 ]; then
            echo "Installing optional tools: ${optional_tools[*]}"
            sudo pacman -Sy --noconfirm "${optional_tools[@]}"
        fi
        
        echo -e "${GREEN}✓ Linux packages installed${NC}"
    else
        echo -e "${YELLOW}⚠ No supported package manager found (apt/pacman).${NC}"
        echo "  You may need to manually install: ripgrep, fd, jq, ctags, xclip"
    fi
}

# Function to install Nix formatter
install_nix_tools() {
    if command_exists nix-env; then
        echo "📦 Installing Nix tools..."
        nix-env -iA nixpkgs.alejandra
        echo -e "${GREEN}✓ Nix tools installed${NC}"
    else
        echo -e "${YELLOW}⚠ Nix not found. Skipping alejandra formatter.${NC}"
        echo "  Install Nix to get: alejandra"
    fi
}

# Main installation function for tooling
install_tooling() {
    echo ""
    echo "🔧 Installing Language Servers and Formatters"
    echo "=============================================="
    echo ""
    
    read -p "Do you want to install all required tooling? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping tooling installation."
        return
    fi
    echo ""
    
    # Install language-specific tools
    install_npm_global
    echo ""
    install_python_packages
    echo ""
    install_rust_tools
    echo ""
    install_go_tools
    echo ""
    install_nix_tools
    echo ""
    
    # Install system packages
    if [ "$OS" = "macos" ]; then
        install_macos_packages
    elif [ "$OS" = "linux" ]; then
        install_linux_packages
    fi
    
    echo ""
    echo -e "${GREEN}✓ Tooling installation complete${NC}"
    echo ""
    
    # Summary of what still needs manual installation
    echo "📋 Manual Installation Required:"
    echo ""
    
    if ! command_exists haskell-language-server; then
        echo "  • Haskell Language Server (hls)"
        echo "    Install with: cabal install haskell-language-server"
        echo ""
    fi
    
    if ! command_exists jdtls && ! [ -d "$HOME/.local/share/eclipse.jdt.ls" ]; then
        echo "  • Java Language Server (jdtls)"
        echo "    Download from: https://github.com/eclipse-jdtls/eclipse.jdt.ls"
        echo ""
    fi
    
    echo "Run 'nvim' and then ':checkhealth' to verify all tools are working."
}

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

# Install tooling
install_tooling

# Launch Neovim to install plugins
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
echo "5. Run :LspInfo in a file to check language server status"
echo ""
read -p "Would you like to launch Neovim now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nvim
fi
