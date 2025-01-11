return {
  "stevearc/oil.nvim",
  config = function()
    -- Declare a global function to retrieve the current directory
    function _G.get_oil_winbar()
      local dir = require("oil").get_current_dir()
      if dir then
        return vim.fn.fnamemodify(dir, ":~")
      else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
      end
    end

    require("oil").setup({
      -- buf_options = {
      --   buf_hidden = "show",
      -- },
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
      columns = {
        "icon",
        -- "name",
        -- "permissions",
        -- "size",
      },
    })
  end,

  keys = {
    { "<leader>e", "<Cmd>Oil<CR>", desc = "Show Oil" },
  },

  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
