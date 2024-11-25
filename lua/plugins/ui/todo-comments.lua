return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>xt", "<cmd>TodoTelescope<cr>",  desc = "Todo Telescope" },
  },
}
