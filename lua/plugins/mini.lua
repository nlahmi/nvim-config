return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        require("mini.bracketed").setup()
        require("mini.bufremove").setup()
        require("mini.misc").setup()  -- Todo: add keybindings for utils in here
        require("mini.splitjoin").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()

        vim.keymap.set("n", "<leader>bd", require("mini.bufremove").delete, { desc = "Delete Buffer (Preserve Layout)" })
    end,
}
