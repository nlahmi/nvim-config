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
    -- {
    --   "nvim-neotest/neotest",
    --   optional = true,
    --   dependencies = {
    --     "nvim-neotest/neotest-python",
    --   },
    --   opts = {
    --     adapters = {
    --       ["neotest-python"] = {
    --         -- Here you can specify the settings for the adapter, i.e.
    --         -- runner = "pytest",
    --         -- python = ".venv/bin/python",
    --       },
    --     },
    --   },
    -- },
    -- {
    --   "mfussenegger/nvim-dap-python",
    --   -- dependencies = { "linux-cultist/venv-selector.nvim" },
    --   -- stylua: ignore
    --   lazy = false,
    --   ft = { "py" },
    --   keys = {
    --     {
    --       "<leader>dPt",
    --       function()
    --         require("dap-python").test_method()
    --       end,
    --       desc = "Debug Method",
    --       ft = "python",
    --     },
    --     {
    --       "<leader>dPc",
    --       function()
    --         require("dap-python").test_class()
    --       end,
    --       desc = "Debug Class",
    --       ft = "python",
    --     },
    --   },
    --   config = function()
    --     require("dap-python").setup(getDebugPywPath())
    --   end,
    -- },
    -- {
    --   "linux-cultist/venv-selector.nvim",
    --   cmd = "VenvSelect",
    --   -- opts = function(_, opts)
    --   --     opts.dap_enabled = true
    --   --     return vim.tbl_deep_extend("force", opts, {
    --   --         name = {
    --   --             "venv",
    --   --             ".venv",
    --   --             "env",
    --   --             ".env",
    --   --         },
    --   --     })
    --   -- end,
    --
    --   config = function()
    --     local venv_selector = require("venv-selector")
    --
    --     venv_selector.setup({
    --       dap_enabled = true,
    --       name = { "venv", ".venv" },
    --       stay_on_this_version = true,
    --       changed_venv_hooks = {
    --         -- Pyright
    --         -- venv_selector.hooks.pyright,
    --
    --         -- Ruff
    --         -- function(venv_path, venv_python) end,
    --
    --         -- dap-python
    --         function(venv_path, _)
    --           require("dap-python").resolve_python = function()
    --             -- nvimide.log("YAY!!")
    --             return venv_path
    --             -- return venv_path
    --           end
    --         end,
    --         -- function(venv_path, venv_pyton)
    --         --   nvimide.log("entered vs")
    --         --   require("dap-python").resolve_python = function()
    --         --     nvimide.log("entered dp")
    --         --
    --         --     return string.reverse(
    --         --       string.gsub(
    --         --         string.reverse(require("venv-selector").get_active_path()),
    --         --         "nohty",
    --         --         "wnohty",
    --         --         1
    --         --       )
    --         --     )
    --         --
    --         --     -- return python2pythonw()
    --         --   end
    --         -- end,
    --
    --       },
    --     })
    --   end,
    --   keys = {
    --     { "<leader>cv", "<cmd>:VenvSelect<cr>",       desc = "Select VirtualEnv" },
    --     { "<leader>cV", "<cmd>:VenvSelectCached<cr>", desc = "Activate Prev VirtualEnv" },
    --   },
    -- },
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
    "ruff",
  },
  nonls_packages = {
    --require("null-ls").builtins.formatiing.blahh,
  },

  lsp_config = {
    function(lspconfig, capabilities, custom_attach)
      -- Install pip packages to mason venv

      -- Install pylsp-rope in the internal venv - commented because rope is unused (too slow)
      -- local mason_registry = require("mason-registry")
      -- if mason_registry.is_installed("python-lsp-server") then
      --   local pylsp_pip_path = mason_registry.get_package("python-lsp-server"):get_install_path() .. "/venv/bin/pip"
      --   local on_exit = function(obj)
      --     if obj.code ~= 0 then
      --       print("code: " .. obj.code)
      --       print("signal: " .. obj.signal)
      --       print("stdout: " .. obj.stdout)
      --       print("stderr: " .. obj.stderr)
      --     end
      --   end
      --   -- Runs asynchronously:
      --   vim.system({ pylsp_pip_path, "install", "pylsp-rope" }, { text = true }, on_exit)
      -- end

      --lspconfig.pyright.setup({
      --   on_attach = custom_attach,
      --    capabilities = capabilities,
      --})

      -- Separate from pylsp since for some reason it doesn't work with code actions
      -- Does: Linting, Organize Imports, Code Formatting
      lspconfig.ruff.setup({
        on_attach = custom_attach,
        capabilities = capabilities,
      })

      -- Does: Autocompletion, Static Type Checking (mypy) - doesn't work
      lspconfig.pylsp.setup({
        on_attach = custom_attach,
        settings = {
          configurationSources = { "pycodestyle", "flake8" },
          pylsp = {
            plugins = {
              -- formatter options
              black = { enabled = false }, -- Doesn't work
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
                report_progress = true,
                live_mode = true,
              },
              -- auto-completion options
              jedi_completion = { enabled = true, fuzzy = true },
              jedi_rename = { enabled = true },
              -- import sorting
              isort = { enabled = false }, -- Works when disabled
              pylsp_rope = { enabled = false },
              rope_autoimport = { enabled = false },
              rope_completion = {
                enabled = false,
              },
              -- pydocstyle = { enabled = true },
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
    end,

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
