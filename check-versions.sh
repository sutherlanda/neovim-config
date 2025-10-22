#!/usr/bin/env bash

# Check versions of all tools

echo "🔍 Neovim Environment Status"
echo "============================="
echo ""

# Neovim version
echo "Neovim:"
if command -v nvim &> /dev/null; then
    nvim --version | head -n1
else
    echo "  ✗ Not installed"
fi
echo ""

# Language Servers
echo "Language Servers:"
echo -n "  rust-analyzer: "
if command -v rust-analyzer &> /dev/null; then
    rust-analyzer --version 2>&1 | head -n1
else
    echo "✗ Not installed"
fi

echo -n "  pyright: "
if command -v pyright &> /dev/null; then
    pyright --version 2>&1 | head -n1
else
    echo "✗ Not installed"
fi

echo -n "  gopls: "
if command -v gopls &> /dev/null; then
    gopls version 2>&1 | head -n1
else
    echo "✗ Not installed"
fi

echo -n "  typescript-language-server: "
if command -v typescript-language-server &> /dev/null; then
    typescript-language-server --version 2>&1
else
    echo "✗ Not installed"
fi

echo -n "  bash-language-server: "
if command -v bash-language-server &> /dev/null; then
    bash-language-server --version 2>&1
else
    echo "✗ Not installed"
fi

echo -n "  haskell-language-server: "
if command -v haskell-language-server-wrapper &> /dev/null; then
    haskell-language-server-wrapper --version 2>&1 | head -n1
else
    echo "✗ Not installed"
fi

echo ""

# Formatters
echo "Formatters:"
echo -n "  stylua: "
if command -v stylua &> /dev/null; then
    stylua --version
else
    echo "✗ Not installed"
fi

echo -n "  autopep8: "
if command -v autopep8 &> /dev/null; then
    autopep8 --version
else
    echo "✗ Not installed"
fi

echo -n "  prettierd: "
if command -v prettierd &> /dev/null; then
    prettierd --version
else
    echo "✗ Not installed"
fi

echo -n "  eslint_d: "
if command -v eslint_d &> /dev/null; then
    eslint_d --version
else
    echo "✗ Not installed"
fi

echo -n "  rustfmt: "
if command -v rustfmt &> /dev/null; then
    rustfmt --version
else
    echo "✗ Not installed"
fi

echo -n "  alejandra: "
if command -v alejandra &> /dev/null; then
    alejandra --version 2>&1 | head -n1
else
    echo "✗ Not installed"
fi

echo ""

# Optional tools
echo "Optional Tools:"
echo -n "  ripgrep: "
if command -v rg &> /dev/null; then
    rg --version | head -n1
else
    echo "✗ Not installed"
fi

echo -n "  fd: "
if command -v fd &> /dev/null; then
    fd --version
else
    echo "✗ Not installed"
fi

echo -n "  ag: "
if command -v ag &> /dev/null; then
    ag --version | head -n1
else
    echo "✗ Not installed"
fi

echo -n "  jq: "
if command -v jq &> /dev/null; then
    jq --version
else
    echo "✗ Not installed"
fi

echo ""

# Plugin count
echo "Neovim Plugins:"
if [ -d "$HOME/.local/share/nvim/lazy" ]; then
    PLUGIN_COUNT=$(ls -1 "$HOME/.local/share/nvim/lazy" | wc -l)
    echo "  $PLUGIN_COUNT plugins installed"
else
    echo "  ✗ No plugins installed"
fi

echo ""
