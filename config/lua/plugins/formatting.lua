-- lua/plugins/formatting.lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "autopep8" },
          javascript = { "eslint_d", "prettierd" },
          typescript = { "eslint_d", "prettierd" },
          typescriptreact = { "eslint_d", "prettierd" },
          javascriptreact = { "eslint_d", "prettierd" },
          json = { "prettierd" },
          nix = { "alejandra" },
          rust = { "rustfmt" },
        },
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 3000,
        },
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
  },
}
