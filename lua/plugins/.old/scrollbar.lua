return {
    "petertriho/nvim-scrollbar",
    dependencies = {
        "lewis6991/gitsigns.nvim",
        -- {
        --     "kevinhwang91/nvim-hlslens",
        --     config = function()
        --         require("hlslens").setup()
        --     end,
        -- },
    },
    config = function()
        require("scrollbar").setup({
            marks = {
                Search = { color = vim.api.nvim_get_hl_by_name("Search", true).foreground },
                Error = { color = vim.api.nvim_get_hl_by_name("Error", true).foreground },
                Warn = { color = vim.api.nvim_get_hl_by_name("WarningMsg", true).foreground },
                -- Info = { color = vim.api.nvim_get_hl_by_name("InfoFloat", true).foreground },
                -- Hint = { color = vim.api.nvim_get_hl_by_name("HintFloat", true).foreground },
                -- Misc = { color = vim.api.nvim_get_hl_by_name("helpNote", true).foreground },
            },
            handlers = {
                cursor = true,
                diagnostic = true,
                gitsigns = true, -- Requires gitsigns
                handle = true,
                search = false, -- Requires hlslens
                ale = false, -- Requires ALE
            },
        })
    end,
}
