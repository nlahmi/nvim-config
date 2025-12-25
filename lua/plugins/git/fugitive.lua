local function add_commit_push(commit_msg)
  vim.cmd(':Git add * | :Git commit -m "' .. commit_msg .. '" | :Git push')
end

local function ask_commit_msg()
  vim.ui.input({ prompt = "Enter commit message: " }, add_commit_push)
end

local function merge_from(branch)
  -- print("Merging from " .. branch)
  vim.cmd(":Git merge " .. branch)
end

local function merge_from_ask()
  vim.cmd(":Git fetch")

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr, map)
      -- Map 'enter' in both insert (i) and normal (n) modes
      local function custom_select()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr) -- Must close manually

        if selection then
          merge_from(selection.value)
        end
      end

      map("i", "<CR>", custom_select)
      map("n", "<CR>", custom_select)

      return true
    end,
  })
end

local function merge_from_default()
  vim.cmd(":Git fetch")
  merge_from(vim.fn['fugitive#Execute']({ 'symbolic-ref', 'refs/remotes/origin/HEAD' }).stdout[1])
end

return {
  "tpope/vim-fugitive",
  lazy = false,
  -- stylua: ignore
  keys = {
    { "<leader>ga", "<cmd>Git add *<cr>", desc = "Add *" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
    { "<leader>gB", "<cmd>Git blame<cr>", desc = "Blame" },
    -- { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Browse" },
    { "<leader>gc", "<cmd>Git commit<cr>i", desc = "Commit" },
    { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Diff (Split)" },
    { "<leader>gD", "<cmd>Git diff<cr>", desc = "Diff" },
    -- { "<leader>ge", "<cmd>Gvsplit<cr>", desc = "Edit (Split)" },
    -- { "<leader>gE", "<cmd>Gedit<cr>", desc = "Edit" },
    { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Fetch" },
    { "<leader>gg", "<cmd>Git<cr>", desc = "Summary" },
    { "<leader>gk", ask_commit_msg, desc = "Commit and Push" },
    { "<leader>gK", function() add_commit_push("auto commit") end, desc = "Auto Commit" },
    { "<leader>gl", "<cmd>Git log<cr>", desc = "Log" },
    { "<leader>gm", merge_from_default, desc = "Merge from (default)" },
    { "<leader>gM", merge_from_ask, desc = "Merge from (ask)" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
    { "<leader>gr", "<cmd>Git pull --rebase<cr>", desc = "Pull (Rebase)" },
    { "<leader>gs", "<cmd>Git stash<cr>", desc = "Stash" },
    { "<leader>gS", "<cmd>Git stash pop<cr>", desc = "Stash Pop" },
    { "<leader>g-", "<cmd>Git checkout -<cr>", desc = "Checkout Previous (-)" },
  },
}
