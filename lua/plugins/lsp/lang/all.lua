local all_langs = {
    require("plugins.lsp.lang.python"),
    require("plugins.lsp.lang.lua"),
    require("plugins.lsp.lang.markdown"),
    require("plugins.lsp.lang.java"),
}

local out = {
    packages = {},
    mason_packages = {},
    nonls_packages = {},
    lsp_config = {},
}

for _, curr_lang in ipairs(all_langs) do
    for key, v in pairs(out) do
       vim.list_extend(v, curr_lang[key])
    end
end

-- vim.print(out)

return out
