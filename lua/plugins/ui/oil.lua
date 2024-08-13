return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup({
      -- buf_options = {
      --   buf_hidden = "show",
      -- },
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
    })
  end,

  keys = {
    { "<leader>e", "<Cmd>Oil<CR>", desc = "Show Oil" },
  },

  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
