-- Branch review built on the diffview inline layout: resolves the base to diff
-- against, then layers the PR's viewed state, comments and submit on top.
-- Talks to GitHub over `gh` directly.
local M = {}

local ns = vim.api.nvim_create_namespace("gitreview_viewed")

-- Resolved PR per cwd. Cleared on DirChanged, so a worktree swap re-resolves.
local pr_cache = {}
-- Resolved base ref per cwd, for repos or branches with no PR
local base_cache = {}
-- path -> "VIEWED" | "UNVIEWED" | "DISMISSED", mirrored from the API
local viewed = {}
-- pending review id for the PR currently being reviewed
local review_id

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Review" })
end

local function git(args, cwd)
  return vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
end

-- The repo's default branch, for branches with no PR
local function default_base()
  local res = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
  if res.code == 0 then
    return vim.trim(res.stdout)
  end
  for _, name in ipairs({ "origin/master", "origin/main", "master", "main" }) do
    if git({ "rev-parse", "--verify", "--quiet", name }).code == 0 then
      return name
    end
  end
end

-- Prefer the remote-tracking ref so the base is not a stale local branch
local function prefer_remote(branch)
  local remote = "origin/" .. branch
  if git({ "rev-parse", "--verify", "--quiet", remote }).code == 0 then
    return remote
  end
  return branch
end

--- Resolves the ref to diff against: the PR's target branch when there is a PR,
--- otherwise the repo's default branch.
function M.resolve_base(callback)
  local cwd = vim.fn.getcwd()

  -- the review may already have fetched the PR, which carries its base
  local pr = pr_cache[cwd]
  if pr and pr.baseRefName then
    return callback(prefer_remote(pr.baseRefName))
  end
  if base_cache[cwd] then
    return callback(base_cache[cwd])
  end

  local function finish(base)
    if not base then
      notify("Could not determine a base branch", vim.log.levels.WARN)
      return
    end
    base_cache[cwd] = base
    callback(base)
  end

  if vim.fn.executable("gh") == 0 then
    return finish(default_base())
  end

  vim.system(
    { "gh", "pr", "view", "--json", "baseRefName", "-q", ".baseRefName" },
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(res)
      local branch = res.code == 0 and vim.trim(res.stdout or "") or ""
      if branch == "" then
        return finish(default_base())
      end
      finish(prefer_remote(branch))
    end)
  )
end

-- The base revision itself, so a diff is pinned to a commit rather than a
-- moving branch tip.
local function merge_base(base)
  local res = git({ "merge-base", base, "HEAD" })
  return res.code == 0 and vim.trim(res.stdout) or base
end

--- Runs `gh` asynchronously and hands decoded json to `callback`.
local function gh(args, callback, on_error)
  vim.system({ "gh", unpack(args) }, { text = true }, function(res)
    if res.code ~= 0 then
      local err = vim.trim(res.stderr or "")
      vim.schedule(function()
        if on_error then
          on_error(err)
        else
          notify(err ~= "" and err or "gh failed", vim.log.levels.ERROR)
        end
      end)
      return
    end
    local ok, decoded = pcall(vim.json.decode, res.stdout)
    vim.schedule(function()
      callback(ok and decoded or nil)
    end)
  end)
end

local FILES_QUERY = [[
query($owner:String!,$repo:String!,$num:Int!,$cursor:String){
  repository(owner:$owner,name:$repo){
    pullRequest(number:$num){
      id
      headRefOid
      files(first:100,after:$cursor){
        pageInfo { hasNextPage endCursor }
        nodes { path viewerViewedState }
      }
    }
  }
}]]

