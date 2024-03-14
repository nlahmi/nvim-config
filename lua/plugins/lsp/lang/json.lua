
return {
    packages = {
        { "ikatyang/tree-sitter-yaml" },
        { "b0o/SchemaStore.nvim" },
    },

    mason_packages = {
        "json-lsp",
    },

    nonls_packages = {},

    lsp_config = {

        function(lspconfig, capabilities, custom_attach)
            lspconfig.jsonls.setup({
                on_attach = custom_attach,
                capabilities = capabilities,
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })
        end,
    },
}
