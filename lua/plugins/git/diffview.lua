-- maintained fork of sindrets/diffview.nvim, which stalled in 2024
return {
  "dlyongemallo/diffview-plus.nvim",
  name = "diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles" },
  opts = {
    enhanced_diff_hl = true,
    view = {
      -- single window unified diff instead of two side by side panes
      default = { layout = "diff1_inline" },
      file_history = { layout = "diff1_inline" },
      merge_tool = { layout = "diff3_mixed" },
      -- g<C-x> swaps to side by side when the inline view is too tight
      cycle_layouts = { default = { "diff1_inline", "diff2_horizontal", "diff2_vertical" } },
      inline = { style = "unified" },
    },
    file_panel = {
      listing_style = "tree",
      win_config = { width = 60 },
    },
    hooks = {
      -- Pull the PR's viewed state in once the panel exists to render it on
      view_opened = function()
        local gr = require("gitreview")
        gr.load()
        gr.hook_view()
      end,
      selection_changed = function()
        require("gitreview").refresh_markers()
      end,
      -- folds are per window, so reapply them each time a diff buffer appears
      diff_buf_win_enter = function()
        require("gitreview").apply_folds()
      end,
    },
    keymaps = {
      view = {
        { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        -- the diff buffer is not modifiable, so plain letters are free here.
        -- `v` stays visual mode, since commenting on a selection needs it.
        { "n", "V", "<cmd>ReviewViewed<cr>", { desc = "Toggle Viewed" } },
        { "n", "E", "<cmd>ReviewEdit<cr>", { desc = "Edit File" } },
        { "n", "c", "<cmd>ReviewComment<cr>", { desc = "Comment on Line" } },
        { "x", "c", ":ReviewComment<cr>", { desc = "Comment on Selection" } },
        { "n", "P", "<cmd>ReviewPending<cr>", { desc = "Pending Comments" } },
        { "n", "S", "<cmd>ReviewSubmit<cr>", { desc = "Submit Review" } },
        { "n", "D", "<cmd>ReviewDiscard<cr>", { desc = "Discard Review" } },
        { "n", "O", "<cmd>ReviewBrowse<cr>", { desc = "Open PR in Browser" } },
        -- tab skips files already marked viewed
        -- stylua: ignore
        { "n", "<tab>", function() require("gitreview").goto_unviewed(false) end, { desc = "Next unviewed file" } },
        -- stylua: ignore
        { "n", "<s-tab>", function() require("gitreview").goto_unviewed(true) end, { desc = "Prev unviewed file" } },
        -- stylua: ignore
        { "n", "]u", function() require("gitreview").goto_unviewed(false) end, { desc = "Next unviewed file" } },
        -- stylua: ignore
        { "n", "[u", function() require("gitreview").goto_unviewed(true) end, { desc = "Prev unviewed file" } },
        -- these act on the diff window, so they work from the panel too
        -- stylua: ignore
        { "n", "<C-e>", function() require("gitreview").goto_hunk(false) end, { desc = "Next hunk" } },
        -- stylua: ignore
        { "n", "<C-q>", function() require("gitreview").goto_hunk(true) end, { desc = "Prev hunk" } },
        { "n", "L", "<cmd>ReviewLive<cr>", { desc = "Toggle Live Preview" } },
        { "n", "F", "<cmd>ReviewFold<cr>", { desc = "Toggle Fold Unchanged" } },
      },
      file_panel = {
        { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "v", "<cmd>ReviewViewed<cr>", { desc = "Toggle Viewed" } },
        { "n", "e", "<cmd>ReviewEdit<cr>", { desc = "Edit File" } },
        -- selecting a file should hand over focus, unlike a live preview
        -- stylua: ignore
        { "n", "<cr>", function() require("gitreview").select_and_focus() end, { desc = "Open and focus diff" } },
        -- stylua: ignore
        { "n", "o", function() require("gitreview").select_and_focus() end, { desc = "Open and focus diff" } },
        -- stylua: ignore
        { "n", "l", function() require("gitreview").select_and_focus() end, { desc = "Open and focus diff" } },
        { "n", "P", "<cmd>ReviewPending<cr>", { desc = "Pending Comments" } },
        { "n", "S", "<cmd>ReviewSubmit<cr>", { desc = "Submit Review" } },
        { "n", "D", "<cmd>ReviewDiscard<cr>", { desc = "Discard Review" } },
        { "n", "O", "<cmd>ReviewBrowse<cr>", { desc = "Open PR in Browser" } },
        -- stylua: ignore
        { "n", "<tab>", function() require("gitreview").goto_unviewed(false) end, { desc = "Next unviewed file" } },
        -- stylua: ignore
        { "n", "<s-tab>", function() require("gitreview").goto_unviewed(true) end, { desc = "Prev unviewed file" } },
        -- stylua: ignore
        { "n", "]u", function() require("gitreview").goto_unviewed(false) end, { desc = "Next unviewed file" } },
        -- stylua: ignore
        { "n", "[u", function() require("gitreview").goto_unviewed(true) end, { desc = "Prev unviewed file" } },
        -- these act on the diff window, so they work from the panel too
        -- stylua: ignore
        { "n", "<C-e>", function() require("gitreview").goto_hunk(false) end, { desc = "Next hunk" } },
        -- stylua: ignore
        { "n", "<C-q>", function() require("gitreview").goto_hunk(true) end, { desc = "Prev hunk" } },
        { "n", "L", "<cmd>ReviewLive<cr>", { desc = "Toggle Live Preview" } },
        { "n", "F", "<cmd>ReviewFold<cr>", { desc = "Toggle Fold Unchanged" } },
      },
      file_history_panel = {
        { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
    },
  },
}
