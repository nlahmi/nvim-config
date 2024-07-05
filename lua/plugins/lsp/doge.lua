return {
  "kkoomen/vim-doge",
  config = function()
    -- vim.g.doge_doc_standard_python = ""
    -- vim.cmd("call doge#install()")
  end,
  keys = {
    { "<leader>cD", "<cmd>DogeGenerate<cr>", desc = "Generate Docstring" },
  },
}
