return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "rcarriga/cmp-dap",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        -- opts = {sorting = {comparators = require("clangd_extensions.cmp_scores")}},
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    -- { name = "path" },
                    -- { name = "automatonschema" },
                    -- { name = "automatonvariable" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                    -- { name = "buffer" },
                }),

                -- cmp-dap
                enabled = function()
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
                end,
            })
            -- cmp-dap
            cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
                sources = {
                    { name = "dap" },
                },
            })
        end,
    },
}
