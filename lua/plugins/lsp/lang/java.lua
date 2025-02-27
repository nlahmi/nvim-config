return {
  packages = {
    {
      "mfussenegger/nvim-jdtls",
      dependencies = { "folke/which-key.nvim" },
      keys = {
        -- { "<leader>ca", vim.lsp.buf.code_action, desc = "LSP Code Action" },
        { "<leader>rg", "<cmd>!gradle build<cr>", desc = "Build (Gradle)" },
      },
      ft = { "java" },
    },
  },

  mason_packages = {
    "java-test",
    "java-debug-adapter",
    "jdtls",
  },

  nonls_packages = {},

  lsp_config = {
    function(lspconfig, capabilities, custom_attach)
      lspconfig.jdtls.setup({
        on_attach = custom_attach,
        capabilities = capabilities,
      })
    end,
  },
}
