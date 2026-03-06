# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

Configuration source files live in `config/` and are installed to `~/.config/nvim/` by the install script. The structure mirrors what Neovim expects:

```
config/
├── init.lua                    # Entry point: bootstraps lazy.nvim, loads core modules
└── lua/
    ├── config/
    │   ├── options.lua         # Editor settings
    │   ├── keymaps.lua         # Global keybindings (leader = ,)
    │   ├── autocmds.lua        # Autocommands (auto-reload, ctags, clipboard)
    │   └── theme-switcher.lua  # Telescope-based theme picker, persists to current_theme.lua
    └── plugins/                # One file per feature; each returns a lazy.nvim spec table
        ├── lsp.lua             # nvim-lspconfig + none-ls; all LSP keymaps defined here
        ├── completion.lua      # nvim-cmp
        ├── formatting.lua      # conform.nvim
        ├── telescope.lua       # Fuzzy finder
        ├── treesitter.lua      # Syntax/highlighting
        ├── colorschemes.lua    # Theme plugins (tokyonight, catppuccin, kanagawa, rose-pine, github)
        ├── git.lua             # gitsigns
        ├── ui.lua              # nvim-tree, lualine, etc.
        ├── obsidian.lua        # obsidian.nvim for note-taking
        ├── claude.lua          # claudecode.nvim integration
        └── misc.lua            # vim-surround, nerdcommenter, vim-rooter, snacks.nvim
```

## Common Commands

```bash
# Install config to ~/.config/nvim
make install          # or: bash install.sh

# Update plugins (headless)
make update-plugins   # or inside nvim: :Lazy update

# Update Neovim to latest nightly
make update-nvim

# Clean plugin cache (forces reinstall on next nvim launch)
make clean

# Check installed LSP servers
make lsp-status

# Run health check
make health

# Backup current config
make backup
```

Inside Neovim:
```
:Lazy          " Plugin manager UI
:Lazy sync     " Reinstall all plugins
:checkhealth   " Verify setup
:LspInfo       " Check active LSP servers
:ConformInfo   " Check active formatters
```

## Architecture Notes

**Plugin loading**: `init.lua` bootstraps lazy.nvim if absent, then calls `require("lazy").setup("plugins", ...)` which auto-discovers all files in `lua/plugins/`. Each plugin file returns a table (or table of tables) conforming to the lazy.nvim spec.

**LSP setup**: `lsp.lua` uses `vim.lsp.config()` + `vim.lsp.enable()` (Neovim 0.11+ API) rather than the older `lspconfig.server.setup()` pattern. All LSP keybindings (`<leader>a*`) are attached per-buffer via the shared `on_attach` function. TypeScript LSP has formatting disabled to defer to conform.nvim/prettierd. `none-ls` provides eslint_d diagnostics.

**Theme persistence**: The theme switcher writes the selected theme name to `lua/config/current_theme.lua` (gitignored), which is loaded by `colorschemes.lua` on startup.

**Auto-reload for Claude Code**: `autocmds.lua` sets `updatetime=500` and triggers `checktime` on `CursorHold`/`FocusGained` so Neovim picks up file changes written by Claude without manual `:e`.

## Key Bindings Reference

Leader key: `,`

| Key | Action |
|-----|--------|
| `,cc` | Toggle Claude Code terminal |
| `,cn` | Continue last Claude session |
| `,cs` (visual) | Send selection to Claude |
| `,cb` | Add buffer to Claude context |
| `,ca` / `,cd` | Accept / deny Claude diff |
| `,yr` / `,ya` / `,yl` | Copy relative path / absolute path / file:line ref |
| `<C-p>` | Telescope find files |
| `<C-\>` | Telescope live grep |
| `<leader>b` | Telescope buffers |
| `<leader>tt` / `<leader>tf` | Toggle / focus nvim-tree |
| `<leader>ag/aG/ar/ah/an/af/ak/ad` | LSP: def/decl/refs/hover/rename/format/diag-float/diag-preview |
| `<C-j>` / `<C-k>` | Next / previous diagnostic |
| `<leader>gb` | Toggle git blame |

## LSP Servers Configured

rust_analyzer, hls (Haskell), bashls, gopls, pyright, ts_ls (TypeScript), jdtls (Java)

External tools must be in PATH — see `make lsp-status` to check which are present.
