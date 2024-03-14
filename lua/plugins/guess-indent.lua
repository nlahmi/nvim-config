return {
  "NMAC427/guess-indent.nvim",
  lazy = false,
  config = function()
    require("guess-indent").setup({})

    -- Those shouldn't be necessary but for some reason it doesn't work automatically without it
    vim.api.nvim_exec([[ autocmd BufReadPost * :silent GuessIndent ]], false)
    vim.api.nvim_exec([[ autocmd SessionLoadPost * :silent GuessIndent ]], false)
  end,
}
