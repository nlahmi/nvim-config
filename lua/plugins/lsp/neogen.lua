return {
    "danymat/neogen",
    config = function()
        require("neogen").setup({ snippet_engine = "luasnip" })
        -- require("neogen").setup({})

        -- local opts = { noremap = true, silent = true }
        -- vim.api.nvim_set_keymap("i", "<C-l>", "<esc>:lua require('neogen').jump_next<CR>i", opts)
        -- vim.api.nvim_set_keymap("i", "<C-h>", ":lua require('neogen').jump_prev<CR>", opts)

        local cmp = require("cmp")
        local neogen = require("neogen")

        cmp.setup({

          -- You must set mapp:lua require('neogen').jump_nexting if you want.
          mapping = {
            ["<tab>"] = cmp.mapping(function(fallback)
              if neogen.jumpable() then
                neogen.jump_next()
              else
                fallback()
              end
            end, {
              "i",
              "s",
            }),
            ["<S-tab>"] = cmp.mapping(function(fallback)
              if neogen.jumpable() then
                neogen.jump_prev()
              else
                fallback()
              end
            end, {
              "i",
              "s",
            }),
          },
        })
    end,
    -- Uncomment next line if you want to follow only stable versions
    version = "*",
    keys = { { "<leader>cD", "<cmd>Neogen<cr>", desc = "Generate Docstring" } },
}
