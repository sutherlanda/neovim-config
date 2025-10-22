-- lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzy-native.nvim",
        build = "make",
      },
    },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<C-\\>", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        extensions = {
          fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
          },
        },
      })
      
      telescope.load_extension("fzy_native")
    end,
  },
}
