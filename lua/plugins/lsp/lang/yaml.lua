return {
  packages = {
    { "ikatyang/tree-sitter-yaml" },
    { "b0o/SchemaStore.nvim" },
    {
      "someone-stole-my-name/yaml-companion.nvim",
      dependencies = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
      },
      config = function()
        require("telescope").load_extension("yaml_schema")
        require("lspconfig").yamlls.setup(require("yaml-companion").setup())
      end,
    },
  },

  mason_packages = {
    "yaml-language-server",
    -- "spectral-language-server",
    -- "vscode-json-language-server",
  },

  nonls_packages = {},

  lsp_config = {

    -- function(lspconfig, capabilities, custom_attach)
    --   lspconfig.spectral.setup({
    --     on_attach = custom_attach,
    --     capabilities = capabilities,
    --   })
    -- end,

    -- function(lspconfig, capabilities, custom_attach)
    --   lspconfig.yamlls.setup({
    --     on_attach = custom_attach,
    --     -- capabilities = capabilities,
    --     settings = {
    --       yaml = {
    --         redhat = { telemetry = { enabled = false } },
    --         format = {
    --           enable = true,
    --         },
    --         validate = true,
    --         schemaStore = {
    --           -- You must disable built-in schemaStore support if you want to use
    --           -- this plugin and its advanced options like `ignore`.
    --           enable = false,
    --           -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
    --           url = "",
    --         },
    --         schemas = require("schemastore").yaml.schemas(),
    --       },
    --     },
    --   })
    -- end,
  },
}
