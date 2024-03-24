return {
    packages = {
        { "folke/neodev.nvim", opts = {} },
    },

    mason_packages = {
        "lua-language-server",
        "stylua",
    },

    nonls_packages = {},

    lsp_config = {
        function(lspconfig, capabilities, custom_attach)
            lspconfig.lua_ls.setup({
                on_attach = custom_attach,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { "vim" },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files,
                            -- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
                            -- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
                            --library = {
                            --  fn.stdpath("data") .. "/lazy/emmylua-nvim",
                            --  fn.stdpath("config"),
                            --},
                            maxPreload = 2000,
                            preloadFileSize = 50000,
                        },
                    },
                },
                capabilities = capabilities,
            })
        end,
    },
}