--- Resolves the PR for the current directory and loads its viewed state.
function M.load(callback)
  local cwd = vim.fn.getcwd()
  local cached = pr_cache[cwd]
  if cached then
    -- a reopened panel is a fresh buffer, so it still needs painting
    M.refresh_markers()
    return callback and callback(cached)
  end

  local function no_pr()
    notify("No pull request for this branch", vim.log.levels.WARN)
  end

  gh({ "pr", "view", "--json", "number,id,headRefOid,baseRefName,url" }, function(pr)
    if not pr or not pr.number then
      return no_pr()
    end

    gh({ "repo", "view", "--json", "owner,name" }, function(repo)
      if not repo then
        return
      end
      pr.owner = repo.owner and repo.owner.login
      pr.repo = repo.name
      pr_cache[cwd] = pr

      -- Page through the file list so large PRs report viewed state fully
      local function fetch(cursor)
        local args = {
          "api",
          "graphql",
          "-f",
          "query=" .. FILES_QUERY,
          "-F",
          "owner=" .. pr.owner,
          "-F",
          "repo=" .. pr.repo,
          "-F",
          "num=" .. pr.number,
        }
        if cursor then
          table.insert(args, "-F")
          table.insert(args, "cursor=" .. cursor)
        end

        gh(args, function(data)
          local node = data
            and data.data
            and data.data.repository
            and data.data.repository.pullRequest
          if not node then
            return
          end
          for _, f in ipairs(node.files.nodes or {}) do
            viewed[f.path] = f.viewerViewedState
          end
          if node.files.pageInfo and node.files.pageInfo.hasNextPage then
            return fetch(node.files.pageInfo.endCursor)
          end
          M.refresh_markers()
          if callback then
            callback(pr)
          end
        end)
      end

      fetch(nil)
    end)
  end, no_pr)
end

function M.clear_cache()
  pr_cache = {}
  base_cache = {}
  viewed = {}
  review_id = nil
end

local function current_view()
  local ok, lib = pcall(require, "diffview.lib")
  return ok and lib.get_current_view() or nil
end

-- Panel buffers we have already hooked for repaints
local watched = {}

-- The panel re-renders by replacing every line, which drops our extmarks along
-- with it. Repaint whenever its lines change instead of chasing render calls.
local function watch_panel(bufnr)
  if watched[bufnr] then
    return
  end
  watched[bufnr] = true
  vim.api.nvim_buf_attach(bufnr, false, {
    on_lines = function()
      if not watched[bufnr] then
        return true
      end
      vim.schedule(function()
        M.refresh_markers()
      end)
    end,
    on_detach = function()
      watched[bufnr] = nil
    end,
  })
end

--- Paints a marker beside every viewed file in the diffview file panel.
function M.refresh_markers()
  local view = current_view()
  local panel = view and view.panel
  if not panel or not panel:is_open() or not panel.bufid then
    return
  end
  if not vim.api.nvim_buf_is_valid(panel.bufid) then
    return
  end

  watch_panel(panel.bufid)
  vim.api.nvim_buf_clear_namespace(panel.bufid, ns, 0, -1)

  local total = vim.api.nvim_buf_line_count(panel.bufid)
  for lnum = 1, total do
    local ok, item = pcall(panel.get_item_at_line, panel, lnum)
    -- directory nodes carry a path too, so key off the file-only field
    local path = ok and type(item) == "table" and item.absolute_path and item.path or nil
    if path and viewed[path] == "VIEWED" then
      pcall(vim.api.nvim_buf_set_extmark, panel.bufid, ns, lnum - 1, 0, {
        virt_text = { { " ✓", "DiffviewFilePanelInsertions" } },
        virt_text_pos = "eol",
        hl_mode = "combine",
      })
    end
  end
end

-- Directory nodes in the panel look like entries but have no file behind them
local function is_file_entry(item)
  return type(item) == "table" and item.absolute_path ~= nil and item.path ~= nil
end

--- True when the panel cursor is on the panel buffer.
local function in_panel(view)
  local panel = view and view.panel
  return panel
    and panel:is_open()
    and panel.bufid
    and vim.api.nvim_get_current_buf() == panel.bufid
end

--- The file under the cursor, whether in the panel or a diff window.
local function current_file()
  local view = current_view()
  if not view then
    return nil
  end
  if in_panel(view) then
    local ok, item = pcall(view.panel.get_item_at_cursor, view.panel)
    if ok and is_file_entry(item) then
      return item
    end
  end
  return view.cur_entry
end

