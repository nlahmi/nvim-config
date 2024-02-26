return {
    packages = {
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
        keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
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
    
    lsp_config = function(lspconfig, capabilities, custom_attach)
        --lspconfig.pyright.setup({
        --   on_attach = custom_attach,
        --    capabilities = capabilities,
        --})
        
        lspconfig.ruff_lsp.setup {
          on_attach = on_attach,
        }
        
        lspconfig.pylsp.setup {
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
                    overrides = { "--python-executable", py_path, true },
                    report_progress = true,
                    live_mode = false
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
        }
    end,
}