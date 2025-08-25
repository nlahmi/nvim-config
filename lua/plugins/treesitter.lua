return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        ignore_install = {
          -- "yaml", -- Fix attempt for yaml issues
        },
        highlight = { enable = true },
        indent = { enable = true },

        -- textsubjects
        textsubjects = {
          enable = true,
          prev_selection = ",", -- (Optional) keymap to select the previous selection
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
          },
        },

        -- This next bit (textobjects) was copied from https://github.com/omerxx/dotfiles/blob/master/nvim/lua/plugins/treesitter.lua
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ii"] = "@conditional.inner",
              ["ai"] = "@conditional.outer",
              ["il"] = "@loop.inner",
              ["al"] = "@loop.outer",
              ["at"] = "@comment.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["gsa"] = "@parameter.inner",
            },
            swap_previous = {
              ["gsA"] = "@parameter.inner",
            },
          },
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        -- enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = true, -- Enable multiwindow support.
        max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
        -- min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        -- line_numbers = true,
        multiline_threshold = 1, -- Maximum number of lines to show for a single context
        -- trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        -- separator = nil,
        -- zindex = 20, -- The Z-index of the context window
        -- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },
}