--- Every file entry beneath the directory under the cursor.
local function files_under_cursor_dir()
  local view = current_view()
  if not in_panel(view) then
    return nil
  end

  local ok, item = pcall(view.panel.get_item_at_cursor, view.panel)
  if not ok or is_file_entry(item) then
    return nil
  end

  local dok, _, comp = pcall(view.panel.get_dir_at_cursor, view.panel)
  if not dok or not comp then
    return nil
  end

  local files = {}
  local function walk(node)
    if node.name == "file" and is_file_entry(node.context) then
      table.insert(files, node.context)
    end
    for _, child in ipairs(node.components or {}) do
      walk(child)
    end
  end
  walk(comp)

  return files, item.name or item.path
end

-- Sends one mark/unmark mutation for `path`.
local function set_viewed(pr, path, want_viewed, callback)
  local mutation = want_viewed and "markFileAsViewed" or "unmarkFileAsViewed"
  local query = ([[
mutation($id:ID!,$path:String!){
  %s(input:{pullRequestId:$id,path:$path}){ clientMutationId }
}]]):format(mutation)

  gh({
    "api",
    "graphql",
    "-f",
    "query=" .. query,
    "-F",
    "id=" .. pr.id,
    "-F",
    "path=" .. path,
  }, function()
    viewed[path] = want_viewed and "VIEWED" or "UNVIEWED"
    if callback then
      callback()
    end
  end)
end

function M.toggle_viewed()
  -- on a directory, apply to everything beneath it
  local dir_files, dir_name = files_under_cursor_dir()
  if dir_files then
    if vim.tbl_isempty(dir_files) then
      notify("No files under " .. tostring(dir_name), vim.log.levels.WARN)
      return
    end

    -- mark all unless every file is already viewed, then clear them
    local all_viewed = true
    for _, f in ipairs(dir_files) do
      if viewed[f.path] ~= "VIEWED" then
        all_viewed = false
        break
      end
    end
    local want = not all_viewed

    M.load(function(pr)
      local remaining = #dir_files
      for _, f in ipairs(dir_files) do
        set_viewed(pr, f.path, want, function()
          remaining = remaining - 1
          M.refresh_markers()
          if remaining == 0 then
            notify(
              (want and "Viewed " or "Unviewed ") .. #dir_files .. " files in " .. tostring(dir_name)
            )
          end
        end)
      end
    end)
    return
  end

  local file = current_file()
  if not file then
    notify("No file under the cursor", vim.log.levels.WARN)
    return
  end

  M.load(function(pr)
    local want = viewed[file.path] ~= "VIEWED"
    set_viewed(pr, file.path, want, function()
      M.refresh_markers()
      notify((want and "Viewed " or "Unviewed ") .. file.basename)
    end)
  end)
end

-- Folding of unchanged regions in the inline diff. Sticky via shada.
local CONTEXT = 4

function M.folds_enabled()
  local on = vim.g.GITREVIEW_FOLD
  if on == nil then
    return false
  end
  return on
end

-- Folds are per window and applied per buffer, so remember which buffer each
-- window was folded for. The hook can fire while the outgoing buffer is still
-- attached, which would otherwise fold the file we are leaving.
local folded_for = {}

