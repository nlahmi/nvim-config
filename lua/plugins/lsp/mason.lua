--local lang = require("plugins.lsp.lang.python")
local lang = require("plugins.lsp.lang.all")
-- local lang = {}

return {
  {
    -- Source: https://www.lazyvim.org/plugins/lsp#masonnvim-1
    "mason-org/mason.nvim",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      -- Local registry first: it overrides packages whose upstream spec does not
      -- work here. See lua/mason-registry-local/.
      registries = {
        "lua:mason-registry-local",
        "github:mason-org/mason-registry",
      },
      ensure_installed = vim.list_extend({ "tree-sitter-cli" }, lang.mason_packages),
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      -- Servers are enabled explicitly in lua/lsp-setup.lua
      automatic_enable = false,
    },
  },
}
