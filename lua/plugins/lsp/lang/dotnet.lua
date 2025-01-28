return {
  packages = {
    {
      "GustavEikaas/easy-dotnet.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
      config = function()
        require("easy-dotnet").setup()
      end,
    },
    { "https://github.com/Decodetalkers/csharpls-extended-lsp.nvim" },
  },

  mason_packages = { "csharp-language-server" },

  nonls_packages = {},

  lsp_config = {

    function(lspconfig, capabilities, custom_attach)
      lspconfig.csharp_ls.setup({
        capabilities = capabilities,
        on_attach = custom_attach,
        handlers = {
          ["textDocument/definition"] = require("csharpls_extended").handler,
          ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
        },
      })
    end,
  },
}
