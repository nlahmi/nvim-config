return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        plugins = { spelling = true },
        defaults = {
            mode = { "n", "v" },
            ["g"] = { name = "+goto" },
            ["gs"] = { name = "+surround" },
            ["]"] = { name = "+next" },
            ["["] = { name = "+prev" },
            ["<leader><tab>"] = { name = "+tabs" },
            ["<leader>b"] = { name = "+buffer" },
            ["<leader>c"] = { name = "+code" },
            ["<leader>cw"] = { name = "+workspace" },
            ["<leader>d"] = { name = "+debug" },
            ["<leader>f"] = { name = "+file/find" },
            ["<leader>g"] = { name = "+git" },
            ["<leader>gh"] = { name = "+hunks" },
            ["<leader>p"] = { name = "+plugins" },
            ["<leader>pn"] = { name = "+noice" },
            ["<leader>q"] = { name = "+quit/session" },
            ["<leader>r"] = { name = "+run" },
            ["<leader>s"] = { name = "+search" },
            ["<leader>u"] = { name = "+ui" },
            ["<leader>w"] = { name = "+windows" },
            ["<leader>x"] = { name = "+diagnostics/quickfix" },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)
    end,
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
}
