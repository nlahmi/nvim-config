return {
    "rmagatti/auto-session",
    version = "*",
    -- keys = { {"<leader>qs", require("auto-session.session-lens").search_session, desc = "Switch Session"} },
    config = function()
        require("auto-session").setup({
            log_level = "error",
            suppressed_dirs = { "~/", "~/Projects", "D:/Code", "~/Downloads", "/" },
            -- Treat a cd as a workspace swap: save the old session, restore the new one
            cwd_change_handling = true,
            -- Without this, servers stay rooted at the previous worktree
            lsp_stop_on_restore = true,
            -- auto-session only wipes buffers inside a successful restore, so a
            -- directory with no session yet would inherit the previous one's buffers
            pre_cwd_changed_cmds = {
                "silent! wall",
                "silent! %bw!",
            },
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
