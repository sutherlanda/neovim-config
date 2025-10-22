-- lua/config/keymaps.lua
-- Global keybindings

local opts = { noremap = true, silent = true }

-- Misc helpers
vim.keymap.set("n", "<leader>f", ":set filetype=", { noremap = true }) -- set filetype helper
vim.keymap.set("n", "<leader>h", "<cmd>nohl<CR>", opts) -- clear highlighted search
vim.keymap.set("n", "<leader>n", "<cmd>set invnumber invrelativenumber<CR>", opts) -- toggle line numbers
vim.keymap.set("n", "<leader><leader>", "<cmd>b#<CR>", opts) -- switch to last buffer
vim.keymap.set("n", "<leader>j", "<cmd>%!jq<CR>", opts) -- pretty format JSON
vim.keymap.set("n", "<leader>pc", "<cmd>pclose<CR>", opts) -- close preview window

-- Search (Telescope)
vim.keymap.set("", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("", "<C-\\>", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)

-- Nvim-tree
vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>", opts)
vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<CR>", opts)

-- Git signs
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", opts)

-- Location list
vim.keymap.set("n", "<leader>lo", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
vim.keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", opts)
vim.keymap.set("n", "<leader>lp", "<cmd>lprevious<CR>", opts)
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>", opts)

-- Quickfix window
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", opts)
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", opts)
vim.keymap.set("n", "<leader>qp", "<cmd>cprevious<CR>", opts)
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", opts)
