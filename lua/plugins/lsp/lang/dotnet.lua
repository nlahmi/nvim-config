return {
  -- Rarely used: skips plugin + mason installs (csharp-language-server).
  -- The LSP config below is still registered, so installing the mason
  -- package is enough to make it work again. Flip to true to restore fully.
  enabled = false,

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

  servers = { "csharp_ls" },

  mason_packages = { "csharp-language-server" },

  nonls_packages = {},

  lsp_config = {

    function(capabilities, custom_attach)
      -- csharpls_extended ships with a plugin that is not installed while this
      -- language is disabled; go without its goto-definition handlers then.
      local ok, extended = pcall(require, "csharpls_extended")

      vim.lsp.config("csharp_ls", {
        capabilities = capabilities,
        on_attach = custom_attach,
        handlers = ok and {
          ["textDocument/definition"] = extended.handler,
          ["textDocument/typeDefinition"] = extended.handler,
        } or nil,
      })
    end,
  },
}