--- Folds everything except a few lines of context around each hunk.
--- The inline diff attaches asynchronously, so retry until it is ready.
function M.apply_folds(attempt)
  local view = current_view()
  local main = view and view.cur_layout and view.cur_layout:get_main_win()
  if not main or not vim.api.nvim_win_is_valid(main.id) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(main.id)
  local entry = view.cur_entry
  local expected = entry and entry.absolute_path

  -- foldmethod=manual on a window with 'diff' set can lock Neovim into a
  -- redraw loop, so only fold the inline layout, which is not in diff mode.
  -- See the note at diffview scene/views/standard/standard_view.lua:472
  if vim.wo[main.id].diff then
    vim.api.nvim_win_call(main.id, function()
      vim.wo.foldenable = false
    end)
    folded_for[main.id] = nil
    return
  end

  local ok, inline = pcall(require, "diffview.scene.inline_diff")
  if not ok then
    return
  end
  local rows_ok, rows = pcall(inline.hunk_anchor_rows, buf)

  -- Retry while the window still shows the previous file, or the diff for the
  -- current one has not been computed yet
  local stale = expected and vim.api.nvim_buf_get_name(buf) ~= expected
  local no_rows = not rows_ok or not rows or vim.tbl_isempty(rows)
  if M.folds_enabled() and (stale or no_rows) then
    attempt = (attempt or 0) + 1
    if attempt <= 30 then
      -- poll quickly, the wait is only until the diff finishes computing
      vim.defer_fn(function()
        M.apply_folds(attempt)
      end, 10)
      return
    end
  end

  if M.folds_enabled() and folded_for[main.id] == buf then
    return
  end
  folded_for[main.id] = M.folds_enabled() and buf or nil

  vim.api.nvim_win_call(main.id, function()
    if not M.folds_enabled() or not rows_ok or not rows or vim.tbl_isempty(rows) then
      vim.wo.foldenable = false
      return
    end

    vim.wo.foldmethod = "manual"
    vim.wo.foldenable = true
    vim.wo.foldlevel = 0
    vim.cmd("normal! zE")

    local total = vim.api.nvim_buf_line_count(buf)
    -- rows are 0-indexed anchors, so build keep-ranges in 1-indexed lines
    local keep = {}
    for _, r in ipairs(rows) do
      local lnum = r + 1
      table.insert(keep, { math.max(1, lnum - CONTEXT), math.min(total, lnum + CONTEXT) })
    end
    table.sort(keep, function(a, b)
      return a[1] < b[1]
    end)

    -- merge overlapping keep-ranges, then fold the gaps between them
    local merged = {}
    for _, range in ipairs(keep) do
      local last = merged[#merged]
      if last and range[1] <= last[2] + 1 then
        last[2] = math.max(last[2], range[2])
      else
        table.insert(merged, { range[1], range[2] })
      end
    end

    local cursor = 1
    for _, range in ipairs(merged) do
      if range[1] > cursor then
        vim.cmd(cursor .. "," .. (range[1] - 1) .. "fold")
      end
      cursor = range[2] + 1
    end
    if cursor <= total then
      vim.cmd(cursor .. "," .. total .. "fold")
    end
  end)
end

function M.toggle_folds()
  vim.g.GITREVIEW_FOLD = not M.folds_enabled()
  notify("Fold unchanged " .. (M.folds_enabled() and "on" or "off"))
  M.apply_folds()
end

-- `file_open_post` fires once the entry's buffers are in place, which is much
-- earlier than waiting for diff_buf_win_enter to settle.
local hooked_views = {}

function M.hook_view()
  local view = current_view()
  if not view or not view.emitter or hooked_views[view] then
    return
  end
  hooked_views[view] = true
  view.emitter:on("file_open_post", function()
    M.apply_folds()
  end)
end

--- Jumps to the next or previous hunk, scrolling it into view.
--- Virtual lines mean a tall hunk can start on screen and still run past the
--- bottom, so put its start near the top rather than leaving it at the edge.
function M.goto_hunk(backwards)
  local actions = require("diffview.actions")
  local view = current_view()
  local main = view and view.cur_layout and view.cur_layout:get_main_win()
  if not main or not vim.api.nvim_win_is_valid(main.id) then
    return
  end

  local before = vim.api.nvim_win_get_cursor(main.id)[1]
  if backwards then
    actions.prev_inline_hunk()
  else
    actions.next_inline_hunk()
  end

  local after = vim.api.nvim_win_get_cursor(main.id)[1]
  if after == before then
    -- already at the last or first hunk, so scroll instead of sitting still
    vim.api.nvim_win_call(main.id, function()
      vim.cmd("normal! " .. (backwards and "\25" or "\5"))
    end)
    return
  end

  vim.api.nvim_win_call(main.id, function()
    local info = vim.fn.getwininfo(main.id)[1]
    local visible = math.max(1, info.botline - info.topline)
    -- reveal what follows the hunk start when the window shows few real lines
    if visible < 8 then
      vim.cmd("normal! zt")
    else
      vim.cmd("normal! zz")
    end
  end)
end

--- Opens the entry under the cursor and moves focus into the diff.
function M.select_and_focus()
  local actions = require("diffview.actions")
  local view = current_view()

  -- directories just fold, there is nothing to focus
  local dir_files = files_under_cursor_dir()
  if dir_files then
    actions.select_entry()
    return
  end

  live_last = nil
  actions.select_entry()

  -- select_entry opens asynchronously, so focus once the window is there
  vim.defer_fn(function()
    local v = current_view()
    local main = v and v.cur_layout and v.cur_layout:get_main_win()
    if main and vim.api.nvim_win_is_valid(main.id) then
      vim.api.nvim_set_current_win(main.id)
    end
  end, 60)
end

--- Moves to the next file whose viewed state is not VIEWED.
function M.goto_unviewed(backwards)
  local view = current_view()
  if not view then
    return
  end

  local files = {}
  for _, f in view.files:iter() do
    table.insert(files, f)
  end
  if vim.tbl_isempty(files) then
    return
  end

  local start = 1
  for i, f in ipairs(files) do
    if view.cur_entry and f.path == view.cur_entry.path then
      start = i
      break
    end
  end

  local step = backwards and -1 or 1
  for offset = 1, #files do
    local idx = ((start - 1 + step * offset) % #files) + 1
    if viewed[files[idx].path] ~= "VIEWED" then
      -- Focusing here makes the layout split rather than reuse its window, so
      -- leave focus alone and let the panel keep it
      view:set_file(files[idx], false, true)
      return
    end
  end

  notify("No unviewed files left")
end

--- Opens the file under the cursor for editing, outside the review layout.
function M.edit_file()
  local file = current_file()
  if not file or not file.absolute_path then
    notify("No file under the cursor", vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(file.absolute_path) == 0 then
    notify("File does not exist in the working tree", vim.log.levels.WARN)
    return
  end
  -- goto_file_edit lands in the tabpage the review was opened from
  local ok = pcall(function()
    require("diffview.actions").goto_file_edit()
  end)
  if not ok then
    vim.cmd.tabedit(vim.fn.fnameescape(file.absolute_path))
  end
end

-- Live preview: show the file under the panel cursor without selecting it.
-- The uppercase global survives restarts via shada, so the choice sticks.
-- Read lazily, since shada restores after plugin files have run.
local live_timer
local live_last

function M.live_enabled()
  local live = vim.g.GITREVIEW_LIVE
  if live == nil then
    return true
  end
  return live
end

-- Rapid set_file calls can strand empty scratch windows that belong to no
-- layout, so drop anything that is neither the panel nor a layout window.
local function close_stray_windows(view)
  local keep = {}
  if view.panel and view.panel.winid then
    keep[view.panel.winid] = true
  end
  local layout = view.cur_layout
  for _, sym in ipairs({ "a", "b", "c", "d" }) do
    local w = layout and layout[sym]
    if w and w.id then
      keep[w.id] = true
    end
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not keep[win] then
      local buf = vim.api.nvim_win_get_buf(win)
      local empty = vim.api.nvim_buf_get_name(buf) == ""
        and vim.api.nvim_buf_line_count(buf) <= 2
      if empty then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end
end

local function preview_hovered()
  local view = current_view()
  local panel = view and view.panel
  if not panel or not panel:is_open() then
    return
  end
  if vim.api.nvim_get_current_buf() ~= panel.bufid then
    return
  end

  local ok, item = pcall(panel.get_item_at_cursor, panel)
  if not ok or not is_file_entry(item) then
    return
  end
  if live_last == item.path then
    return
  end
  live_last = item.path
  -- no focus, so the cursor stays in the panel while browsing
  view:set_file(item, false, false)
  vim.defer_fn(function()
    local v = current_view()
    if v then
      close_stray_windows(v)
    end
  end, 120)
end

function M.toggle_live()
  local live = not M.live_enabled()
  live_last = nil
  vim.g.GITREVIEW_LIVE = live
  notify("Live preview " .. (live and "on" or "off"))
  if live then
    preview_hovered()
  end
end

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function(args)
    if not M.live_enabled() then
      return
    end
    local view = current_view()
    local panel = view and view.panel
    if not panel or args.buf ~= panel.bufid then
      return
    end
    -- debounce, since holding j would open a file per row
    if live_timer then
      pcall(function()
        live_timer:stop()
      end)
    end
    live_timer = vim.defer_fn(preview_hovered, 90)
  end,
})

--- Opens the review: diffview against the merge base with the base branch.
function M.open(base)
  local function run(resolved)
    vim.cmd("DiffviewOpen " .. resolved .. "...")
  end

  if base then
    run(base)
  else
    M.resolve_base(run)
  end
end

-- Runs `fn` against a base picked from the branch list.
local function with_chosen_base(fn)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          fn(selection.value)
        end
      end)
      return true
    end,
  })
