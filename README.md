# Neovim Configuration

A modern, maintainable Neovim configuration migrated from Nix flakes to a standard Lazy.nvim setup.

## 📁 Directory Structure

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua      # Editor settings
│   │   ├── keymaps.lua      # Global keybindings
│   │   └── autocmds.lua     # Autocommands
│   └── plugins/
│       ├── colorscheme.lua  # Color themes
│       ├── treesitter.lua   # Syntax highlighting
│       ├── lsp.lua          # Language servers
│       ├── completion.lua   # Autocompletion
│       ├── formatting.lua   # Code formatting
│       ├── telescope.lua    # Fuzzy finder
│       ├── ui.lua           # UI plugins
│       ├── git.lua          # Git integration
│       └── misc.lua         # Miscellaneous plugins
```

## 🚀 Installation

### 1. Backup existing config

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

### 2. Create directory structure

```bash
mkdir -p ~/.config/nvim/lua/{config,plugins}
```

### 3. Copy configuration files

Place each file in its corresponding location according to the directory structure above.

### 4. Install required external tools

The configuration expects these tools to be available in your PATH:

#### Language Servers
```bash
# Rust
rustup component add rust-analyzer

# Haskell
cabal install haskell-language-server

# Bash
npm install -g bash-language-server

# Go
go install golang.org/x/tools/gopls@latest

# Python
pip install autopep8

# JavaScript/TypeScript
npm install -g eslint_d @fsouza/prettierd

# Nix
nix-env -iA nixpkgs.alejandra

# Rust (already included with rustup)
rustup component add rustfmt
```

#### Optional Tools
```bash
# Silver Searcher (for better grep)
# Ubuntu/Debian: sudo apt install silversearcher-ag
# macOS: brew install the_silver_searcher
# Arch: sudo pacman -S the_silver_searcher

# xclip (for clipboard on Linux)
# Ubuntu/Debian: sudo apt install xclip
# Arch: sudo pacman -S xclip

# ctags (for code navigation)
# Ubuntu/Debian: sudo apt install universal-ctags
# macOS: brew install universal-ctags
# Arch: sudo pacman -S ctags

# jq (for JSON formatting)
# Ubuntu/Debian: sudo apt install jq
# macOS: brew install jq
# Arch: sudo pacman -S jq

# fd (optional, improves telescope performance)
# Ubuntu/Debian: sudo apt install fd-find
# macOS: brew install fd
# Arch: sudo pacman -S fd

