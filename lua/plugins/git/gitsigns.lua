return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()

    vim.keymap.set("n", "<leader>ghp", ":Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
    vim.keymap.set("n", "<leader>ghP", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview Hunk Inline" })
    vim.keymap.set("n", "<leader>ghq", ":Gitsign setqflist<CR>", { desc = "Show Hunks (qf)" })
    vim.keymap.set("n", "<leader>ghs", ":Gitsign stage_hunk<CR>", { desc = "Stage Hunk" })
    vim.keymap.set("n", "<leader>ghu", ":Gitsign undo_stage_hunk<CR>", { desc = "Unstage Hunk" })
    vim.keymap.set("n", "<leader>ghr", ":Gitsign reset_hunk<CR>", { desc = "Rest Hunk" })
    vim.keymap.set("n", "]h", ":Gitsigns nav_hunk next<CR>", { desc = "Next Hunk" })
    vim.keymap.set("n", "[h", ":Gitsigns nav_hunk prev<CR>", { desc = "Previous Hunk" })

    vim.keymap.set("n", "<leader>ghl", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Line Blame" })
    vim.keymap.set("n", "<leader>ghw", ":Gitsigns toggle_word_diff<CR>", { desc = "Toggle Word Diff" })
    vim.keymap.set("n", "<leader>ghb", ":Gitsigns blame<CR>", { desc = "Git Blame" })
  end,
}
