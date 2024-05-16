local function getDebugPywPath()
  local path = require("mason-registry").get_package("debugpy"):get_install_path()
  local utils = require("utils")

  return utils.get_py_exe(path)
end

local function python2pythonw(path)
  -- nvimide.log(path)
  local out = string.reverse(string.gsub(string.reverse(path), "nohty", "wnohty", 1))
  -- nvimide.log(out)
  return out
end

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
      -- dependencies = { "linux-cultist/venv-selector.nvim" },
      -- stylua: ignore
      ft = { "py" },
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
      },
      config = function()
        require("dap-python").setup(getDebugPywPath())

        table.insert(require("dap").configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch Python Interactively",
          program = "${file}",
          -- console = "internalConsole",
          console = "integratedTerminal",
          redirectOutput = true,
          -- args = { "-i", "\n", "exit", "0"},
          -- python = "pythonw",
          -- python = python2pythonw(require("venv-selector").get_active_path()),
          -- python = require("dap-python").resolve_python,
          -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
        })
      end,
    },
    {
      "linux-cultist/venv-selector.nvim",
      cmd = "VenvSelect",
      -- opts = function(_, opts)
      --     opts.dap_enabled = true
      --     return vim.tbl_deep_extend("force", opts, {
      --         name = {
      --             "venv",
      --             ".venv",
      --             "env",
      --             ".env",
      --         },
      --     })
      -- end,

      config = function()
        local venv_selector = require("venv-selector")

        venv_selector.setup({
          dap_enabled = true,
          name = { "venv", ".venv" },
          changed_venv_hooks = {
            -- Pyright
            venv_selector.hooks.pyright,

            -- Ruff
            function(venv_path, venv_python) end,

            -- dap-python
            function(venv_path, venv_python)
              require("dap-python").resolve_python = function()
                -- nvimide.log("YAY!!")
                return require("venv-selector").get_active_path()
                -- return venv_path
              end
            end,
            -- function(venv_path, venv_pyton)
            --   nvimide.log("entered vs")
            --   require("dap-python").resolve_python = function()
            --     nvimide.log("entered dp")
            --
            --     return string.reverse(
            --       string.gsub(
            --         string.reverse(require("venv-selector").get_active_path()),
            --         "nohty",
            --         "wnohty",
            --         1
            --       )
            --     )
            --
            --     -- return python2pythonw()
            --   end
            -- end,

            -- TODO: pylint
          },
        })
      end,
      keys = {
        { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" },
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
              pylint = { enabled = false, executable = "pylint" }, -- Used to be on, but is too verbose and also isn't configured yet with venv
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

  dap_config = {
    -- function(dap)
    --     dap.adapters.python = function(cb, config)
    --         if config.request == "attach" then
    --             ---@diagnostic disable-next-line: undefined-field
    --             local port = (config.connect or config).port
    --             ---@diagnostic disable-next-line: undefined-field
    --             local host = (config.connect or config).host or "127.0.0.1"
    --             cb({
    --                 type = "server",
    --                 port = assert(port, "`connect.port` is required for a python `attach` configuration"),
    --                 host = host,
    --                 options = {
    --                     source_filetype = "python",
    --                 },
    --             })
    --         else
    --             cb({
    --                 type = "executable",
    --                 command = getDebugPywPath(),
    --                 args = { "-m", "debugpy.adapter" },
    --                 options = {
    --                     source_filetype = "python",
    --                 },
    --             })
    --         end
    --     end
    --     dap.configurations.python = {
    --         {
    --             -- The first three options are required by nvim-dap
    --             type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
    --             request = "launch",
    --             name = "Launch file",
    --
    --             -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    --
    --             program = "${file}", -- This configuration will launch the current file if used.
    --             pythonPath = function()
    --                 -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
    --                 -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
    --                 -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
    --                 local cwd = vim.fn.getcwd()
    --                 if vim.fn.executable(cwd .. "/venv/Scripts/pythonw.exe") == 1 then
    --                     return cwd .. "/venv/Scripts/pythonw.exe"
    --                 elseif vim.fn.executable(cwd .. "/.venv/Scripts/pythonw.exe") == 1 then
    --                     return cwd .. "/.venv/Scripts/pythonw.exe"
    --                 elseif vim.fn.executable(cwd .. "/venv/bin/pythonw.exe") == 1 then
    --                     return cwd .. "/venv/bin/pythonw.exe"
    --                 elseif vim.fn.executable(cwd .. "/.venv/bin/pythonw.exe") == 1 then
    --                     return cwd .. "/.venv/bin/pythonw.exe"
    --                     -- else
    --                     --     return "C:\\Users\\Administrator\\AppData\\Local\\Programs\\Python\\Python311\\pythonw.exe"
    --                 end
    --             end,
    --         },
    --     }
    -- end,
  },
}
