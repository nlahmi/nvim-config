return {
  "akinsho/git-conflict.nvim",
  version = "*",
  config = true,
  -- TODO: Consider remapping default keys
  --
  keys = {
    { "<leader>gC", "<Cmd>GitConflictListQf<CR>", desc = "Show Conflicts (qf)" },
  },
}
