return {
  packages = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          javascript = { "prettierd", "prettier", stop_after_first = true },
        },
      },
    },
  },

  mason_packages = {
    "vtsls",
  },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        on_attach = custom_attach,
      })
    end,
  },
}
