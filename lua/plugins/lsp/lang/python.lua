return {
    packages = {
        {
            "nvim-neotest/neotest",
            optional = true,
            dependencies = {
                "nvim-neotest/neotest-python",
            },
            opts = {
                adapters = {
                    ["neotest-python"] = {
                        -- Here you can specify the settings for the adapter, i.e.
                        -- runner = "pytest",
                        -- python = ".venv/bin/python",
                    },
                },
            },
        },
        {
            "mfussenegger/nvim-dap-python",
            -- stylua: ignore
            keys = {
                { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
                { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
            },
            config = function()
                local path = require("mason-registry").get_package("debugpy"):get_install_path()
                local utils = require("utils")
                require("dap-python").setup(utils.get_py_exe(path))
            end,
        },
        {
            "linux-cultist/venv-selector.nvim",
            cmd = "VenvSelect",
            opts = function(_, opts)
                opts.dap_enabled = true
                return vim.tbl_deep_extend("force", opts, {
                    name = {
                        "venv",
                        ".venv",
                        "env",
                        ".env",
                    },
                })
            end,

            config = function()
                local venv_selector = require("venv-selector")

                venv_selector.setup({
                    changed_venv_hooks = {
                        -- Pyright
                        venv_selector.hooks.pyright,

                        -- Ruff
                        function(venv_path, venv_python)
                        end,

                        -- dap-python
                        function(venv_path, venv_python)
                            require("dap-python").resolve_python = function()
                                -- return require("venv-selector").get_active_path()
                                return venv_path
                            end
                        end,
                    },
                })
            end,
            keys = {
                { "<leader>cv", "<cmd>:VenvSelect<cr>",       desc = "Select VirtualEnv" },
                { "<leader>cV", "<cmd>:VenvSelectCached<cr>", desc = "Activate Prev VirtualEnv" },
            },
        },
    },
    mason_packages = {
        --"flake8",
        --"pyright",
        "python-lsp-server",
        "jedi-language-server",
        "debugpy",
        "black",
        "pylint",
        "mypy",
        "isort",
        "ruff-lsp",
    },
    nonls_packages = {
        --require("null-ls").builtins.formatiing.blahh,
    },

    lsp_config = {
        function(lspconfig, capabilities, custom_attach)
            --lspconfig.pyright.setup({
            --   on_attach = custom_attach,
            --    capabilities = capabilities,
            --})

            lspconfig.ruff_lsp.setup({
                on_attach = custom_attach,
            })

            lspconfig.pylsp.setup({
                on_attach = custom_attach,
                settings = {
                    pylsp = {
                        plugins = {
                            -- formatter options
                            black = { enabled = true },
                            autopep8 = { enabled = false },
                            yapf = { enabled = false },
                            -- linter options
                            pylint = { enabled = true, executable = "pylint" },
                            ruff = { enabled = false },
                            pyflakes = { enabled = false },
                            pycodestyle = { enabled = false },
                            -- type checker
                            pylsp_mypy = {
                                enabled = true,
                                --overrides = { "--python-executable", py_path, true },
                                report_progress = true,
                                live_mode = false,
                            },
                            -- auto-completion options
                            jedi_completion = { fuzzy = true },
                            -- import sorting
                            isort = { enabled = true },
                        },
                    },
                },
                flags = {
                    debounce_text_changes = 200,
                },
                capabilities = capabilities,
            })
        end,
    },
}
