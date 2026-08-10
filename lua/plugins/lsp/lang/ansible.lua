return {
  packages = { { "https://github.com/mfussenegger/nvim-ansible" } },

  servers = { "ansiblels" },

  mason_packages = { "ansible-language-server", "ansible-lint" },

  nonls_packages = {},

  lsp_config = {
    function(capabilities, custom_attach)
      vim.lsp.config("ansiblels", {
        capabilities = capabilities,
        on_attach = custom_attach,
      })
    end,
  },
}
