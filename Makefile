.PHONY: install update-plugins update-nvim update-all clean health backup restore

# Install configuration
install:
	@echo "Installing Neovim configuration..."
	@bash install.sh

# Update all plugins
update-plugins:
	@echo "Updating plugins..."
	@nvim --headless "+Lazy! sync" +qa
	@echo "✓ Plugins updated"

# Update Neovim itself
update-nvim:
	@echo "Updating Neovim..."
	@bash update-nvim.sh

# Update everything (Neovim + plugins)
update-all: update-nvim update-plugins
	@echo "✓ Everything updated!"

# Clean plugin cache and reinstall
clean:
	@echo "Cleaning plugin cache..."
	@rm -rf ~/.local/share/nvim/lazy
	@rm -rf ~/.local/state/nvim
	@echo "✓ Cache cleaned. Restart nvim to reinstall plugins."

# Run health check
health:
	@echo "Running health check..."
	@nvim --headless "+checkhealth" +qa 2>&1 | grep -E "(ERROR|WARNING|OK)" || true

# Check LSP server status
lsp-status:
	@echo "Checking LSP servers..."
	@echo "Checking for rust-analyzer..." && which rust-analyzer || echo "  ✗ Not found"
	@echo "Checking for pyright..." && which pyright || echo "  ✗ Not found"
	@echo "Checking for gopls..." && which gopls || echo "  ✗ Not found"
	@echo "Checking for typescript-language-server..." && which typescript-language-server || echo "  ✗ Not found"
	@echo "Checking for bash-language-server..." && which bash-language-server || echo "  ✗ Not found"

# Backup current configuration
backup:
	@echo "Backing up configuration..."
	@tar -czf nvim-config-backup-$$(date +%Y%m%d_%H%M%S).tar.gz -C $(HOME)/.config nvim
	@echo "✓ Backup saved"

# Restore from backup (use: make restore BACKUP=filename.tar.gz)
restore:
	@if [ -z "$(BACKUP)" ]; then \
		echo "Usage: make restore BACKUP=filename.tar.gz"; \
		exit 1; \
	fi
	@echo "Restoring from $(BACKUP)..."
	@tar -xzf $(BACKUP) -C $(HOME)/.config
	@echo "✓ Restored"

# Show help
help:
	@echo "Neovim Configuration Management"
	@echo "==============================="
	@echo ""
	@echo "Available commands:"
	@echo "  make install        - Install/reinstall configuration"
	@echo "  make update-plugins - Update all plugins"
	@echo "  make update-nvim    - Update Neovim to latest nightly"
	@echo "  make update-all     - Update both Neovim and plugins"
	@echo "  make clean          - Clean plugin cache (force reinstall)"
	@echo "  make health         - Run Neovim health check"
	@echo "  make lsp-status     - Check LSP server installations"
	@echo "  make backup         - Backup current configuration"
	@echo "  make restore        - Restore from backup"
	@echo ""
