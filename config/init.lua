-- init.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Enable filetype detection FIRST, before anything else
vim.cmd("filetype on")
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Load core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins
require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

-- Re-enable filetype detection after plugins load (in case something disabled it)
vim.cmd("filetype on")
vim.cmd("filetype plugin indent on")
