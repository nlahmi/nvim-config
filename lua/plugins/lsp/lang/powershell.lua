return {
  packages = {
    {
      "TheLeoP/powershell.nvim",
      ---@type powershell.user_config
      opts = {
        shell = "powershell.exe",
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/PowerShellEditorServices",
      },
    },
  },

  mason_packages = {
    "powershell-editor-services",
  },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("powershell_es", {
        on_attach = custom_attach,
        capabilities = capabilities,
        settings = {
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/PowerShellEditorServices",
          init_options = {
            enableProfileLoading = false,
          },
        },
      })
    end,
  },

  -- dap_config = {
  --   function(dap)
  --     dap.configurations.ps1 = dap.configurations.ps1 or {}
  --
  --     -- Insert our default configs
  --     command = "powershell.exe",
  --     table.insert(dap.configurations.ps1, 1, {
  --       name = "PowerShell: Launch Current File (powershell.exe)",
  --       type = "ps1",
  --       request = "launch",
  --       script = "${file}",
  --       command = "powershell.exe",
  --       -- program = "${file}",
  --       -- console = "internalConsole",
  --       console = "integratedTerminal",
  --       redirectOutput = true,
  --     })
  --
  --     table.insert(dap.configurations.ps1, 2, {
  --       name = "PowerShell: Launch Current File (pwsh)",
  --       type = "ps1",
  --       request = "launch",
  --       script = "${file}",
  --       command = "pwsh",
  --       -- console = "integratedTerminal",
  --       -- redirectOutput = true,
  --       -- pythonPath = py_path,
  --     })
  --   end,
  -- },
}
