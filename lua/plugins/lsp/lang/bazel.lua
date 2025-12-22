return {
  packages = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          bzl = { "buildifier" },
        },
      },
    },
  },

  mason_packages = { "starpls", "buildifier" },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("starpls", {
        capabilities = capabilities,
        on_attach = custom_attach,
        filetypes = { "bzl", "BUILD" },
      })
    end,
  },
}
