return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          preview = {
            filesize_limit = 10.9999,
            timeout = 250,
            -- Disable tree-sitter in telescope for performance
            -- treesitter = false
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
      -- vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep in Files" })
      -- vim.keymap.set("n", "<leader>fg", function() builtin.live_grep({ debounce = 100 }) end, { desc = "Grep in Files" })
      vim.keymap.set("n", "<leader>fG", builtin.grep_string, { desc = "Grep in Files (Current Directory)" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume Telescope" })
      vim.keymap.set("n", "<leader>fR", builtin.pickers, { desc = "Resume Telescope (Pickers)" })
      -- vim.keymap.set("n", "?", builtin.current_buffer_fuzzy_find, { desc = "Resume Telescope (Pickers)" })

      require("telescope").load_extension("ui-select")
    end,
    -- stylua: ignore
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find Files (Hidden)", },
    },
  },
}
