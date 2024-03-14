return {
  "p00f/godbolt.nvim",
  keys = {
    { "<leader>pgg", "<cmd>Godbolt!<cr>", desc = "Rerun Godbolt" },
    { "<leader>pgG", "<cmd>Godbolt<cr>", desc = "Run Godbolt" },
    { "<leader>pgt", "<cmd>GodboltCompiler telescope<cr>", desc = "Find Compiler" },
  },
  config = function()
    require("godbolt").setup({
      -- languages = {
      --   cpp = { compiler = "g122", options = {} },
      --   c = { compiler = "cg122", options = {} },
      --   rust = { compiler = "r1650", options = {} },
      --   -- any_additional_filetype = { compiler = ..., options = ... },
      -- },
      quickfix = {
        enable = true, -- whether to populate the quickfix list in case of errors
        auto_open = true, -- whether to open the quickfix list in case of errors
      },
      -- url = "https://godbolt.org", -- can be changed to a different godbolt instance
    })
  end,
}