end

function M.open_against()
  with_chosen_base(M.open)
end

--- Points gitsigns at the base, so signs and ]h/[h cover the whole branch
--- rather than only uncommitted work.
function M.set_signs_base(base)
  local function run(resolved)
    require("gitsigns").change_base(merge_base(resolved), true)
    notify("Gitsigns base: " .. resolved)
  end

  if base then
    run(base)
  else
    M.resolve_base(run)
  end
end

function M.reset_signs_base()
  require("gitsigns").change_base(nil, true)
  notify("Gitsigns base: HEAD")
end

-- mini.bracketed maps ]c/[c to comment blocks globally, which shadows the
-- builtin diff hunk motions. Restore them wherever a diff is actually open,
-- unless something already provides its own (diffview does in inline mode).
local function sync_hunk_maps()
  local buf = vim.api.nvim_get_current_buf()
  local mapped = vim.b[buf].gitreview_hunk_maps

  if vim.wo.diff then
    if mapped then
      return
    end
    if vim.fn.maparg("]c", "n", false, true).buffer == 1 then
      return
    end
    for _, lhs in ipairs({ "]c", "[c" }) do
      vim.keymap.set("n", lhs, function()
        vim.cmd("normal! " .. lhs)
      end, { buf = buf, desc = "Next/prev diff hunk" })
    end
    vim.b[buf].gitreview_hunk_maps = true
  elseif mapped then
    pcall(vim.keymap.del, "n", "]c", { buf = buf })
    pcall(vim.keymap.del, "n", "[c", { buf = buf })
    vim.b[buf].gitreview_hunk_maps = nil
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "OptionSet" }, {
  callback = function()
    sync_hunk_maps()
  end,
})

