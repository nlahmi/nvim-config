-- nvimide = {
--     debug_restart = false,
--     debug = true,
--     log_fh = nil,
--     log = function(...)
--         if nvimide.debug then
--             local objects = {}
--             for i = 1, select('#', ...) do
--                 local v = select(i, ...)
--                 table.insert(objects, vim.inspect(v))
--             end
--             nvimide.log_fh:write(table.concat(objects, '\n') .. '\n')
--             nvimide.log_fh:flush()
--         end
--     end,
--     script_path = function()
--         return debug.getinfo(2, "S").source:sub(2)
--     end,
-- }
-- if nvimide.debug then
--     nvimide.log_fh = io.open("C:/Users/Noam.L/AppData/Local/Temp/nvimide.log", nvimide.debug_restart and 'w' or 'a')
-- end
-- nvimide.log("Enter " .. nvimide.script_path())
-- vim.g.mapleader = " "
-- require("config.lazy")
-- require("config.keymaps")
-- require("config.autocmds")
-- nvimide.log("Leave " .. nvimide.script_path())


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("keymaps")
require("lazy").setup("plugins")
--require("lazy").setup("plugins.launch")
