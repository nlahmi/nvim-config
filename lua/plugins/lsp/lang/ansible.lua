return {
  packages = { { "https://github.com/mfussenegger/nvim-ansible" } },

  mason_packages = {"ansible-language-server", "ansible-lint"},

  nonls_packages = {},

  lsp_config = {
    function(lspconfig, capabilities, custom_attach)
      lspconfig.ansiblels.setup({
        capabilities = capabilities,
        on_attach = custom_attach,
      })
    end,
  },
}
