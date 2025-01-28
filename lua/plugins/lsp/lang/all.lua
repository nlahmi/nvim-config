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
}

local out = {
    packages = {},
    mason_packages = {},
    nonls_packages = {},
    lsp_config = {},
    dap_config = {},
}

for _, curr_lang in ipairs(all_langs) do
    for key, v in pairs(out) do
        if curr_lang[key] ~= nil then
            vim.list_extend(v, curr_lang[key])
        end
    end
end

-- vim.print(out)

return out
