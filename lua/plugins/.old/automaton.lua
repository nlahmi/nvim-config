return {
    "Dax89/automaton.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap", -- Debug support for 'launch' configurations (Optional)
        "hrsh7th/nvim-cmp",  -- Autocompletion for automaton workspace files (Optional)
        "L3MON4D3/LuaSnip",  -- Snippet support for automaton workspace files (Optional)
    },
    config = function()
        require("automaton").setup({
            debug = true,
            -- saveall = true,
            -- ignore_ft = require("config.common").buftype_blacklist,  -- https://github.com/Dax89/nvim-config/blob/2dbeae28661ef09f5172b7da1205bec12ac402ee/lua/plugins/my.lua#L73
            integrations = {
                luasnip = true,
                cmp = true,
                -- cmdcolor = require("automaton.utils").colors.yellow,
            },
        })

        vim.keymap.set("n", "<F5>", "<CMD>Automaton launch default<CR>")
        vim.keymap.set("n", "<F6>", "<CMD>Automaton debug default<CR>")
        vim.keymap.set("n", "<F8>", "<CMD>Automaton tasks default<CR>")

        vim.keymap.set("n", "<leader>aC", "<CMD>Automaton create<CR>")
        vim.keymap.set("n", "<leader>aI", "<CMD>Automaton init<CR>")
        vim.keymap.set("n", "<leader>aL", "<CMD>Automaton load<CR>")

        vim.keymap.set("n", "<leader>ac", "<CMD>Automaton config<CR>")
        vim.keymap.set("n", "<leader>ar", "<CMD>Automaton recents<CR>")
        vim.keymap.set("n", "<leader>aw", "<CMD>Automaton workspaces<CR>")
        vim.keymap.set("n", "<leader>aj", "<CMD>Automaton jobs<CR>")
        vim.keymap.set("n", "<leader>al", "<CMD>Automaton launch<CR>")
        vim.keymap.set("n", "<leader>ad", "<CMD>Automaton debug<CR>")
        vim.keymap.set("n", "<leader>at", "<CMD>Automaton tasks<CR>")

        vim.keymap.set("n", "<leader>aol", "<CMD>Automaton open launch<CR>")
        vim.keymap.set("n", "<leader>aov", "<CMD>Automaton open variables<CR>")
        vim.keymap.set("n", "<leader>aot", "<CMD>Automaton open tasks<CR>")
        vim.keymap.set("n", "<leader>aoc", "<CMD>Automaton open config<CR>")

        -- Visual Mode
        vim.keymap.set("v", "<F5>", "<CMD><C-U>Automaton launch default<CR>")
        vim.keymap.set("v", "<F6>", "<CMD><C-U>Automaton debug default<CR>")
        vim.keymap.set("v", "<F8>", "<CMD><C-U>Automaton tasks default<CR>")
        vim.keymap.set("v", "<leader>al", "<CMD><C-U>Automaton launch<CR>")
        vim.keymap.set("v", "<leader>ad", "<CMD><C-U>Automaton debug<CR>")
        vim.keymap.set("v", "<leader>at", "<CMD><C-U>Automaton tasks<CR>")
    end,
}
