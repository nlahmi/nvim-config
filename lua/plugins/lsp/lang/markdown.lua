return {
  packages = {
    {
      "nvimtools/none-ls.nvim",
      optional = true,
      opts = function(_, opts)
        local nls = require("null-ls")
        opts.sources = vim.list_extend(opts.sources or {}, {
          nls.builtins.diagnostics.markdownlint,
        })
      end,
    },
    {
      -- Todo: Consider moving this up and making it generic
      "mfussenegger/nvim-lint",
      optional = true,
      opts = {
        linters_by_ft = {
          markdown = { "markdownlint" },
        },
      },
    },
    {
      -- Todo: Check if this is actually required
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          marksman = {},
        },
      },
    },
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      keys = {
        { "<leader>rp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
      },
      config = function()
        vim.cmd([[do FileType]])
      end,
    },

    {
      "lukas-reineke/headlines.nvim",
      opts = function()
        local opts = {}
        for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
          opts[ft] = {
            headline_highlights = {},
          }
          for i = 1, 6 do
            local hl = "Headline" .. i
            vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
            table.insert(opts[ft].headline_highlights, hl)
          end
        end
        return opts
      end,
      ft = { "markdown", "norg", "rmd", "org" },
      config = function(_, opts)
        -- PERF: schedule to prevent headlines slowing down opening a file
        vim.schedule(function()
          require("headlines").setup(opts)
          require("headlines").refresh()
        end)
      end,
    },
    {
      "gaoDean/autolist.nvim",
      ft = {
        "markdown",
        "text",
        "tex",
        "plaintex",
        "norg",
      },
      config = function()
        require("autolist").setup()

        vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
        vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
        -- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
        vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
        vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
        vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
        vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
        vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

        -- cycle list types with dot-repeat
        vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
        vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

        -- if you don't want dot-repeat
        -- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
        -- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

        -- functions to recalculate list on edit
        vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
        vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
        vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
        vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
      end,
    },
  },

  mason_packages = {
    "markdownlint",
    "marksman",
    "prettier",
  },

  nonls_packages = {
    -- require("null-ls").builtins.diagnostics.markdownlint,
  },

  lsp_config = {
    function(lspconfig, capabilities, custom_attach)
      require("lspconfig").marksman.setup({ on_attach = custom_attach })
    end,
  },
}
