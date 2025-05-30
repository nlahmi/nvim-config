local function add_commit_push(commit_msg)
  vim.cmd(':Git add * | :Git commit -m "' .. commit_msg .. '" | :Git push')
end

local function ask_commit_msg()
  vim.ui.input({ prompt = "Enter commit message: " }, add_commit_push)
end

return {
  "tpope/vim-fugitive",
  lazy = false,
  keys = {
    { "<leader>ga", "<cmd>Git add *<cr>", desc = "Add *" },
    { "<leader>gb", "<cmd>GBrowse<cr>", desc = "Browse" },
    { "<leader>gc", "<cmd>Git commit<cr>i", desc = "Commit" },
    { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Diff (Split)" },
    { "<leader>gD", "<cmd>Git diff<cr>", desc = "Diff" },
    { "<leader>ge", "<cmd>Gvsplit<cr>", desc = "Edit (Split)" },
    { "<leader>gE", "<cmd>Gedit<cr>", desc = "Edit" },
    { "<leader>gg", "<cmd>Git<cr>", desc = "Summary" },
    { "<leader>gk", ask_commit_msg, desc = "Commit and Push" },
    { "<leader>gK", function() add_commit_push("auto commit") end, desc = "Auto Commit" },
    { "<leader>gl", "<cmd>Git log<cr>", desc = "Log" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
    { "<leader>gr", "<cmd>Git pull --rebase<cr>", desc = "Pull (Rebase)" },
  },
}
