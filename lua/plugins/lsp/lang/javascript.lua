return {
  packages = {},

  mason_packages = {
    "vtsls",
  },

  nonls_packages = {},

  lsp_config = {
    function(lspconfig, capabilities, custom_attach)
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        on_attach = custom_attach,
      })
    end,
  },
}
