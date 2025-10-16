return {
  packages = {},

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
