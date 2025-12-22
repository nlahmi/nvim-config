return {
  packages = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          awk = { "gawk" },
        },
      },
    },
  },

  mason_packages = {
    "awk-language-server",
  },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("awk_ls", { on_attach = custom_attach, capabilities = capabilities })
    end,
  },

  dap_config = {},
}
