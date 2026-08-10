return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        -- Drop the window suffix so ]w/[w stay the warning motions from keymaps.lua.
        -- mini.bracketed loads after them and would otherwise silently win.
        require("mini.bracketed").setup({ window = { suffix = "" } })
        require("mini.bufremove").setup()
        require("mini.misc").setup()  -- Todo: add keybindings for utils in here
        require("mini.splitjoin").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()

        vim.keymap.set("n", "<leader>bd", require("mini.bufremove").delete, { desc = "Delete Buffer (Preserve Layout)" })
    end,
}