-- Commands like `:Gvdiffsplit` set 'diff' without firing the events above, so
-- sweep the windows once the command has finished.
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    vim.schedule(function()
      local cur = vim.api.nvim_get_current_win()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.wo[win].diff then
          vim.api.nvim_win_call(win, sync_hunk_maps)
        end
      end
      if vim.api.nvim_win_is_valid(cur) then
        vim.api.nvim_set_current_win(cur)
      end
    end)
  end,
})

-- Ensures a pending review exists, so comments stay invisible until submitted.
local function ensure_review(pr, callback)
  if review_id then
    return callback(review_id)
  end

  local query = [[
query($owner:String!,$repo:String!,$num:Int!){
  repository(owner:$owner,name:$repo){
    pullRequest(number:$num){
      reviews(states:PENDING,first:1){ nodes { id } }
    }
  }
}]]

  gh({
    "api",
    "graphql",
    "-f",
    "query=" .. query,
    "-F",
    "owner=" .. pr.owner,
    "-F",
    "repo=" .. pr.repo,
    "-F",
    "num=" .. pr.number,
  }, function(data)
    local nodes = data
      and data.data
      and data.data.repository
      and data.data.repository.pullRequest
      and data.data.repository.pullRequest.reviews
      and data.data.repository.pullRequest.reviews.nodes
    if nodes and nodes[1] then
      review_id = nodes[1].id
      return callback(review_id)
    end

    local create = [[
mutation($id:ID!){ addPullRequestReview(input:{pullRequestId:$id}){ pullRequestReview { id } } }]]
    gh({ "api", "graphql", "-f", "query=" .. create, "-F", "id=" .. pr.id }, function(res)
      local review = res
        and res.data
        and res.data.addPullRequestReview
        and res.data.addPullRequestReview.pullRequestReview
      if not review then
        notify("Could not start a review", vim.log.levels.ERROR)
        return
      end
      review_id = review.id
      notify("Started a pending review")
      callback(review_id)
    end)
  end)
end

