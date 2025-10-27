return {
  packages = {
    {
      "alexander-born/bazel.nvim",
      dependencies = {
        -- { "nvim-treesitter/nvim-treesitter" },
        -- { "nvim-lua/plenary.nvim" },
        -- { "bazelbuild/vim-bazel", dependencies = { "google/vim-maktaba" } },
        {
          "saghen/blink.cmp",
          dependencies = { "saghen/blink.compat", { "alexander-born/cmp-bazel", dependencies = "hrsh7th/nvim-cmp" } },
          opts = {
            sources = {
              compat = { "bazel" },
            },
          },
        },
      },
    },
  },

  mason_packages = {},

  nonls_packages = {},

  lsp_config = {},
}
