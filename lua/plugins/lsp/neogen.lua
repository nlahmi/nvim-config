return {
    "danymat/neogen",
    config = function()
        require("neogen").setup({ snippet_engine = "luasnip" })
        -- require("neogen").setup({})

        -- local opts = { noremap = true, silent = true }
        -- vim.api.nvim_set_keymap("i", "<C-l>", "<esc>:lua require('neogen').jump_next<CR>i", opts)
        -- vim.api.nvim_set_keymap("i", "<C-h>", ":lua require('neogen').jump_prev<CR>", opts)

        -- The <tab>/<S-tab> jump mappings live in plugins.lsp.completions, since
        -- cmp.setup replaces the whole config rather than merging into it.
    end,
    -- Uncomment next line if you want to follow only stable versions
    version = "*",
    keys = { { "<leader>cD", "<cmd>Neogen<cr>", desc = "Generate Docstring" } },
}