-- Which side of the diff the cursor is on, since GitHub anchors per side.
local function diff_side()
  local view = current_view()
  local layout = view and view.cur_layout
  if not layout then
    return "RIGHT"
  end
  local win = vim.api.nvim_get_current_win()
  if layout.a and layout.a.id == win then
    return "LEFT"
  end
  return "RIGHT"
end

--- Comments on the current line or visual selection, into the pending review.
function M.comment(line1, line2)
  local file = current_file()
  if not file then
    notify("No file under the cursor", vim.log.levels.WARN)
    return
  end

  line1 = line1 or vim.fn.line(".")
  line2 = line2 or line1
  if line2 < line1 then
    line1, line2 = line2, line1
  end

  local side = diff_side()
  local where = file.path .. ":" .. line1 .. (line2 ~= line1 and "-" .. line2 or "")

  vim.ui.input({ prompt = "Comment on " .. where .. ": " }, function(body)
    if not body or vim.trim(body) == "" then
      return
    end

    M.load(function(pr)
      ensure_review(pr, function(id)
        local query = [[
mutation($review:ID!,$path:String!,$body:String!,$line:Int!,$startLine:Int,$side:DiffSide!){
  addPullRequestReviewThread(input:{
    pullRequestReviewId:$review, path:$path, body:$body,
    line:$line, startLine:$startLine, side:$side, startSide:$side
  }){ thread { id } }
}]]
        local args = {
          "api",
          "graphql",
          "-f",
          "query=" .. query,
          "-F",
          "review=" .. id,
          "-F",
          "path=" .. file.path,
          "-F",
          "body=" .. body,
          "-F",
          "line=" .. line2,
          "-F",
          "side=" .. side,
        }
        if line2 ~= line1 then
          table.insert(args, "-F")
          table.insert(args, "startLine=" .. line1)
        end

        gh(args, function()
          notify("Comment added to the pending review (" .. where .. ")")
        end)
      end)
    end)
  end)
end

--- Lists the comments sitting in the pending review.
function M.pending()
  M.load(function(pr)
    local query = [[
query($owner:String!,$repo:String!,$num:Int!){
  repository(owner:$owner,name:$repo){
    pullRequest(number:$num){
      reviews(states:PENDING,first:1){
        nodes { comments(first:100){ nodes { path line body } } }
      }
    }
  }
}]]
    gh({
      "api",
      "graphql",
      "-f",
      "query=" .. query,
      "-F",
      "owner=" .. pr.owner,
      "-F",
      "repo=" .. pr.repo,
      "-F",
      "num=" .. pr.number,
    }, function(data)
      local nodes = data
        and data.data
        and data.data.repository
        and data.data.repository.pullRequest
        and data.data.repository.pullRequest.reviews
        and data.data.repository.pullRequest.reviews.nodes
      local comments = nodes and nodes[1] and nodes[1].comments and nodes[1].comments.nodes or {}
      if vim.tbl_isempty(comments) then
        notify("No pending comments")
        return
      end

      local items = {}
      for _, c in ipairs(comments) do
        table.insert(items, {
          filename = c.path,
          lnum = c.line or 1,
          text = (c.body or ""):gsub("%s+", " "),
        })
      end
      vim.fn.setqflist({}, " ", { title = "Pending review comments", items = items })
      vim.cmd.copen()
    end)
  end)
end

local EVENTS = {
  Comment = "COMMENT",
  Approve = "APPROVE",
  ["Request changes"] = "REQUEST_CHANGES",
}

--- Submits the pending review. This is the point where comments become public.
function M.submit()
  M.load(function(pr)
    vim.ui.select({ "Comment", "Approve", "Request changes" }, {
      prompt = "Submit review as:",
    }, function(choice)
      if not choice then
        return
      end
      local event = EVENTS[choice]

      ensure_review(pr, function(id)
        vim.ui.input({ prompt = choice .. " summary (optional): " }, function(body)
          if body == nil then
            return
          end
          vim.ui.select({ "No", "Yes" }, {
            prompt = "Submit as " .. event .. " to #" .. pr.number .. "?",
          }, function(confirm)
            if confirm ~= "Yes" then
              notify("Review not submitted")
              return
            end

            local query = [[
mutation($review:ID!,$event:PullRequestReviewEvent!,$body:String){
  submitPullRequestReview(input:{pullRequestReviewId:$review,event:$event,body:$body}){
    pullRequestReview { state url }
  }
}]]
            local args = {
              "api",
              "graphql",
              "-f",
              "query=" .. query,
              "-F",
              "review=" .. id,
              "-F",
              "event=" .. event,
            }
            if vim.trim(body) ~= "" then
              table.insert(args, "-F")
              table.insert(args, "body=" .. body)
            end

            gh(args, function()
              review_id = nil
              notify("Submitted " .. event .. " on #" .. pr.number)
            end)
          end)
        end)
      end)
    end)
  end)
