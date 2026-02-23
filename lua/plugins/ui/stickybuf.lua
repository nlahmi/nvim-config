return {
  "stevearc/stickybuf.nvim",
  config = function()
    require("stickybuf").setup({
      get_auto_pin = function(bufnr)
        local stickybuf = require("stickybuf")
        return not stickybuf.is_pinned() and (stickybuf.should_auto_pin(bufnr) or vim.bo[bufnr].modifiable == false)
      end,
    })
  end,
}
