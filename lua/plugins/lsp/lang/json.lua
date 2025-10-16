return {
  packages = {
    { "ikatyang/tree-sitter-yaml" },
    { "b0o/SchemaStore.nvim" },
    {
      "https://git.myzel394.app/Myzel394/jsonfly.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "phelipetls/jsonpath.nvim",
      },
      keys = {
        {
          "<leader>fj",
          "<cmd>Telescope jsonfly<cr>",
          desc = "Open json(fly)",
          ft = { "json", "xml", "yaml" },
          mode = "n",
        },
      },
    },
  },

  mason_packages = {
    "json-lsp",
  },

  nonls_packages = {},

  lsp_config = {

    function(_, capabilities, custom_attach)
      vim.lsp.config("jsonls", {
        on_attach = custom_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
}
