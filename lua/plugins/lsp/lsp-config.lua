local lang = require("plugins.lsp.lang.all")

local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

-- Source: https://github.com/jdhao/nvim-config/blob/master/lua/config/lsp.lua

-- set quickfix list from diagnostics in a certain buffer, not the whole workspace
local set_qflist = function(buf_num, severity)
  local diagnostics = nil
  diagnostics = diagnostic.get(buf_num, { severity = severity })

  local qf_items = diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, " ", { title = "Diagnostics", items = qf_items })

  -- open quickfix by default
  vim.cmd([[copen]])
end

local custom_attach = function(client, bufnr)
  --print("yay from custom")
  -- Mappings.
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    --opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  -- stylua: ignore
  map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to Definition (Telescope)" })
  map("n", "gD", vim.lsp.buf.definition, { desc = "Go to Definition (qf)" })
  -- map("n", "<C-]>", vim.lsp.buf.definition, { desc = "Go to Definition" })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "<leader>cs", vim.lsp.buf.signature_help, { desc = "Signature" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Variable" })
  -- stylua: ignore
  map("n", "gr", "<cmd>Telescope lsp_references include_declaration=false<cr>", { desc = "Show References (Telescope)" })
  map("n", "gR", vim.lsp.buf.references, { desc = "Show References (qf)" })
  -- stylua: ignore
  map("n", "[d", function() diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous Piagnostic" })
  -- stylua: ignore
  map("n", "]d", function() diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
  -- This puts diagnostics from opened files to quickfix
  -- stylua: ignore
  map("n", "<leader>xw", diagnostic.setqflist, { desc = "Put Window Diagnostics to qf" })
  -- This puts diagnostics from current buffer to quickfix
  -- stylua: ignore
  map("n", "<leader>xb", function() set_qflist(bufnr) end, { desc = "Put buffer diagnostics to qf" })

  map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
  map("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
  map("n", "<leader>co", function()
    vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
  end, { desc = "Organize Imports" })
  map("n", "<leader>cwl", function()
    vim.inspect(vim.lsp.buf.list_workspace_folders())
  end, { desc = "List Workspace Folder" })

  -- Set some key bindings conditional on server capabilities
  -- if client.server_capabilities.documentFormattingProvider then
  map("n", "<leader>cF", vim.lsp.buf.format, { desc = "Format (LSP)" })
  -- end

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always", -- show source in diagnostic popup window
        prefix = " ",
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if
        (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
        and #diagnostic.get() > 0
      then
        diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end,
  })

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.document_highlight()
      end,
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.clear_references()
      end,
    })
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end

  -- Disable hover in ruff
  if client.name == "ruff" then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      format = { timeout_ms = 1000 },
    },
    config = function()
      -- Allow LSPs to use nvim-cmp's completion engine instead of nvim's
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Legacy
      local lspconfig = require("lspconfig")
      -- lspconfig.tsserver.setup({
      --   capabilities = capabilities,
      -- })
      -- lspconfig.html.setup({
      --   capabilities = capabilities,
      -- })
      -- lspconfig.lua_ls.setup({
      --   capabilities = capabilities,
      -- })

      -- TODO: Since nvim 0.11.0, there is a native way to setup LSPs (vim.lsp.config instead of lsp-config)
      for _, f in pairs(lang.lsp_config) do
        f(lspconfig, capabilities, custom_attach)
      end

      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      -- vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      -- vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Go to References" })
      -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
