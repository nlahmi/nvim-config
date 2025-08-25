-- File_exists = function(name)
--   local f = io.open(name, "r")
--   if f ~= nil then
--     io.close(f)
--     return true
--   else
--     return false
--   end
-- end

P = function(v)
  print(vim.inspect(v))
  return v
end

return {

  -- get_py_exe = function(install_path)
  --   if File_exists(install_path .. "/venv/bin/python") then
  --     -- print("bin/python")
  --     return install_path .. "/venv/bin/python"
  --   end
  --
  --   -- print("Scripts/pythonw")
  --   return install_path .. "/venv/Scripts/pythonw"
  -- end,

  -- get_py_exe = function(venv_path)
  --   if venv_path == nil then
  --     venv_path = os.getenv("VIRTUAL_ENV")
  --   end
  --   if venv_path == nil then
  --     venv_path = ""
  --   end
  --
  --   local options = {
  --     venv_path .. "/bin/python",
  --     venv_path .. "/Scripts/pythonw",
  --     "python",
  --     "python3",
  --   }
  --
  --   for _, x in pairs(options) do
  --     if vim.fn.executable(x) == 1 then
  --       return x
  --     end
  --   end
  -- end,

  icons = {
    misc = {
      dots = "󰇘",
    },
    dap = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    kinds = {
      Array = " ",
      Boolean = "󰨙 ",
      Class = " ",
      Codeium = "󰘦 ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = "󰏿 ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "󰊕 ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = "󰊕 ",
      Module = " ",
      Namespace = "󰦮 ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = "󰆼 ",
      TabNine = "󰏚 ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = "󰀫 ",
    },
  },
}
