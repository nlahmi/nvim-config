return {
  packages = {},

  mason_packages = {
    "shfmt",
    "bash-language-server",
    "bash-debug-adapter",
  },

  nonls_packages = {},

  lsp_config = {
    function(_, capabilities, custom_attach)
      vim.lsp.config("bashls", { on_attach = custom_attach, capabilities = capabilities })
    end,
  },

  dap_config = {
    function(dap)
      bashdap_path = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter"
      dap.adapters.sh = {
        type = "executable",
        command = bashdap_path .. "/bash-debug-adapter",
      }
      dap.configurations.sh = {
        {
          name = "Launch Bash debugger",
          type = "sh",
          request = "launch",
          program = "${file}",
          cwd = "${fileDirname}",
          pathBashdb = bashdap_path .. "/extension/bashdb_dir/bashdb",
          pathBashdbLib = bashdap_path .. "/extension/bashdb_dir",
          pathBash = "bash",
          pathCat = "cat",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          env = {},
          args = {},
          -- trace = true,
          -- terminalKind = "external",
          -- showDebugOutput = true,
          -- trace = true,
        },
      }
    end,
  },
}
