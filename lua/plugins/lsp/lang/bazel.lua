return {
  packages = {
    -- {
    --   "alexander-born/bazel.nvim",
    --   dependencies = {
    --     -- { "nvim-treesitter/nvim-treesitter" },
    --     -- { "nvim-lua/plenary.nvim" },
    --     -- { "bazelbuild/vim-bazel", dependencies = { "google/vim-maktaba" } },
    --     {
    --       "saghen/blink.cmp",
    --       dependencies = { "saghen/blink.compat", { "alexander-born/cmp-bazel", dependencies = "hrsh7th/nvim-cmp" } },
    --       opts = {
    --         sources = {
    --           compat = { "bazel" },
    --         },
    --       },
    --     },
    --   },
    -- },
  },

  mason_packages = { "starpls" },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("starpls", {
        capabilities = capabilities,
        on_attach = custom_attach,
        filetypes = { "bzl", "BUILD" },
      })
    end,
  },
}
