return {
  packages = { { "https://github.com/mfussenegger/nvim-ansible" } },

  mason_packages = { "ansible-language-server", "ansible-lint" },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("ansiblels", {
        capabilities = capabilities,
        on_attach = custom_attach,
      })
    end,
  },
}
