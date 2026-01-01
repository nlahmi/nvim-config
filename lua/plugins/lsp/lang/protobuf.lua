return {
  packages = {},

  mason_packages = { "buf" },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("buf_ls", {
        on_attach = custom_attach,
        capabilities = capabilities,
      })
    end,
  },
}
