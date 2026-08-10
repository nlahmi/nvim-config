return {
  "nvimtools/none-ls.nvim",
    -- keys = { { "<leader>gf", vim.lsp.buf.format, desc = "Format" } },
  -- opts, not config: per-language modules extend opts.sources (see
  -- plugins.lsp.lang.markdown), and a config function would discard them.
  -- Extend the incoming opts rather than returning a fresh table, or whichever
  -- fragment lazy resolves first gets dropped.
  opts = function(_, opts)
    local null_ls = require("null-ls")
    opts.sources = vim.list_extend(opts.sources or {}, {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      --null_ls.builtins.diagnostics.erb_lint,
      --null_ls.builtins.diagnostics.eslint_d,
      --null_ls.builtins.diagnostics.rubocop,
      --null_ls.builtins.formatting.rubocop,
    })
    return opts
  end,
}
