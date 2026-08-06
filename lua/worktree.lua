local M = {}

local function git(args, cwd)
  return vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
end

-- Parses `git worktree list --porcelain` into records. First record is the main worktree.
function M.list()
  local res = git({ "worktree", "list", "--porcelain" })
  if res.code ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return {}
  end

  local worktrees = {}
  local current

  for line in vim.gsplit(res.stdout or "", "\n") do
    local path = line:match("^worktree (.+)$")
    if path then
      current = { path = path, is_main = #worktrees == 0 }
      table.insert(worktrees, current)
    elseif current then
      local sha = line:match("^HEAD (.+)$")
      local branch = line:match("^branch refs/heads/(.+)$")
      if sha then
        current.sha = sha
      elseif branch then
        current.branch = branch
      end
    end
  end

  for _, wt in ipairs(worktrees) do
    if not wt.branch then
      wt.branch = "(detached " .. string.sub(wt.sha or "", 1, 7) .. ")"
    end
  end

  return worktrees
end

-- auto-session's DirChanged hooks do the session save/wipe/restore around this
function M.switch(path)
  if not path or path == vim.fn.getcwd() then
    return
  end
  if vim.fn.isdirectory(path) == 0 then
    vim.notify("Worktree path does not exist: " .. path, vim.log.levels.ERROR)
    return
  end
  vim.cmd.cd(vim.fn.fnameescape(path))
  vim.notify("Worktree: " .. vim.fn.fnamemodify(path, ":~"))
end

function M.main()
  local worktrees = M.list()
  if worktrees[1] then
    M.switch(worktrees[1].path)
  end
end

-- on_done is called once the delete finishes, whether or not anything was
-- removed, so a caller can restore its UI
local function remove(wt, force, on_done)
  local function done()
    if on_done then
      on_done()
    end
  end

  local args = { "worktree", "remove", wt.path }
  if force then
    table.insert(args, "--force")
  end

  -- Run from the main worktree so git isn't operating from inside the tree it removes
  local worktrees = M.list()
  local res = git(args, worktrees[1] and worktrees[1].path or nil)

  if res.code ~= 0 then
    local err = vim.trim(res.stderr or ""):gsub("^fatal:%s*", "")
    if force then
      vim.notify("Failed to remove worktree: " .. err, vim.log.levels.ERROR)
      done()
      return
    end
    -- The prompt is a single truncated line, so lead with the question and
    -- report git's reason separately
    vim.notify(err, vim.log.levels.WARN)
    vim.ui.select({ "No", "Yes" }, {
      prompt = "Force remove " .. vim.fn.fnamemodify(wt.path, ":t") .. "?",
    }, function(choice)
      if choice == "Yes" then
        remove(wt, true, on_done)
      else
        done()
      end
    end)
    return
  end

  vim.notify("Removed worktree " .. vim.fn.fnamemodify(wt.path, ":~"))
  pcall(vim.cmd, "SessionPurgeOrphaned")
  done()
end

function M.delete(wt, on_done)
  if wt then
    if wt.is_main then
      vim.notify("Refusing to delete the main worktree", vim.log.levels.WARN)
      return
    end
    -- Leave before deleting, otherwise cwd points at a removed directory
    if vim.startswith(vim.fn.getcwd(), wt.path) then
      M.main()
    end
    remove(wt, false, on_done)
    return
  end

  local candidates = vim.tbl_filter(function(candidate)
    return not candidate.is_main
  end, M.list())

  if vim.tbl_isempty(candidates) then
    vim.notify("No worktrees to delete", vim.log.levels.WARN)
    return
  end

  vim.ui.select(candidates, {
    prompt = "Delete worktree:",
    format_item = function(item)
      return item.branch .. "  " .. vim.fn.fnamemodify(item.path, ":~")
    end,
  }, function(choice)
    if choice then
      M.delete(choice)
    end
  end)
end

function M.pick()
  local worktrees = M.list()
  if vim.tbl_isempty(worktrees) then
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local branch_width = 0
  for _, wt in ipairs(worktrees) do
    branch_width = math.max(branch_width, vim.fn.strdisplaywidth(wt.branch))
  end

  local displayer = entry_display.create({
    separator = " ",
    items = { { width = 1 }, { width = branch_width }, { remaining = true } },
  })

  local function make_entry(wt)
    local short = vim.fn.fnamemodify(wt.path, ":~")
    return {
      value = wt,
      ordinal = wt.branch .. " " .. short,
      path = wt.path,
      display = function()
        return displayer({
          wt.path == vim.fn.getcwd() and "*" or " ",
          { wt.branch, "TelescopeResultsIdentifier" },
          { short, "TelescopeResultsComment" },
        })
      end,
    }
  end

  local function new_finder()
    return finders.new_table({ results = M.list(), entry_maker = make_entry })
  end

  pickers
    .new({}, {
      prompt_title = "Worktrees",
      finder = new_finder(),
      sorter = conf.generic_sorter({}),
      -- keep the cursor in place when the list refreshes after a delete
      selection_strategy = "row",
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            M.switch(selection.value.path)
          end
        end)

        -- Stay open so several worktrees can be deleted in one pass
        local function delete_selected()
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          M.delete(selection.value, function()
            local picker = action_state.get_current_picker(prompt_bufnr)
            if picker then
              picker:refresh(new_finder(), { reset_prompt = false })
            else
              -- a confirmation prompt replaced this picker, so start it again
              vim.schedule(M.pick)
            end
          end)
        end

        map("i", "<C-d>", delete_selected)
        map("n", "<C-d>", delete_selected)

        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command("WorktreeList", M.pick, { desc = "List/switch worktrees" })
vim.api.nvim_create_user_command("WorktreeDelete", function()
  M.delete()
end, { desc = "Delete a worktree" })
vim.api.nvim_create_user_command("WorktreeMain", M.main, { desc = "Switch to main worktree" })

vim.keymap.set("n", "<leader>gw", "<cmd>WorktreeList<cr>", { desc = "List Worktrees" })
vim.keymap.set("n", "<leader>gWd", "<cmd>WorktreeDelete<cr>", { desc = "Delete Worktree" })
vim.keymap.set("n", "<leader>gWm", "<cmd>WorktreeMain<cr>", { desc = "Switch to Main Worktree" })

return M
