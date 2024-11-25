return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    keywords = {
      MARK = { icon = " ", color = "warning", alt = { "BOOKMARK", "BM" } },
    },
  },
  keys = {
    { "<C-t>", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
    { "<leader>xt", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
    { "<leader>xm", "<cmd>TodoTelescope keywords=MARK,BM,BOOKMARK<cr>", desc = "Todo Telescope" },
  },
}
