local all_langs = {
  require("plugins.lsp.lang.python"),
  require("plugins.lsp.lang.lua"),
  require("plugins.lsp.lang.markdown"),
  require("plugins.lsp.lang.java"),
  require("plugins.lsp.lang.clangd"),
  require("plugins.lsp.lang.yaml"),
  require("plugins.lsp.lang.json"),
  require("plugins.lsp.lang.spellcheck"),
  require("plugins.lsp.lang.javascript"),
  require("plugins.lsp.lang.ansible"),
  require("plugins.lsp.lang.dotnet"),
  require("plugins.lsp.lang.go"),
  require("plugins.lsp.lang.cmake"),
  require("plugins.lsp.lang.powershell"),
  require("plugins.lsp.lang.bazel"),
  require("plugins.lsp.lang.sh"),
  require("plugins.lsp.lang.awk"),
  require("plugins.lsp.lang.protobuf"),
}

local out = {
  packages = {},
  mason_packages = {},
  nonls_packages = {},
  lsp_config = {},
  dap_config = {},
  -- LSP server names to pass to vim.lsp.enable
  servers = {},
}

-- Skipped for languages with `enabled = false`: nothing gets downloaded and no
-- plugins load. The lsp keys are still collected, since registering a server
-- config costs nothing and never spawns anything until a matching buffer opens
-- with the binary present -- so installing the mason package is enough to
-- revive a gated language, with no config edit.
local opt_in_keys = { packages = true, mason_packages = true, nonls_packages = true }

for _, curr_lang in ipairs(all_langs) do
  local disabled = curr_lang.enabled == false
  for key, v in pairs(out) do
    if curr_lang[key] ~= nil and not (disabled and opt_in_keys[key]) then
      vim.list_extend(v, curr_lang[key])
    end
  end
end

return out
