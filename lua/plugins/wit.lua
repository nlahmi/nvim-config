return {
  "aliqyan-21/wit.nvim",
  lazy = false,
  config = function()
    require("wit").setup()
  end,
  keys = {
    -- { "gs", "<cmd>WitSearch<cr>", mode = "n", desc = "Browser Search" },
    { "gs", "<cmd>'<,'>WitSearchVisual<cr>", mode = "v", desc = "Browser Search" },
  },
}
