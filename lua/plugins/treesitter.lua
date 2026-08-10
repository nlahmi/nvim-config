-- nvim-treesitter `main` is a full rewrite: no configs.setup, no auto_install,
-- and no lazy-loading. Highlighting and indent are wired up by hand below.
local parsers = {
  -- Languages with an active config in plugins.lsp.lang (gated ones are left to
  -- the FileType autocmd, so disabling a language does not cost highlighting).
  "awk",
  "bash",
  "cmake",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "powershell",
  "proto",
  "python",
  "starlark",
  "typescript",
  "yaml",

  -- Not tied to a language config, but used often enough to keep preinstalled.
  "diff",
  "dockerfile",
  -- gitcommit is omitted: `tree-sitter build` silently produces no parser.so for
  -- it at the revision nvim-treesitter pins. Vim's builtin syntax covers it.
  "git_config",
  "gitignore",
  "ini",
  "make",
  "query",
  "sql",
  "terraform",
  "toml",
  "vim",
  "vimdoc",
  "xml",
}

-- lhs -> capture, shared between the lazy `keys` specs and the mapping setup so
-- the two cannot drift apart.
-- stylua: ignore
local selections = {
  ["aa"] = "@parameter.outer",   ["ia"] = "@parameter.inner",
  ["af"] = "@function.outer",    ["if"] = "@function.inner",
  ["ac"] = "@class.outer",       ["ic"] = "@class.inner",
  ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
  ["al"] = "@loop.outer",        ["il"] = "@loop.inner",
  ["at"] = "@comment.outer",
}

-- stylua: ignore
local movements = {
  { "]f", "goto_next_start",     "@function.outer" },
  { "]]", "goto_next_start",     "@class.outer" },
  { "]F", "goto_next_end",       "@function.outer" },
  { "][", "goto_next_end",       "@class.outer" },
  { "[f", "goto_previous_start", "@function.outer" },
  { "[[", "goto_previous_start", "@class.outer" },
  { "[F", "goto_previous_end",   "@function.outer" },
  { "[]", "goto_previous_end",   "@class.outer" },
}

-- Install a parser the first time a filetype needing it is opened, then start
-- highlighting. Replaces master's auto_install, and covers the languages left
-- out of `parsers` above.
local function ensure_parser(buf, ft)
  local lang = vim.treesitter.language.get_lang(ft)
  if not lang then
    return
  end

  local ts = require("nvim-treesitter")
  if vim.list_contains(ts.get_installed("parsers"), lang) then
    pcall(vim.treesitter.start, buf, lang)
    return
  end

  if not vim.list_contains(ts.get_available(), lang) then
    return
  end

  -- force, for the same reason as the startup install below
  ts.install({ lang }, { force = true }):await(function(err)
    if not err and vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.treesitter.start, buf, lang)
    end
  end)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(ts.get_installed("parsers"), lang)
      end, parsers)
      if #missing > 0 then
        -- force: install() otherwise skips anything listed by get_installed(),
        -- which unions queries with parsers, so a leftover query directory hides
        -- a missing parser and it never gets built. `missing` is already checked
        -- against the parsers only.
        local function install_missing()
          ts.install(missing, { summary = true, force = true })
        end

        if vim.fn.executable("tree-sitter") == 1 then
          install_missing()
        else
          -- Fresh machine: parsers are built by `tree-sitter build`, which mason
          -- installs. Only pull mason in on this path -- loading it eagerly costs
          -- ~200ms of startup for the dap mappings it drags along.
          vim.schedule(function()
            require("lazy").load({ plugins = { "mason.nvim" } })
            local mason = require("mason-registry")
            mason.refresh(function()
              local ok, pkg = pcall(mason.get_package, "tree-sitter-cli")
              if not ok then
                return
              end
              if pkg:is_installed() then
                install_missing()
              else
                pkg:once("install:success", vim.schedule_wrap(install_missing))
              end
            end)
          end)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          ensure_parser(ev.buf, ev.match)

          -- Indent is provided by the plugin and marked experimental upstream
          if pcall(vim.treesitter.get_parser, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- Loaded via `keys` rather than an event: the mappings are the only reason to
    -- load it, and declaring them here keeps them working before it loads.
    keys = function()
      local keys = {}
      for lhs, capture in pairs(selections) do
        table.insert(keys, {
          lhs,
          function()
            require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
          end,
          mode = { "x", "o" },
          desc = "Select " .. capture,
        })
      end
      for _, m in ipairs(movements) do
        local lhs, fname, capture = m[1], m[2], m[3]
        table.insert(keys, {
          lhs,
          function()
            require("nvim-treesitter-textobjects.move")[fname](capture, "textobjects")
          end,
          mode = { "n", "x", "o" },
          desc = "Go to " .. capture,
        })
      end
      -- stylua: ignore start
      table.insert(keys, { "gsa", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end, desc = "Swap next parameter" })
      table.insert(keys, { "gsA", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end, desc = "Swap previous parameter" })
      -- stylua: ignore end
      return keys
    end,
    opts = {
      select = {
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
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
