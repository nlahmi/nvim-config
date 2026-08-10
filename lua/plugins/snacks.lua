return {
  "folke/snacks.nvim",
  -- snacks is lazy, so claim vim.ui.input up front and load on first use. This
  -- is what dressing.nvim used to do before it was archived.
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "snacks.nvim" } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    gh = {
      -- your gh configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    -- Replaces dressing.nvim (archived) as the vim.ui.input provider.
    -- vim.ui.select stays with telescope-ui-select, see plugins.telescope.
    input = { enabled = true },
    picker = {
      sources = {
        gh_issue = {
          -- your gh_issue picker configuration comes here
          -- or leave it empty to use the default settings
        },
        gh_pr = {
          -- your gh_pr picker configuration comes here
          -- or leave it empty to use the default settings
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>ghi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>ghI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    -- { "<leader>ghp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    -- { "<leader>ghP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
  },
}
