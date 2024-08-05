return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        plugins = { spelling = true },
        defaults = {
            -- mode = { "n", "v" },
        }
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)

        wk.add({
            { "g", desc = "+goto" },
            { "gs", name = "+surround" },
            { "]", desc = "+next" },
            { "[", desc = "+prev" },
            { "<leader><tab>", desc = "+tabs" },
            { "<leader>b", desc = "+buffer" },
            { "<leader>c", desc = "+code" },
            { "<leader>cw", desc = "+workspace" },
            { "<leader>d", desc = "+debug" },
            { "<leader>f", desc = "+file/find" },
            { "<leader>g", desc = "+git" },
            { "<leader>gh", desc = "+hunks" },
            { "<leader>p", desc = "+plugins" },
            { "<leader>pn", desc = "+noice" },
            { "<leader>q", desc = "+quit/session" },
            { "<leader>r", desc = "+run" },
            { "<leader>s", desc = "+search" },
            { "<leader>u", desc = "+ui" },
            { "<leader>w", desc = "+windows" },
            { "<leader>x", desc = "+diagnostics/quickfix" }
        })
    end,
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
}
