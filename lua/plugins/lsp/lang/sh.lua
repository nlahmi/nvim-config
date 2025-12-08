return {
  packages = {},

  mason_packages = {
    "shfmt",
    "bash-language-server",
  },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("bashls", { on_attach = custom_attach, capabilities = capabilities })
    end,
  },
}