# ripgrep (optional, improves telescope performance)
# Ubuntu/Debian: sudo apt install ripgrep
# macOS: brew install ripgrep
# Arch: sudo pacman -S ripgrep
```

### 5. Launch Neovim

```bash
nvim
```

On first launch, Lazy.nvim will automatically:
1. Clone itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Install all configured plugins
3. Set up treesitter parsers

## ⌨️ Key Mappings

Leader key: `,`

### General
- `<leader>h` - Clear search highlighting
- `<leader>n` - Toggle line numbers
- `<leader><leader>` - Switch to last buffer
- `<leader>j` - Format JSON with jq
- `<leader>pc` - Close preview window
- `<leader>f` - Set filetype (prompts for input)

### File Navigation (Telescope)
- `<C-p>` - Find files
- `<C-\>` - Live grep (search in files)
- `<leader>b` - List buffers

### File Tree (nvim-tree)
- `<leader>tt` - Toggle file tree
- `<leader>tf` - Focus file tree

### LSP (Language Server)
- `<leader>ag` - Go to definition
- `<leader>aG` - Go to declaration
- `<leader>ar` - Find references
- `<leader>ah` - Show hover information
- `<leader>an` - Rename symbol
- `<leader>af` - Format buffer
- `<leader>ak` - Show line diagnostics
- `<leader>ad` - Show diagnostics in preview window
- `<C-j>` - Go to next diagnostic
- `<C-k>` - Go to previous diagnostic

### Location List
- `<leader>lo` - Open location list
- `<leader>lc` - Close location list
- `<leader>lp` - Previous item
- `<leader>ln` - Next item

### Quickfix List
- `<leader>qo` - Open quickfix list
- `<leader>qc` - Close quickfix list
- `<leader>qp` - Previous item
- `<leader>qn` - Next item

### Git
- `<leader>gb` - Toggle git blame for current line

### Completion (Insert Mode)
- `<C-n>` - Next completion item
- `<C-p>` - Previous completion item
- `<C-d>` - Scroll docs down
- `<C-f>` - Scroll docs up
- `<C-e>` - Close completion menu
- `<CR>` - Confirm selection

## 🎨 Themes

Three themes are included:
- **Gruvbox** (default)
- Tokyo Night
- Nightfox

To change themes, edit `lua/plugins/colorscheme.lua` and change the colorscheme in the config function.

## 🔧 Customization

### Adding a new plugin

Create or edit a file in `lua/plugins/` and add:

```lua
return {
  {
    "username/plugin-name",
    event = "VeryLazy",  -- or other lazy-loading trigger
    config = function()
      -- Plugin configuration here
    end,
  },
}
```

### Changing settings

Edit `lua/config/options.lua` to modify editor settings.

### Adding keybindings

Edit `lua/config/keymaps.lua` for global keybindings, or add them to specific plugin configs in `lua/plugins/`.

### Modifying LSP servers

Edit `lua/plugins/lsp.lua` to add, remove, or configure language servers.

### Changing formatters

Edit `lua/plugins/formatting.lua` to modify the formatters for each filetype.

## 📦 Plugin Management

### Update plugins
```vim
:Lazy update
```

### View plugin status
```vim
:Lazy
```

### Clean unused plugins
```vim
:Lazy clean
```

### Check plugin health
```vim
:checkhealth
```

## 🐛 Troubleshooting

### Plugins not loading
1. Run `:Lazy` to check plugin status
2. Run `:Lazy sync` to reinstall plugins
3. Check for errors with `:messages`

### LSP not working
1. Verify language server is installed: `:LspInfo`
2. Check if language server is in PATH: `:!which <server-name>`
3. Check LSP logs: `~/.local/state/nvim/lsp.log`

### Treesitter errors
1. Update parsers: `:TSUpdate`
2. Check installed parsers: `:TSInstallInfo`
3. Reinstall specific parser: `:TSInstall <language>`

### Format on save not working
1. Check if formatter is installed: `:ConformInfo`
2. Verify formatter is in PATH
3. Check configuration in `lua/plugins/formatting.lua`

## 🔄 Migration Notes from Nix

Key differences from your Nix setup:

1. **Plugin management**: Lazy.nvim handles plugins instead of Nix flake inputs
2. **Lazy loading**: Plugins load on-demand for faster startup
3. **Modular structure**: Each feature is in its own file for easier maintenance
4. **Standard paths**: Uses standard XDG directories instead of Nix store
5. **Easy updates**: Update plugins with `:Lazy update` instead of `nix flake update`

## 📚 Additional Resources

- [Lazy.nvim documentation](https://github.com/folke/lazy.nvim)
- [Neovim documentation](https://neovim.io/doc/)
- [LSP configuration guide](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Conform.nvim formatters](https://github.com/stevearc/conform.nvim#formatters)

## 🔄 Updating

### Quick Updates

```bash
# Update all plugins
make update-plugins

# Update Neovim to latest nightly
make update-nvim

# Update everything
make update-all

# Check all tool versions
bash check-versions.sh
```

### Manual Plugin Updates

```bash
# Inside Neovim
:Lazy update

# Or headless
nvim --headless "+Lazy! sync" +qa
```

### Available Make Commands

- `make install` - Install/reinstall configuration
- `make update-plugins` - Update all plugins
- `make update-nvim` - Update Neovim to latest nightly
- `make update-all` - Update both Neovim and plugins
- `make clean` - Clean plugin cache (force reinstall)
- `make health` - Run Neovim health check
- `make lsp-status` - Check LSP server installations
- `make backup` - Backup current configuration
- `make restore BACKUP=file.tar.gz` - Restore from backup

## 💡 Tips

1. Run `make update-all` monthly to keep everything current
2. Use `:Lazy profile` to check plugin load times
3. Use `:checkhealth` regularly to verify your setup
4. Run `bash check-versions.sh` to see what's installed
5. Always backup before major updates: `make backup`
6. Commit your config to a git repository for easy syncing across machines
pip install pyright

# TypeScript/JavaScript
npm install -g typescript typescript-language-server

# Java
# Install from: https://github.com/eclipse-jdtls/eclipse.jdt.ls
```

#### Formatters
```bash
# Lua
cargo install stylua

# Python
