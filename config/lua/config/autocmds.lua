-- lua/config/autocmds.lua
-- Autocommands

-- Run ctags on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    vim.fn.system('which ctags &> /dev/null && ctags -R . || exit 0')
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
