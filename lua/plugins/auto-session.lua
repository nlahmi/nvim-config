return {
    "rmagatti/auto-session",
    version = "*",
    -- keys = { {"<leader>qs", require("auto-session.session-lens").search_session, desc = "Switch Session"} },
    config = function()
        require("auto-session").setup({
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "D:/Code", "~/Downloads", "/" },
            session_lens = {
                -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
                buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
                load_on_setup = true,
                theme_conf = { border = true },
                -- previewer = true,
                previewer = false,
            },
        })
        vim.keymap.set("n", "<leader>qs", require("auto-session.session-lens").search_session, {
            noremap = true,
            desc = "Switch Session",
        })
    end,
}
