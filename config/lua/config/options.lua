-- lua/config/options.lua
-- Core editor settings

-- Enable filetype detection explicitly
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

vim.opt.incsearch = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.hidden = true
vim.opt.updatetime = 300
vim.opt.hlsearch = true
vim.opt.foldenable = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menuone,noselect,noinsert"

-- Wildignore patterns
vim.opt.wildignore:append({
	"*.so",
	"*.swp",
	"*.zip",
	"*.hi",
	"*.o",
	"*/node_modules/*",
	"*/dist/*",
	"*/.dist/*",
	"*/build/*",
	"*/.build/*",
	"*/Godeps/*",
	"*/elm-stuff/*",
	"*/.gem/*",
	"*/.git/*",
	"*/tmp/*",
})

-- Disable providers
vim.g.loaded_ruby_provider = 0

-- Enable syntax
vim.cmd("syntax on")

-- Silver searcher for grep if available
if vim.fn.executable("ag") == 1 then
	vim.opt.grepprg = "ag --vimgrep"
end
