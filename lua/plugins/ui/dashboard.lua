return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
        tabline = false,
        winbar = false,
      },
      shortcut_type = "number",
      config = {
        project = {
          limit = 8,
          enable = true,
          icon = "󰏓 ",
          icon_hl = "DashboardRecentProjectIcon",
          action = "Telescope projects",
          label = " Recent Projects:",
        },
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  keys = { { "<leader>pd", "<cmd>Dashboard<cr>", desc = "Dashboard" } },
}
