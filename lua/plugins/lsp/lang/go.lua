return {
    packages = {
        {
            "leoluz/nvim-dap-go",
        },
    },

    mason_packages = {
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "delve",
    },

    nonls_packages = {},

    lsp_config = {

        function(lspconfig, capabilities, custom_attach)
            vim.lsp.config("gopls", {
                on_attach = custom_attach,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        gofumpt = true,
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        analyses = {
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                    },
                },
                -- flags = {
                --   debounce_text_changes = 200,
                -- },
                capabilities = capabilities,
            })
        end,
    },
}
