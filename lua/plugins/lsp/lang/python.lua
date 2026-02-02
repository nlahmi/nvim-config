return {
  packages = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          python = { "ruff_format" },
        },
        formatters = {
          isort = {
            inherit = true,
            -- command = "isort",
            prepend_args = {
              "--force-single-line-imports",
              "--force-sort-within-sections",
              "--known-local-folder",
              "acli,armis,armis_sdk,data_analysis,demo,deploy,scripts,util",
              "--line-length",
              "500",
              "--order-by-type",
              "--use-parentheses",
            },
          },
          autopep8 = {
            inherit = true,
            -- command = "autopep8",
            prepend_args = {
              -- "--in-place",
              "--max-line-length",
              "120",
              "--experimental",
              "--ignore",
              "E301",
            },
          },
        },
      },
      -- stylua: ignore
      keys = {
        { "<leader>cm", function() require("conform").format({ formatters = { "ruff_format", "isort", "autopep8", async = true } }) end, desc = "Mani Pedi" },
      },
    },
  },

  mason_packages = {
    "jedi-language-server",
    "debugpy",
    "ruff",
    "isort",
    "autopep8",
  },
  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("jedi_language_server", {
        on_attach = custom_attach,
        capabilities = capabilities,
      })

      -- Does: Linting, Organize Imports, Code Formatting
      vim.lsp.config("ruff", {
        on_attach = custom_attach,
        capabilities = capabilities,
      })
    end,
  },

  dap_config = {
    function(dap)
      -- Find the correct python path (venv or global)
      local function get_py_exe(venv_path)
        if venv_path == nil then
          venv_path = os.getenv("VIRTUAL_ENV")
        end
        if venv_path == nil then
          venv_path = ""
        end

        local options = {
          venv_path .. "/bin/python",
          venv_path .. "/Scripts/pythonw",
          "python",
          "python3",
        }

        for _, x in pairs(options) do
          if vim.fn.executable(x) == 1 then
            return x
          end
        end
      end

      local py_path = get_py_exe()

      local dap = require("dap")
      -- dap.adapters.python = function(cb, config)
      --   if config.request == "attach" then
      --     -- Connect directly for attach
      --     local port = (config.connect or config).port
      --     local host = (config.connect or config).host or "127.0.0.1"
      --     cb({
      --       type = "server",
      --       port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      --       host = host,
      --       options = {
      --         source_filetype = "python",
      --       },
      --     })
      --   else
      --     -- Use the executable for launch (normal debugging)
      --     cb({
      --       type = "executable",
      --       command = "/home/noam/.local/share/nvim/mason/bin/debugpy-adapter",
      --       options = {
      --         source_filetype = "python",
      --       },
      --     })
      --   end
      -- end

      dap.adapters.python.options = { env = { PYDEVD_UNBLOCK_THREADS_TIMEOUT = "3" } }

      -- Insert our default configs
      table.insert(dap.configurations.python, 1, {
        type = "python",
        request = "launch",
        name = "Launch Python Interactively (current)",
        program = "${file}",
        -- console = "internalConsole",
        console = "integratedTerminal",
        redirectOutput = true,
        pythonPath = py_path,
        -- args = { "-i", "\n", "exit", "0"},
        -- python = "pythonw",
        -- python = python2pythonw(require("venv-selector").get_active_path()),
        -- python = require("dap-python").resolve_python,
        -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
      })
      table.insert(dap.configurations.python, 2, {
        type = "python",
        request = "launch",
        name = "Launch Python Interactively (main.py)",
        program = "main.py",
        console = "integratedTerminal",
        redirectOutput = true,
        pythonPath = py_path,
      })
      table.insert(dap.configurations.python, 3, {
        type = "python",
        request = "launch",
        name = "Launch Python Interactively (test.py)",
        program = "test.py",
        console = "integratedTerminal",
        redirectOutput = true,
        pythonPath = py_path,
      })
    end,
  },
}
