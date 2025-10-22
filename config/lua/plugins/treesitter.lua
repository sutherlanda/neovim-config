-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "lua",
          "nix",
          "bash",
          "cpp",
          "json",
          "python",
          "markdown",
          "rust",
          "go",
          "javascript",
          "typescript",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
      
      -- Disable vimdoc parser if it causes issues
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.vimdoc = nil
    end,
  },
  {
    "LnL7/vim-nix",
    ft = "nix",
  },
}
