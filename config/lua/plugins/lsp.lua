-- lua/plugins/lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local opts = { noremap = true, silent = true }

			-- Diagnostic signs
			local signs = { Error = ">>", Warn = ">", Hint = "*", Info = "*" }
			for type, icon in pairs(signs) do
				local name = "DiagnosticSign" .. type
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			-- Customize diagnostic handling
			vim.diagnostic.config({
				virtual_text = false,
				underline = true,
				signs = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Helper functions for diagnostics
			function PrintDiagnostics(opts, bufnr, line_nr, client_id)
				opts = opts or {}
				bufnr = bufnr or 0
				line_nr = line_nr or (vim.api.nvim_win_get_cursor(bufnr)[1] - 1)

				local diagnostics = vim.diagnostic.get(bufnr, { lnum = line_nr })
				if vim.tbl_isempty(diagnostics) then
					return
				end

				local lines = {}
				for i, diagnostic in ipairs(diagnostics) do
					local str = diagnostic.message
					for s in str:gmatch("[^\r\n]+") do
						table.insert(lines, s)
					end
				end
				ShowInPreview(lines)
			end

			function ShowInPreview(lines)
				vim.cmd([[
          pclose
          keepalt new +setlocal\ previewwindow|setlocal\ buftype=nofile|setlocal\ noswapfile|setlocal\ wrap [Document]
          setl bufhidden=wipe
          setl nobuflisted
          setl nospell
          exe 'setl filetype=text'
          setl conceallevel=0
          setl nofoldenable
        ]])
				vim.api.nvim_buf_set_lines(0, 0, -1, 0, lines)
				vim.cmd('exe "normal! z" .' .. #lines .. '. "\\<cr>"')
				vim.cmd([[
          exe "normal! gg"
          wincmd p
        ]])
			end

			-- On attach function
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(mode, lhs, rhs, opts)
					vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
				end

				-- LSP keybindings
				buf_set_keymap("n", "<leader>ag", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				buf_set_keymap("n", "<leader>aG", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
				buf_set_keymap("n", "<leader>ar", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
				buf_set_keymap("n", "<leader>ah", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				buf_set_keymap("n", "<leader>an", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				buf_set_keymap("n", "<C-j>", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>", opts)
				buf_set_keymap("n", "<C-k>", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>", opts)
				buf_set_keymap("n", "<leader>ak", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
				buf_set_keymap("n", "<leader>ad", "<cmd>lua PrintDiagnostics()<CR>", opts)
				buf_set_keymap("n", "<leader>af", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
			end

			-- Capabilities
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Default configuration for all servers
			local default_config = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- rust-analyzer configuration
			vim.lsp.config("rust_analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml" },
				settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
						cargo = {
							allFeatures = true,
						},
						procMacro = {
							enable = true,
						},
					},
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- haskell-language-server configuration
			vim.lsp.config("hls", {
				cmd = { "haskell-language-server-wrapper", "--lsp" },
				filetypes = { "haskell", "lhaskell" },
				root_markers = { "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml" },
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- bash-language-server configuration
			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh" },
				root_markers = { ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- gopls configuration
			vim.lsp.config("gopls", {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- pyright configuration
			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git",
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- typescript-language-server configuration
			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
				init_options = {
					preferences = {
						disableSuggestions = true,
					},
				},
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
			})

			-- jdtls configuration
			vim.lsp.config("jdtls", {
				cmd = { "jdtls" },
				filetypes = { "java" },
				root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Enable all configured LSP servers
			vim.lsp.enable({ "rust_analyzer", "hls", "bashls", "gopls", "pyright", "ts_ls", "jdtls" })
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				debug = true,
				sources = {
					require("none-ls.diagnostics.eslint_d"),
				},
			})
		end,
	},
}
