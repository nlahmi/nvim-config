return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
        require("dashboard").setup({
            -- config
        })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    keys = { { "<leader>pd", "<cmd>Dashboard<cr>", desc = "Dashboard" } },
}