end

--- Discards the pending review and everything in it.
function M.discard()
  M.load(function(pr)
    ensure_review(pr, function(id)
      vim.ui.select({ "No", "Yes" }, { prompt = "Discard the pending review?" }, function(choice)
        if choice ~= "Yes" then
          return
        end
        local query = [[
mutation($review:ID!){ deletePullRequestReview(input:{pullRequestReviewId:$review}){ clientMutationId } }]]
        gh({ "api", "graphql", "-f", "query=" .. query, "-F", "review=" .. id }, function()
          review_id = nil
          notify("Discarded the pending review")
        end)
      end)
    end)
  end)
end

function M.open_in_browser()
  M.load(function(pr)
    vim.ui.open(pr.url)
  end)
end

vim.api.nvim_create_user_command("Review", function(opts)
  M.open(opts.args ~= "" and opts.args or nil)
end, { nargs = "?", desc = "Review changes against the base branch" })
vim.api.nvim_create_user_command("ReviewAgainst", M.open_against, {
  desc = "Review changes against a chosen branch",
})
vim.api.nvim_create_user_command("ReviewSigns", function(opts)
  M.set_signs_base(opts.args ~= "" and opts.args or nil)
end, { nargs = "?", desc = "Set the gitsigns base to the base branch" })
vim.api.nvim_create_user_command("ReviewSignsReset", M.reset_signs_base, {
  desc = "Reset the gitsigns base to HEAD",
})
vim.api.nvim_create_user_command("ReviewViewed", M.toggle_viewed, { desc = "Toggle file viewed" })
vim.api.nvim_create_user_command("ReviewComment", function(opts)
  M.comment(opts.line1, opts.line2)
end, { range = true, desc = "Comment on the current line or selection" })
vim.api.nvim_create_user_command("ReviewEdit", M.edit_file, { desc = "Edit the file under the cursor" })
vim.api.nvim_create_user_command("ReviewLive", M.toggle_live, { desc = "Toggle live preview on hover" })
vim.api.nvim_create_user_command("ReviewFold", M.toggle_folds, { desc = "Toggle folding of unchanged lines" })
vim.api.nvim_create_user_command("ReviewPending", M.pending, { desc = "List pending comments" })
vim.api.nvim_create_user_command("ReviewSubmit", M.submit, { desc = "Submit the pending review" })
vim.api.nvim_create_user_command("ReviewDiscard", M.discard, { desc = "Discard the pending review" })
vim.api.nvim_create_user_command("ReviewLoad", function()
  M.clear_cache()
  M.load(function(pr)
    notify("PR #" .. pr.number .. " loaded")
  end)
end, { desc = "Reload PR review state" })
vim.api.nvim_create_user_command("ReviewBrowse", M.open_in_browser, { desc = "Open the PR in a browser" })

-- A new worktree or branch means a different PR, so drop everything resolved
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "global",
  callback = M.clear_cache,
})

vim.keymap.set("n", "<leader>gv", "<cmd>Review<cr>", { desc = "Review vs Base" })
vim.keymap.set("n", "<leader>gVv", "<cmd>ReviewAgainst<cr>", { desc = "Review vs Branch" })
vim.keymap.set("n", "<leader>gVh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File History" })
vim.keymap.set("n", "<leader>gVs", "<cmd>ReviewSigns<cr>", { desc = "Gitsigns Base to Base Branch" })
vim.keymap.set("n", "<leader>gVS", "<cmd>ReviewSignsReset<cr>", { desc = "Gitsigns Base to HEAD" })

return M
