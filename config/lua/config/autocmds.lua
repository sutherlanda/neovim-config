-- lua/config/autocmds.lua
-- Autocommands

-- Run ctags on save
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		vim.fn.system("which ctags &> /dev/null && ctags -R . || exit 0")
	end,
})

-- Set file types for GLSL
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.vs", "*.fs", "*.vert", "*.frag" },
	callback = function()
		vim.bo.filetype = "glsl"
	end,
})

-- Clipboard integration for Unix systems
if vim.fn.has("unix") == 1 then
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("Yank", { clear = true }),
		callback = function()
			local text = vim.fn.getreg('"')
			vim.fn.system("xclip -selection clipboard", text)
		end,
	})
end

-- Auto-reload files modified externally (essential for Claude Code)
-- Without this, you won't see Claude's edits until you manually :e each file
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("AutoReload", { clear = true }),
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- Shorten the idle time that triggers CursorHold (default is 4000ms, too slow)
-- This makes file reloads feel near-instant when Claude is writing
vim.o.updatetime = 500
