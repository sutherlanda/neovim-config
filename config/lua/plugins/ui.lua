-- lua/plugins/ui.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "gruvbox",
        },
        sections = {
          lualine_c = {
            {
              "filename",
              file_status = true,
              path = 2,
            },
          },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
            },
          },
        },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Tree" },
      { "<leader>tf", "<cmd>NvimTreeFocus<cr>", desc = "Focus File Tree" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({})
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
