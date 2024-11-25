return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    keywords = {
      MARK = { icon = " ", color = "warning", alt = { "BOOKMARK", "BM" } },
    },
  },
  keys = {
    { "<leader>xt", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
  },
}
